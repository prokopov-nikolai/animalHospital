<?php

class PluginAdmin_ActionAdminSeo extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Seo', 'seo');
        $this->SetDefaultEvent('meta');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^meta$/', 'SeoMeta');

    }

    /**
     * Список отзывов
     */
    public function SeoMeta()
    {
        if (isPost()) {
            $this->Storage_Set('seo', getRequest('seo'));
            $this->Message_AddNoticeSingle('Успешно сохранено');
        }
        $aSeo = $this->Storage_Get('seo');
        $this->Viewer_Assign('aSeo', $aSeo);
        $this->SetTemplateAction('seo.meta');
    }

}
