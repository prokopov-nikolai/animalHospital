<?php

class PluginAdmin_ActionAdminCost extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(20, 'Расходы', 'cost');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {

        /**
         * Для ajax регистрируем внешний обработчик
         */
        $this->RegisterEventExternal('AjaxCost', 'PluginAdmin_ActionAdminCost_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^add$/i', '/^$/i', 'AjaxCost::Add');
        $this->AddEventPreg('/^ajax$/i', '/^delete$/i', '/^$/i', 'AjaxCost::Delete');
    }
}
