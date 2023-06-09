<?php
/**
 * От этого класса должны быть унаследованы все екшены плагинов,
 * которые нужно интегрировать в админку
 */

class PluginAdmin_ActionPlugin extends ActionPlugin
{


    protected $oUserCurrent,
        $aBreadCrumb = array();

    /**
     * Регистрируем евенты
     *
     */
    public function Init()
    {
        /**
         * Текущий пользователь
         */
        $this->oUserCurrent = $this->User_GetUserCurrent();
        /**
         * Проверим права доступа к админке
         */
        if (!LS::Adm() && !LS::Manager()) {
            return Router::Action('admin', 'error', array('404'));
        }
        if (substr(Router::GetAction(), 0, strlen(Config::Get('plugin.admin.url'))) == Config::Get('plugin.admin.url')) {
            /**
             * Подключим нужные стили и скрипты
             */
            $this->AppendStylesAndScripts();
            /**
             * Подгрузим меню
             */
            $this->AppendMenu();
        }
    }

    /**
     * Общие стили и скрипты
     */
    private function AppendStylesAndScripts()
    {
        /**
         * Стили админки
         */
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/bootstrap.css');
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/icons-ls.css');
        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/style.css');
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/pagination.css');
//		$this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/redactor/redactor.css');
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/forms.css');
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/field.css');
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/button.css');
//		$this->Viewer_AppendStyle(Config::Get('path.framework.frontend.web').'/css/alerts.css');

        /**
         * Скрипты админки
         */
        $this->Viewer_AppendScript(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/js/init.js');
    }

    /**
     * Общие стили и скрипты
     */
    private function AppendMenu()
    {
//		$aPluginsActive = $this->Plugin_GetActivePlugins();
        $aPluginsActive = explode("\n", file_get_contents(Config::Get('path.root.server') . '/application/plugins/plugins.dat'));
        $aPluginsActive = array_keys($this->PluginManager_GetPluginsItems(array('order' => 'name')));
        $sKey = md5((LS::CurUsr() ? LS::CurUsr()->getId() : '' ).Config::Get('plugin.admin.url') . '_' . implode(',', $aPluginsActive));
        if (false === $aAdminMenu = $this->Cache_Get($sKey)) {
            $aAdminMenu = array();
            foreach ($aPluginsActive as $sPluginName) {
                $aPluginAdminMenu = Config::Get('plugin.' . $sPluginName . '.admin_menu');
                if (is_array($aPluginAdminMenu) && count($aPluginAdminMenu)) {
                    foreach ($aPluginAdminMenu as $aM) {
                        if (isset($aAdminMenu[$aM['sort']])) {
                            while (isset($aAdminMenu[$aM['sort']])) {
                                ++$aM['sort'];
                            }
                        }
                        $aAdminMenu[$aM['sort']] = $aM;
                    }
                }
            }
            ksort($aAdminMenu);
            $this->Cache_Set($aAdminMenu, $sKey, array('admin_menu'), 60 * 60 * 24 * 7);
        }
        $this->Viewer_Assign('aAdminMenu', $aAdminMenu);
    }

    /**
     * Хлебные крошки админки
     * @param int $iLevel
     * @param $sTitle
     * @param string $sUrl
     */
    public function AppendBreadCrumb($iLevel = 0, $sTitle, $sUrl = '')
    {
        if (isset($this->aBreadCrumb[$iLevel])) {
            while (isset($this->aBreadCrumb[$iLevel])) {
                ++$iLevel;
            }
        }
        $this->aBreadCrumb[$iLevel] = array('title' => $sTitle, 'url' => $sUrl);
        ksort($this->aBreadCrumb);
    }

    /**
     * Добавлеям переменные при завершении действий
     */
    public function EventShutdown()
    {
        $this->Viewer_Assign('LS_VERSION', LS_VERSION);
        $this->Viewer_Assign('aBreadCrumb', $this->aBreadCrumb);
    }

    /**
     * Метод не найден
     * @return string
     */
    public function EventNotFound()
    {
        return Router::Action('admin', 'error', array('404'));
    }

    /**
     * Отображение ошибки
     */
    public function EventError($sErrorText = null)
    {
        $aHttpErrors = array(
            '404' => array(
                'header' => '404 Not Found',
            ),
            '403' => array(
                'header' => '403 Forbidden',
            ),
            '500' => array(
                'header' => '500 Internal Server Error',
            ),
        );
        $iNumber = $this->GetParam(0);
        if (array_key_exists($iNumber, $aHttpErrors)) {
            /**
             * Смотрим есть ли сообщения об ошибках
             */
            if (!$this->Message_GetError()) {
                $this->Message_AddErrorSingle($this->Lang_Get('common.error.system.code.' . $iNumber), $iNumber);
            }
            $aHttpError = $aHttpErrors[$iNumber];
            if (isset($aHttpError['header'])) {
                $sProtocol = isset($_SERVER['SERVER_PROTOCOL']) ? $_SERVER['SERVER_PROTOCOL'] : 'HTTP/1.1';
                header("{$sProtocol} {$aHttpError['header']}");
            }
            $this->SetTemplate(Plugin::GetTemplatePath(__CLASS__).'error.default.tpl');
        } elseif ($sErrorText) {
            $this->Message_AddErrorSingle($sErrorText, $sErrorText);
            $this->SetTemplate(Plugin::GetTemplatePath(__CLASS__).'error.tpl');
        }
        $this->Viewer_AddHtmlTitle($this->Lang_Get('error'));

    }

    protected function RegisterEvent()
    {

    }
}
