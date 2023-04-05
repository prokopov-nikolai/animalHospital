<?php

$config['url'] = Config::Get('url_adm');
define('ADMIN_URL', '/' . $config['url'] . '/');

$config['admin_menu'] = [];

if (LS::Adm() || LS::Manager()) {
    /**
     * МЕНЮ
     */
    /**
     * Заказы
     */
    if (LS::HasRight('1_users')) {
        $aMenuUsesSub = [];
        if (LS::HasRight('2_users_edit')) {
            $aMenuUsesSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/users/add/',
                'lang_key' => 'plugin.admin.menu.users_add',
                'menu_key' => 'order_list'
            ];

        }
        $config['admin_menu'][] = [
            'sort' => 5,
            'url' => '/' . $config['url'] . '/users/',
            'lang_key' => 'plugin.admin.menu.users',
            'menu_key' => 'users',
            'sub' => $aMenuUsesSub
        ];
    }
}

$config['$root$']['router']['page'][$config['url']]                 = 'PluginAdmin_ActionAdmin';
$config['$root$']['router']['page'][$config['url'] . '_plugins']    = 'PluginAdmin_ActionAdminPlugins';
$config['$root$']['router']['page'][$config['url'] . '_users']       = 'PluginAdmin_ActionAdminUsers';


$config['$root$']['router']['page'][$config['url'] . '_media']      = 'PluginAdmin_ActionAdminMedia';

$config['$root$']['module']['category']['per_page'] = 21;
$config['$root$']['module']['user']['per_page'] = 20;
$config['$root$']['module']['media']['per_page'] = 24;
$config['$root$']['module']['review']['per_page'] = 20;

$config['$root$']['module']['media']['type']['media']['image']['max_size_url'] = 10 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['min_width'] = 400; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['min_height'] = 600; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['user_photo']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['user_photo']['image']['autoresize'] = true; // Максимальный размер файла в kB


$config['$root$']['users']['per_page'] = 20;

return $config;
