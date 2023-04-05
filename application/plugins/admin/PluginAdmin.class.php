<?php
/**
 * Запрещаем напрямую через браузер обращение к этому файлу.
 */
if (!class_exists('Plugin')) {
    die('Hacking attempt!');
}

class PluginAdmin extends Plugin
{
    protected $aInherits = array(
        'entity' => array(
            'ModuleAsset_EntityTypeCss' => '_ModuleAsset_EntityTypeCss',
            'ModuleAsset_EntityTypeJs' => '_ModuleAsset_EntityTypeJs'
        ),
    );

    public function Activate()
    {
        return true;
    }

    /**
     * Инициализация плагина
     */
    public function Init()
    {
        $this->Viewer_AppendStyle('/framework/frontend/components/icon/css/icons.css');
        $this->Viewer_AppendStyle('/framework/frontend/components/alert/css/alert.css');

    }
}
