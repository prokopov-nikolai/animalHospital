<?php

/**
 * Хуки
 */
class PluginAdmin_HookMain extends Hook
{
    /**
     * Регистрация необходимых хуков
     */
    public function RegisterHook()
    {
        /**
         * Хук на инициализацию экшенов
         */
        $this->AddHook('init_action', 'InitAction', __CLASS__);

    }

    /**
     * Делаем смешение ActionEvent -> Action
     * Чтобы разделить все методы по классам
     */
    public function InitAction()
    {
        $this->Viewer_Assign('ADMIN_URL', '/' . Config::Get('plugin.admin.url') . '/');
        $this->Viewer_Assign('IS_MOBILE', IS_MOBILE);
        $this->Viewer_Assign('IS_TABLET', IS_TABLET);
        $this->Viewer_Assign('PLATFORM', PLATFORM);
        $this->Viewer_Assign('BROWSER', $this->Text_Transliteration(BROWSER));
        $this->Viewer_Assign('BROWSER_VERSION', $this->Text_Transliteration(BROWSER_VERSION));
        if (Router::GetAction() == Config::Get('plugin.admin.url') && Router::GetActionEvent() && Router::GetActionEvent() != 'cache_delete') {
            $aParams = Router::GetParams();
            $sKey = Config::Get('plugin.admin.url') . '_' . Router::GetActionEvent();
            $aPage = Config::Get('router.page');
            if (isset($aPage[$sKey])) {
                return Router::Action($sKey, array_shift($aParams), $aParams);
            } else {
                return Router::Action('admin', 'error', array('404'));
            }
        }

    }
}