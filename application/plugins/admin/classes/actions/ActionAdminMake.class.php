<?php

class PluginAdmin_ActionAdminMake extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.make'), 'make');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^(page([\d]+))?$/i', 'MakeList');
        $this->AddEventPreg('/^([\d]+)$/i', 'MakeEdit');
        $this->AddEventPreg('/^add$/', 'MakeAdd');
        $this->AddEventPreg('/^collection$/', '/^([\d]+)$/i', 'MakeCollectionEdit');
        /**
         * ajax
         */
        $this->RegisterEventExternal('AjaxMake', 'PluginAdmin_ActionAdminMake_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^collection$/i', '/^change$/i', 'AjaxMake::CollectionChange');
    }

    /**
     * Список производителей
     */
    public function MakeList()
    {
        if (!LS::HasRight('17_make')) return parent::EventForbiddenAccess();
        $iPage = $this->GetEventMatch(2, 0);
        $iPage = (!$iPage ? 1 : $iPage);
        $aResult = $this->Make_GetItemsByFilter(array(
            '#sort' => array('title' => 'asc'),
            '#page' => array($iPage, Config::Get('module.user.per_page'))
        ));
        $this->Viewer_Assign('aMake', $aResult['collection']);
        $aPaging = $this->Viewer_MakePaging($aResult['count'], $iPage, Config::Get('make.per_page'), Config::Get('pagination.pages.count'), ADMIN_URL . 'make/');
        $this->Viewer_Assign('paging', $aPaging);
        $this->SetTemplateAction('make.list');
    }

    /**
     * Выводим данные по производителю
     */
    public function MakeEdit()
    {
        if (!LS::HasRight('17_make')) return parent::EventForbiddenAccess();
        $oMake = $this->Make_GetById($this->GetParamEventMatch(0));
        $this->MakeSubmit($oMake);
        /**
         * Получим пользователя по айди из урла
         */
        $this->AppendBreadCrumb(20, $oMake->getTitle());
        $this->Viewer_Assign('oMake', $oMake);
        $this->SetTemplateAction('make.edit');
    }

    /**
     * Оброботка формы производителя
     * @param $oMake
     */
    private function MakeSubmit(&$oMake)
    {
        if (!LS::HasRight('17_make')) return parent::EventForbiddenAccess();
        if (isPost()) {
            $aMake = getRequest('make');
            $aMake['groups'] = json_encode($aMake['groups']);
            $oMake->_setData($aMake);
            $oMake->setUrl($this->Main_GetUrl(translit($oMake->getUrl()), 'make'));
            if ($oMake->_Validate()) {
                $oMake->Update();
                $this->Message_AddNoticeSingle('Успешно обновлено', 'Внимание');
            } else {
                $this->Viewer_Assign('oMake', $oMake);
                $this->Message_AddError($oMake->_getValidateError(), $this->Lang_Get('error'));
            }
        }
    }

    /**
     * Расскидываем ткани производителя по категориям
     */
    public function MakeCollectionEdit()
    {
        if (!LS::HasRight('17_make')) return parent::EventForbiddenAccess();
        $oMake = $this->Make_GetById($this->GetParamEventMatch(0, 0));
        $this->AppendBreadCrumb(20, $oMake->getTitle(), $oMake->getId());
        $this->AppendBreadCrumb(30, 'Коллекции');
        $aCollection = $this->Collection_GetItemsByFilter([
            '#select' => ['t.*', 'mc.make_group'],
            '#join' => [
                'LEFT JOIN '.Config::Get('db.table.prefix').'make_collections mc ON mc.collection_id = t.id AND mc.make_id = '.$oMake->getId()
            ],
            '#order' => ['supplier' => 'asc', 'title' => 'asc']
        ]);
        $aMakeCollection = [];
        foreach ($aCollection as $oC) {
            $aMakeCollection[$oC->getSupplier()][$oC->getId()] = $oC;
        }
        $this->Viewer_Assign('aMakeCollection', $aMakeCollection);
        $this->Viewer_Assign('oMake', $oMake);
        $this->Viewer_Assign('aMakeGroupsForSelect', $oMake->getGroupsArrayForSelect());
        $this->SetTemplateAction('make.collection.edit');
    }

    /**
     * Добавление производителя
     */
    public function MakeAdd()
    {
        if (!LS::HasRight('17_make')) return parent::EventForbiddenAccess();
        $oMake = Engine::GetEntity('Make', [
            'title' => getRequestStr('make')
        ]);
        $oMake->setUrl($this->Main_GetUrl(translit($oMake->getTitle()), 'make'));
        $oMake->Add();
        $this->Message_AddNoticeSingle('Производитель успешно добавлен');
        return Router::Location(ADMIN_URL.'make/edit/'.$oMake->getId().'/');
    }
}
