<?php

class PluginAdmin_ActionAdminOption extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.option'), 'option');
        $this->SetDefaultEvent('list');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^list$/i', 'OptionList');
        $this->AddEventPreg('/^([\d]+)$/i', 'OptionEdit');
        $this->AddEventPreg('/^add$/', 'OptionAdd');
        /**
         * ajax
         */
        $this->RegisterEventExternal('AjaxOption', 'PluginAdmin_ActionAdminOption_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^value$/i', '/^add$/i', 'AjaxOption::ValueAdd');
        $this->AddEventPreg('/^ajax$/i', '/^value$/i', '/^update$/i', 'AjaxOption::ValueUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^value$/i', '/^sort$/i', 'AjaxOption::ValueSort');
        $this->AddEventPreg('/^ajax$/i', '/^value$/i', '/^delete$/i', 'AjaxOption::ValueDelete');
    }

    /**
     * Список производителей
     */
    public function OptionList()
    {
        if (!LS::HasRight('35_option')) return parent::EventForbiddenAccess();
       $aOption = $this->Option_GetItemsByFilter(array(
            '#sort' => array('title' => 'asc'),
        ));
        $this->Viewer_Assign('aOption', $aOption);
        $this->SetTemplateAction('option.list');
    }

    /**
     * Выводим данные по производителю
     */
    public function OptionEdit()
    {
        if (!LS::HasRight('35_option')) return parent::EventForbiddenAccess();
        $oOption = $this->Option_GetById($this->GetEventMatch(1));
        $this->OptionSubmit($oOption);
        /**
         * Получим пользователя по айди из урла
         */
        $this->AppendBreadCrumb(20, $oOption->getTitle());
        $this->Viewer_Assign('oOption', $oOption);
        $this->SetTemplateAction('option.edit');
    }

    /**
     * Оброботка формы производителя
     * @param $oMake
     */
    private function OptionSubmit(&$oOption)
    {
        if (!LS::HasRight('35_option')) return parent::EventForbiddenAccess();
        if (isPost()) {
            $aOption = getRequest('option');
            $oOption->_setData($aOption);
            if ($oOption->_Validate()) {
                $oOption->Update();
                $this->Message_AddNoticeSingle('Успешно обновлено', 'Внимание');
            } else {
                $this->Viewer_Assign('oOption', $oOption);
                $this->Message_AddError($oOption->_getValidateError(), $this->Lang_Get('error'));
            }
        }
    }

    /**
     * Добавление опции
     */
    public function OptionAdd()
    {
        if (!LS::HasRight('35_option')) return parent::EventForbiddenAccess();
        $oOption = Engine::GetEntity('Option', [
            'title' => getRequestStr('option')
        ]);
        $oOption->Add();
        $this->Message_AddNoticeSingle('Опция успешно добавлена');
        return Router::Location(ADMIN_URL.'option/'.$oOption->getId().'/');
    }
}