<?php

class PluginAdmin_ActionAdminSettings extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Настройки', 'settings');
        $this->SetDefaultEvent('template');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^template$/', 'Template');
        $this->AddEventPreg('/^direct$/', '/^delete$/', '/^([a-z0-9\-\_]+)$/', 'DirectDelete');
        $this->AddEventPreg('/^direct$/', 'Direct');

    }

    /**
     * Настройки шаблона
     */
    public function Template()
    {
        $this->AppendBreadCrumb(20, 'Шаблона', 'template');
        if (isPost()) {
            $this->Storage_Set('template', getRequest('template'));
            $this->Message_AddNoticeSingle('Успешно сохранено', false, true);
            return Router::Location(ADMIN_URL.'settings/template/');
        }
        $this->Viewer_Assign('aTemplate', $this->Storage_Get('template'));
        $this->SetTemplateAction('template');
    }

    /**
     * Удаляем номер из подмены
     */
    public function DirectDelete()
    {
        $sUtmSource = $this->GetParamEventMatch(1, 0);
        $aDirect = $this->Storage_Get('direct');
        if (isset($aDirect[$sUtmSource])) {
            unset($aDirect[$sUtmSource]);
            $this->Storage_Set('direct', $aDirect);
            $this->Message_AddNoticeSingle('Успешно удалено', false, true);
        }
        return Router::Location(ADMIN_URL.'settings/direct/');
    }

    /**
     * Подмена номеров
     */
    public function Direct()
    {
        $this->AppendBreadCrumb(20, 'Подмена номеров', 'direct');
        $aDirect = $this->Storage_Get('direct');
        if (!is_array($aDirect)) $aDirect = [];
        if (isPost()){
            $aDirect[getRequestStr('utm_source')] = getRequestStr('phone');
            $this->Storage_Set('direct', $aDirect);
        }
        $this->Viewer_Assign('aDirect', $aDirect);
        $this->SetTemplateAction('direct');
    }
}
