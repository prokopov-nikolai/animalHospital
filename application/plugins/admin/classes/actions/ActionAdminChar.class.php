<?php

class PluginAdmin_ActionAdminChar extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Характеристики', 'char');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        /**
         * Категории
         */
        $this->AddEvent('Add', 'CharAdd');
        $this->AddEventPreg('~^edit$~', '~^\d+$~', 'CharEdit');
        $this->AddEventPreg('~^delete$~', '~^\d+$~', 'CharDelete');
        $this->AddEvent('', 'CharList');

        /**
         * ajax
         */
        $this->RegisterEventExternal('AjaxChar', 'PluginAdmin_ActionAdminChar_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^sort$/i',  'AjaxChar::Sort');
        $this->AddEventPreg('/^ajax$/i', '/^search$/i',  'AjaxChar::Search');
        $this->AddEventPreg('/^ajax$/i', '/^get-html$/i',  'AjaxChar::GetHtml');

    }

    /**
     * Обработка добавления характеристики
     */
    public function CharAdd()
    {
        if (!LS::HasRight('14_char')) return parent::EventForbiddenAccess();
        if (isPost('char_name')) {
            $oChar = Engine::GetEntity('Char');
            $oChar->setTitle(getRequestStr('char_name'));
            $oChar->setUrl($this->Main_GetUrl(getRequestStr('char_name'), 'char'));
            $oChar->Add();
            $this->Message_AddNoticeSingle('Характеристика успешно добавлен', false, true);
            return  Router::Location(ADMIN_URL.'char/edit/'.$oChar->getId().'/');
        }
    }

    /**
     * Список характеристик
     */
    public function CharList()
    {
        if (!LS::HasRight('14_char')) return parent::EventForbiddenAccess();
        $aChar = $this->Char_GetItemsByFilter(['#order' => ['sort'=>'asc']]);
        $this->Viewer_Assign('aChar', $aChar);
        $this->SetTemplateAction('char.list');
    }

    /**
     * Редактирование характеристики
     */
    public function CharEdit()
    {
        if (!LS::HasRight('14_char')) return parent::EventForbiddenAccess();
        $iCharId = (int)Router::GetParam(0);
        $this->AppendBreadCrumb(20, 'Редактирование', 'edit');
        $this->SubmitChar($iCharId);
        $this->Viewer_Assign('oChar', $this->Char_GetCharById($iCharId));
        $this->Viewer_Assign('bAction', 'edit');
        $this->SetTemplateAction('char.edit');
    }

    private function SubmitChar($iCharId = null)
    {
        if ($aChar = getRequest('char', null, 'post')) {
            /**
             * Чистим Кеш
             */
            $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('char_add', 'char_edit'));
            if ($iCharId) {
                $oChar = $this->Char_GetCharById($iCharId);
            } else {
                $oChar = Engine::GetEntity('Char');
            }
            $oChar->_setData($aChar);
            $oChar->setValsByText($aChar['vals']);

            if ($oChar->_Validate()) {
                $oChar->Save();
                $this->Message_AddNotice('Успешно', 'Выполнено', true);
                return Router::Location('/' . Config::Get('plugin.admin.url') . '/char/edit/' . $oChar->getId() . '/');
            } else {
                $this->Viewer_Assign('oChar', $oChar);
                $this->Message_AddError($oChar->_getValidateError(), $this->Lang_Get('error'));
            }
        }
    }

    /**
     * Удаление характеристики
     */
    public function CharDelete()
    {
        $iCharId = (int)Router::GetParam(0);
        $oChar = $this->Char_GetCharById($iCharId);
        if (!$oChar) return parent::EventNotFound();
        $this->Message_AddNoticeSingle('Характеристика "'.$oChar->getTitle().'" успешно удалена', false, true);
        $oChar->Delete();
        Router::Location(ADMIN_URL.'char/');
    }
}
