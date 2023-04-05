<?php

$config['url'] = Config::Get('url_adm');
define('ADMIN_URL', '/' . $config['url'] . '/');

$config['admin_menu'] = [];

if (LS::Adm() || LS::Manager()) {
    /**
     * МЕНЮ
     */


    if (LS::HasRight('4_pets')) {
        $aMenuPetsSub = [];
        if (LS::HasRight('5_pets_edit')) {
            $aMenuPetsSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/pets/add/',
                'lang_key' => 'plugin.admin.menu.pets_add',
                'menu_key' => 'pets_add'
            ];

        }
        $config['admin_menu'][] = [
            'sort' => 5,
            'url' => '/' . $config['url'] . '/pets/',
            'lang_key' => 'plugin.admin.menu.pets',
            'menu_key' => 'pets',
            'sub' => $aMenuPetsSub
        ];
    }
    if (LS::HasRight('1_users')) {
        $aMenuUsesSub = [];
        if (LS::HasRight('2_users_edit')) {
            $aMenuUsesSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/users/add/',
                'lang_key' => 'plugin.admin.menu.users_add',
                'menu_key' => 'users_add'
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
$config['$root$']['router']['page'][$config['url'] . '_pets']       = 'PluginAdmin_ActionAdminPets';
$config['$root$']['router']['page'][$config['url'] . '_users']       = 'PluginAdmin_ActionAdminUsers';


$config['$root$']['router']['page'][$config['url'] . '_media']      = 'PluginAdmin_ActionAdminMedia';

$config['$root$']['module']['user']['per_page'] = 20;
$config['$root$']['module']['pets']['per_page'] = 20;
$config['$root$']['module']['media']['per_page'] = 24;

$config['$root$']['module']['media']['type']['media']['image']['max_size_url'] = 10 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['min_width'] = 400; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['min_height'] = 600; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['user_photo']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['user_photo']['image']['autoresize'] = true; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['pet_photo']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['pet_photo']['image']['autoresize'] = true; // Максимальный размер файла в kB

$config['$root$']['pets_species_items'] = [
    ['text' => 'Кошка', 'value' => 'cat'],
    ['text' => 'Собака', 'value' => 'dog'],
];

return $config;
