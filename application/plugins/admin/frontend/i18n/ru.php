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
        'make' => 'Производители',
        'make_collection' => 'Кол-ции тканей',
        'user' => 'Пользователи',
        'order' => 'Заказы',
        'order_tasks' => 'Задачи',
        'category' => 'Категории',
        'category_filter' => 'Категории фильтры',
        'product' => 'Товары',
        'collection' => 'Коллекции тканей',
        'char' => 'Характеристики',
        'option' => 'Опции',
        'blog' => 'Блог',
        'blog_blogs' => 'Разделы',
        'blog_topic' => 'Статьи',
        'review' => 'Отзывы',
        'media' => 'Изображения',
        'seo' => 'Seo',
        'settings' => 'Настройки',
        'settings_template' => 'Шаблон',
        'settings_direct' => 'Подмена номеров',
        'report' => 'Отчеты',
        'report_agent' => 'Агентские',
        'report_costs' => 'Расходы',
        'report_salary' => 'Зарплата',
        'report_summary' => 'Сводный',
        'report_delivery' => 'Доставка',
        'report_failure' => 'Отказы',
        'coupon' => 'Купоны',
        'analytics' => 'Аналитика',
        'analytics_proceeds' => 'Продажи',
        'analytics_top30' => 'ТОП-30',
        'analytics_manufactures' => 'Фабрики',
        'analytics_reclamations' => 'Рекламации',
        'analytics_managers' => 'Менеджеры',
        'analytics_colors' => 'Цвета/Ткани',
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
