<?php

$oLs = Engine::getInstance();
$oLs->Lang_AddMessage('admin', array(
    'plugins' => array(
        'notices' => array(
            'activation_file_write_error' => 'Файл plugins.dat не доступен для записи',
            'action_ok' => 'Успешно выполнено'
        )
    )
));

return array(
    'menu' => array(
        'users' => 'Пользователи',
        'users_add' => 'Добавить'
    ),
    'breadcrumbs' => array(
        'start' => 'Начало'
    ),
    'button' => array(
        'add' => 'Добавить',
        'edit' => 'Редактировать',
        'delete' => 'Удалить',
        'update' => 'Обновить',
        'save' => 'Сохранить',
        'view' => 'Просмотр',
    ),
    'message' => array(
        'add_success' => 'Успешно добавлено',
        'delete_success' => 'Успешно удалено',
        'update_success' => 'Успешно обновлено'
    ),
    'plugin' => array(
        'deactivate' => 'Деактивировать',
        'activate' => 'Активировать'
    ),
);
