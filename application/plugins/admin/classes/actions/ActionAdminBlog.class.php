<?php

class PluginAdmin_ActionAdminBlog extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(20, 'Блог', 'blog');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {

        $this->AddEventPreg('/^add$/i', 'BlogAdd');
        $this->AddEventPreg('/^blogs$/i', 'BlogList');
        $this->AddEventPreg('/^(page(\d+))?$/i', 'BlogList');
        $this->AddEventPreg('/^([0-9]+)?$/i', 'BlogEdit');
        $this->AddEventPreg('/^topic$/i', '/^add$/i', 'BlogTopicAdd');
        $this->AddEventPreg('/^topic$/i', '/^([0-9]+)$/i', 'BlogTopicEdit');
        $this->AddEventPreg('/^topic$/i', '/^(page(\d+))?$/i', 'BlogTopics');

        /**
         * Для ajax регистрируем внешний обработчик
         */
//        $this->RegisterEventExternal('AjaxCategory', 'PluginAdmin_ActionAdminCategory_EventAjax');
//        $this->AddEventPreg('/^ajax$/i', '/^search$/i', '/^filter$/i', 'AjaxCategory::SearchFilter');
    }

    /**
     * Добавление раздела
     */
    public function BlogAdd()
    {
        if (!LS::HasRight('22_blog_blogs')) return parent::EventForbiddenAccess();
        $oDate = new DateTime();
        $oBlog = Engine::GetEntity('Blog', ['date_add' => $oDate->format('Y-m-d H:i:s')]);
        $oBlog->Add();
        $oBlog->setTitle('Новый раздел #' . $oBlog->getId());
        $oBlog->Update();
        Router::Location(ADMIN_URL . 'blog/' . $oBlog->getId() . '/');
    }

    /**
     * Редактирование раздела
     */
    public function BlogEdit()
    {
        if (!LS::HasRight('22_blog_blogs')) return parent::EventForbiddenAccess();
        $iBlogId = $this->GetEventMatch(1);
        $oBlog = $this->Blog_GetById($iBlogId);
        if (!$oBlog) return parent::EventNotFound();
        if (isPost()) {
            $aBlog = getRequest('blog');
            if (!$oBlog->getUrl() || getRequest('update_url')) {
                $aBlog['url'] = $this->Main_GetUrl($aBlog['title'], 'blog_topic');
            }
            $oBlog->_setData($aBlog);
            $oBlog->Update();
            /**
             * Превью раздела
             */
            $sTargetType = 'blog_preview';
            if ($_FILES[$sTargetType]['tmp_name']) {
                $oMedia = $this->Media_GetMediaByFilter([
                    'target_type' => $sTargetType,
                    'target_id' => $oBlog->getId()
                ]);
                $mMedia = $this->Media_UploadUrl($_FILES[$sTargetType]['tmp_name'], $sTargetType, $oBlog->getId());
                if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                    $this->Message_AddError($mMedia);
                } else {
                    /**
                     * Удалим старую превью
                     */
                    if ($oMedia) $oMedia->Delete();
                }
            }
            $this->Message_AddNoticeSingle('Успешно обновлено');
        }
        $this->Viewer_Assign('oBlog', $oBlog);
        $this->AppendBreadCrumb(30, 'Разделы', 'blogs');
        $this->AppendBreadCrumb(40, $oBlog->getTitle());
        $this->SetTemplateAction('blog.edit');
    }

    /**
     * Список разделов блога
     */
    public function BlogList()
    {
        if (!LS::HasRight('20_blog')) return parent::EventForbiddenAccess();
        $this->Viewer_Assign('aBlog', $this->Blog_GetBlogItemsByFilter([
            '#order' => ['id' => 'desc']
        ]));
        $this->AppendBreadCrumb(30, 'Разделы', 'blogs');
        $this->SetTemplateAction('blog.list');
    }

    /**
     * Список статей раздела
     */
    public function BlogTopics()
    {
        if (!LS::HasRight('21_blog_topics')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Статьи', 'topic');
        $iPage = $this->GetParamEventMatch(0, 2);
        $iPage = $iPage ? $iPage : 1;
        $iPerPage = Config::Get('blog.per_page');
        $aTopic = $this->Blog_GetTopicItemsByFilter([
            '#select' => ["t.*, CONCAT(b.url, '/', t.url) url_full, b.title blog_title"],
            '#join' => [
                'LEFT JOIN ' . Config::Get('db.table.blog') . ' b ON b.id = t.blog_id'
            ],
            '#order' => ['id' => 'desc'],
            '#page' => [$iPage, $iPerPage]
        ]);
        if ($iPage > 1 && count($aTopic['collection']) == 0) return parent::EventNotFound();
        $aPaging = $this->Viewer_MakePaging($aTopic['count'], $iPage, $iPerPage, Config::Get('pagination.pages.count'), ADMIN_URL . 'blog/topic/', $_GET);
        $this->Viewer_Assign('aPaging', $aPaging);
        $this->Viewer_Assign('aTopic', $aTopic['collection']);
        $this->SetTemplateAction('topic.list');
    }

    /**
     * Добавление статьи
     */
    public function BlogTopicAdd()
    {
        if (!LS::HasRight('21_blog_topics')) return parent::EventForbiddenAccess();
        $oDate = new DateTime();
        $oTopic = Engine::GetEntity('Blog_Topic', ['date_add' => $oDate->format('Y-m-d H:i:s')]);
        $oTopic->Add();
        $oTopic->setTitle('Новый топик #' . $oTopic->getId());
        $oTopic->Update();
        Router::Location(ADMIN_URL . 'blog/topic/' . $oTopic->getId() . '/');
    }

    /**
     * Редактирование статьи
     */
    public function BlogTopicEdit()
    {
        if (!LS::HasRight('21_blog_topics')) return parent::EventForbiddenAccess();
        $iTopicId = $this->GetParamEventMatch(0, 1);
        $oTopic = $this->Blog_GetTopicById($iTopicId);
        if (!$oTopic) return parent::EventNotFound();
        if (isPost()) {
            $aTopic = getRequest('topic');
            if (!$oTopic->getUrl() && !$aTopic['url']) {
                $aTopic['url'] = $this->Main_GetUrl($aTopic['title'], 'blog_topic');
            } elseif ($aTopic['url']) {
                $oT = $this->Blog_getTopicByUrl($aTopic['url']);
                if ($oT && $oT->getId() == $oTopic->getId()) {
                    // урл не изменился
                } else {
                    if ($oT) {
                        // если топик с таким урлом уже есть, то уникализируем его
                        $aTopic['url'] = $this->Main_GetUrl($aTopic['url'], 'blog_topic');
                    } else {
                        // оставляем тот который вбили
                    }

                }
            } else {
                $aTopic['url'] = $this->Main_GetUrl($aTopic['title'], 'blog_topic');
            }
            $oTopic->_setData($aTopic);
            if ($oTopic->_validate()) {
                $oTopic->Update();
                /**
                 * Превью топика
                 */
                $sTargetType = 'topic_preview';
                if ($_FILES[$sTargetType]['tmp_name']) {
                    $oMedia = $this->Media_GetMediaByFilter([
                        'target_type' => $sTargetType,
                        'target_id' => $oTopic->getId()
                    ]);
                    $mMedia = $this->Media_UploadUrl($_FILES[$sTargetType]['tmp_name'], $sTargetType, $oTopic->getId());
                    if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                        $this->Message_AddError($mMedia);
                    } else {
                        /**
                         * Удалим старую превью
                         */
                        if ($oMedia) $oMedia->Delete();
                    }
                }
                $this->Message_AddNoticeSingle('Успешно обновлено');
            } else {
                $this->Message_AddErrorSingle($oTopic->_getValidateError());
            }
        }
        $oTopic = $this->Blog_GetTopicByFilter([
            '#select' => ["t.*, CONCAT(b.url, '/', t.url) url_full, b.title blog_title"],
            '#join' => [
                'LEFT JOIN ' . Config::Get('db.table.blog') . ' b ON b.id = t.blog_id'
            ],
            '#where' => ['t.id = ?d' => [$iTopicId]]
        ]);
        $this->Viewer_Assign('aBlogSelect', $this->Blog_GetListForSelect());
        $this->Viewer_Assign('oTopic', $oTopic);
        $this->AppendBreadCrumb(30, 'Статьи', 'topic');
        $this->AppendBreadCrumb(40, $oTopic->getTitle());
        $this->SetTemplateAction('topic.edit');
    }
}
