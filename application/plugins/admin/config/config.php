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
    if (LS::HasRight('1_order')) {
        $aMenuOrderSub = [];
        if (LS::HasRight('2_order_change')) {
            $aMenuOrderSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/order/',
                'lang_key' => 'plugin.admin.menu.order',
                'menu_key' => 'order_list'
            ];
            $aMenuOrderSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/order/tasks/',
                'lang_key' => 'plugin.admin.menu.order_tasks',
                'menu_key' => 'order_tasks'
            ];
        }

//        if (LS::HasRight('3_order_salary')) {
//            $aMenuOrderSub[] = [
//                'sort' => 0,
//                'url' => '/' . $config['url'] . '/order/salary/',
//                'lang_key' => 'plugin.admin.menu.order_salary',
//                'menu_key' => 'order_salary'
//            ];
//        }
        if (LS::HasRight('4_order_agent_wages')) {
            $aMenuOrderSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/order/agent-wages/',
                'lang_key' => 'plugin.admin.menu.agent_wages',
                'menu_key' => 'order_agent_wages'
            ];
        }
        $config['admin_menu'][] = [
            'sort' => 5,
            'url' => '/' . $config['url'] . '/order/',
            'lang_key' => 'plugin.admin.menu.order',
            'menu_key' => 'order',
            'sub' => $aMenuOrderSub
        ];
    }
    /**
     * Отчеты
     */
    if (LS::HasRight('23_report')) {
        $aMenuReportSub = [];
        if (LS::HasRight('24_report_costs')) {
            $aMenuReportSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/report/costs/',
                'lang_key' => 'plugin.admin.menu.report_costs',
                'menu_key' => 'report_costs'
            ];
        }
        if (LS::HasRight('41_report_summary')) {
            $aMenuReportSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/report/summary/',
                'lang_key' => 'plugin.admin.menu.report_summary',
                'menu_key' => 'report_summary'
            ];
        }
        if (LS::HasRight('25_report_agent')) {
            $aMenuReportSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/report/agent/',
                'lang_key' => 'plugin.admin.menu.report_agent',
                'menu_key' => 'report_agent'
            ];
        }
        if (LS::HasRight('3_report_salary')) {
            $aMenuReportSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/report/salary/',
                'lang_key' => 'plugin.admin.menu.report_salary',
                'menu_key' => 'report_salary'
            ];
        }
        if (LS::HasRight('4_report_delivery')) {
            $aMenuReportSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/report/delivery/',
                'lang_key' => 'plugin.admin.menu.report_delivery',
                'menu_key' => 'report_delivery'
            ];
        }
        if (LS::HasRight('37_report_failure')) {
            $aMenuReportSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/report/failure/',
                'lang_key' => 'plugin.admin.menu.report_failure',
                'menu_key' => 'report_failure'
            ];
        }
        $config['admin_menu'][] = [
            'sort' => 5,
            'url' => '/' . $config['url'] . '/report/',
            'lang_key' => 'plugin.admin.menu.report',
            'menu_key' => 'report',
            'sub' => $aMenuReportSub
        ];
    }
    /**
     * Товары
     */
    if (LS::HasRight('5_product')) {
        $aMenuProductSub = [];
        if (LS::HasRight('6_product_edit')) {
            $aMenuProductSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/product/',
                'lang_key' => 'Товары',
                'menu_key' => 'product'
            ];
        }
        if (LS::HasRight('7_product_design_edit')) {
            $aMenuProductSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/product/design/',
                'lang_key' => 'Дизайны',
                'menu_key' => 'design'
            ];
        }
        if (LS::HasRight('8_product_discount')) {
            $aMenuProductSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/product/discount/',
                'lang_key' => 'Скидки',
                'menu_key' => 'discount'
            ];
        }
        if (LS::HasRight('33_product_margin')) {
            $aMenuProductSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/product/margin/',
                'lang_key' => 'Наценка',
                'menu_key' => 'margin'
            ];
        }
        $aMenuProductSub[] = [
            'sort' => 0,
            'url' => '/pricelist/',
            'lang_key' => 'Прайслист',
            'menu_key' => 'pricelist'
        ];
        $config['admin_menu'][] = [
            'sort' => 6,
            'url' => '/' . $config['url'] . '/product/',
            'lang_key' => 'plugin.admin.menu.product',
            'menu_key' => 'product',
            'sub' => $aMenuProductSub
        ];
    }
    /**
     * Купоны
     */
    if (LS::HasRight('36_coupon')) {
        $config['admin_menu'][] = [
            'sort' => 5,
            'url' => '/' . $config['url'] . '/coupon/',
            'lang_key' => 'plugin.admin.menu.coupon',
            'menu_key' => 'coupon',

        ];
    }
    /**
     * Коллекции
     */
    if (LS::HasRight('9_collection')) {
        $config['admin_menu'][] = [
            'sort' => 7,
            'url' => '/' . $config['url'] . '/collection/',
            'lang_key' => 'plugin.admin.menu.collection',
            'menu_key' => 'collection',

        ];
    }
    /**
     * Категории
     */
    if (LS::HasRight('11_category')) {
        $aMenuCategorySub = [];
//        if (LS::HasRight('12_category_change')) {
//            $aMenuCategorySub[] = [
//                'sort' => 0,
//                'url' => '/' . $config['url'] . '/category/',
//                'lang_key' => 'plugin.admin.menu.category',
//                'menu_key' => 'category'
//            ];
//        }
//        if (LS::HasRight('13_category_filter')) {
//            $aMenuCategorySub[] = [
//                'sort' => 0,
//                'url' => '/' . $config['url'] . '/category/filter/',
//                'lang_key' => 'plugin.admin.menu.category_filter',
//                'menu_key' => 'category_filter'
//            ];
//        }
        $config['admin_menu'][] = [
            'sort' => 10,
            'url' => '/' . $config['url'] . '/category/',
            'lang_key' => 'plugin.admin.menu.category',
            'menu_key' => 'category',
//            'sub' => $aMenuCategorySub
        ];
    }
    /**
     * Характеристики
     */
    if (LS::HasRight('14_char')) {
        $config['admin_menu'][] = [
            'sort' => 11,
            'url' => '/' . $config['url'] . '/char/',
            'lang_key' => 'plugin.admin.menu.char',
            'menu_key' => 'char'
        ];
    }
    /**
     * Опции
     */
    if (LS::HasRight('35_option')) {
        $config['admin_menu'][] = [
            'sort' => 11,
            'url' => '/' . $config['url'] . '/option/',
            'lang_key' => 'plugin.admin.menu.option',
            'menu_key' => 'option'
        ];
    }
    /**
     * Пользователи
     */
    if (LS::HasRight('15_user')) {
        $config['admin_menu'][] = [
            'sort' => 100,
            'url' => '/' . $config['url'] . '/user/',
            'lang_key' => 'plugin.admin.menu.user',
            'menu_key' => 'user',
        ];
    }
    /**
     * Производители
     */
    if (LS::HasRight('17_make')) {
        $config['admin_menu'][] = [
            'sort' => 100,
            'url' => '/' . $config['url'] . '/make/',
            'lang_key' => 'plugin.admin.menu.make',
            'menu_key' => 'make'
        ];
    }
    /**
     * Блог
     */
    if (LS::HasRight('20_blog')) {
        $aMenuBlogSub = [];
        if (LS::HasRight('21_blog_topics')) {
            $aMenuBlogSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/blog/topic/',
                'lang_key' => 'plugin.admin.menu.blog_topic',
                'menu_key' => 'blog_topic'
            ];
        }
        if (LS::HasRight('22_blog_blogs')) {
            $aMenuBlogSub[] = [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/blog/',
                'lang_key' => 'plugin.admin.menu.blog_blogs',
                'menu_key' => 'blog_blogs'
            ];
        }
        $config['admin_menu'][] = [
            'sort' => 100,
            'url' => '/' . $config['url'] . '/blog/topic/',
            'lang_key' => 'plugin.admin.menu.blog',
            'menu_key' => 'blog',
            'sub' => $aMenuBlogSub
        ];
    }

    /**
     * SEO
     */
    if (LS::HasRight('27_seo')) {
        $config['admin_menu'][] = [
            'sort' => 110,
            'url' => '/' . $config['url'] . '/seo/',
            'lang_key' => 'plugin.admin.menu.seo',
            'menu_key' => 'seo'
        ];
    }
    /**
     * Настройки
     */
    if (LS::HasRight('26_settings')) {
        $config['admin_menu'][] = [
            'sort' => 110,
            'url' => '/' . $config['url'] . '/settings/',
            'lang_key' => 'plugin.admin.menu.settings',
            'menu_key' => 'settings',
            'sub' => [
            [
                'sort' => 0,
                'url' => '/' . $config['url'] . '/settings/direct/',
                'lang_key' => 'direct',
                'menu_key' => 'direct'
            ]
        ]
        ];
    }
    /**
     * Отзывы
     */
    if (LS::HasRight('28_review')) {
        $config['admin_menu'][] = [
            'sort' => 105,
            'url' => '/' . $config['url'] . '/review/',
            'lang_key' => 'plugin.admin.menu.review',
            'menu_key' => 'review'
        ];
    }

    /**
     * Аналитика
     */
    if (LS::HasRight('42_analytics')) {
        $aSub = [
            [
                'url' => '/' . $config['url'] . '/analytics/proceeds/',
                'lang_key' => 'plugin.admin.menu.analytics_proceeds',
                'menu_key' => 'analytics_proceeds',
            ],
            [
                'url' => '/' . $config['url'] . '/analytics/colors/',
                'lang_key' => 'plugin.admin.menu.analytics_colors',
                'menu_key' => 'analytics_colors',
            ],
            [
                'url' => '/' . $config['url'] . '/analytics/top30/',
                'lang_key' => 'plugin.admin.menu.analytics_top30',
                'menu_key' => 'analytics_top30',
            ],
            [
                'url' => '/' . $config['url'] . '/analytics/managers/',
                'lang_key' => 'plugin.admin.menu.analytics_managers',
                'menu_key' => 'analytics_managers',
            ],
            [
                'url' => '/' . $config['url'] . '/analytics/manufactures/',
                'lang_key' => 'plugin.admin.menu.analytics_manufactures',
                'menu_key' => 'analytics_manufactures',
            ],
            [
                'url' => '/' . $config['url'] . '/analytics/reclamations/',
                'lang_key' => 'plugin.admin.menu.analytics_reclamations',
                'menu_key' => 'analytics_reclamations',
            ]
        ];
        if (($oCurUsr = LS::CurUsr()) && $oCurUsr->getId() == 1) {

        }
        $config['admin_menu'][] = [
            'sort' => 0,
            'url' => '/' . $config['url'] . '/analytics/',
            'lang_key' => 'plugin.admin.menu.analytics',
            'menu_key' => 'analytics',
            'sub' => $aSub
        ];
    }
}

$config['$root$']['router']['page'][$config['url']]                 = 'PluginAdmin_ActionAdmin';
$config['$root$']['router']['page'][$config['url'] . '_plugins']    = 'PluginAdmin_ActionAdminPlugins';
$config['$root$']['router']['page'][$config['url'] . '_user']       = 'PluginAdmin_ActionAdminUser';

$config['$root$']['router']['page'][$config['url'] . '_analytics']       = 'PluginAdmin_ActionAdminAnalytics';
$config['$root$']['router']['page'][$config['url'] . '_blog']       = 'PluginAdmin_ActionAdminBlog';
$config['$root$']['router']['page'][$config['url'] . '_category']   = 'PluginAdmin_ActionAdminCategory';
$config['$root$']['router']['page'][$config['url'] . '_char']       = 'PluginAdmin_ActionAdminChar';
$config['$root$']['router']['page'][$config['url'] . '_collection'] = 'PluginAdmin_ActionAdminCollection';
$config['$root$']['router']['page'][$config['url'] . '_cost']       = 'PluginAdmin_ActionAdminCost';
$config['$root$']['router']['page'][$config['url'] . '_coupon']     = 'PluginAdmin_ActionAdminCoupon';
$config['$root$']['router']['page'][$config['url'] . '_make']       = 'PluginAdmin_ActionAdminMake';
$config['$root$']['router']['page'][$config['url'] . '_option']     = 'PluginAdmin_ActionAdminOption';
$config['$root$']['router']['page'][$config['url'] . '_order']      = 'PluginAdmin_ActionAdminOrder';
$config['$root$']['router']['page'][$config['url'] . '_product']    = 'PluginAdmin_ActionAdminProduct';
$config['$root$']['router']['page'][$config['url'] . '_review']     = 'PluginAdmin_ActionAdminReview';
$config['$root$']['router']['page'][$config['url'] . '_seo']        = 'PluginAdmin_ActionAdminSeo';
$config['$root$']['router']['page'][$config['url'] . '_settings']   = 'PluginAdmin_ActionAdminSettings';
$config['$root$']['router']['page'][$config['url'] . '_report']     = 'PluginAdmin_ActionAdminReport';

$config['$root$']['router']['page'][$config['url'] . '_media']      = 'PluginAdmin_ActionAdminMedia';

$config['$root$']['module']['category']['per_page'] = 21;
$config['$root$']['module']['user']['per_page'] = 20;
$config['$root$']['module']['media']['per_page'] = 24;
$config['$root$']['module']['review']['per_page'] = 20;

$config['$root$']['module']['media']['type']['media']['image']['max_size_url'] = 10 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['min_width'] = 400; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['min_height'] = 600; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['design']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['design']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['design']['image']['min_width'] = 1200; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['design']['image']['min_height'] = 1200; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['product']['image']['max_size_url'] = 5 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['product']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['product']['image']['min_width'] = 1200; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['product']['image']['min_height'] = 1200; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['3d']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['3d']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['3d']['image']['min_width'] = 1200; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['3d']['image']['min_height'] = 1200; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['collection']['image']['max_size_url'] = 600; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['collection']['image']['autoresize'] = true; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['collection']['image']['min_width'] = 600; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['collection']['image']['max_width'] = 1000; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['collection']['image']['min_height'] = 600; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['option_value']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['option_value']['image']['autoresize'] = true; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['media']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['media']['image']['autoresize'] = true; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['user_photo']['image']['max_size_url'] = 2 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['user_photo']['image']['autoresize'] = true; // Максимальный размер файла в kB

$config['$root$']['module']['media']['type']['review']['image']['max_size_url'] = 5 * 1024; // Максимальный размер файла в kB
$config['$root$']['module']['media']['type']['review']['image']['autoresize'] = true; // Максимальный размер файла в kB


$config['$root$']['collection_type'] =
    [
        ['text' => '---', 'value' => '-'],
        ['text' => 'Бархат', 'value' => 'barkhat'],
        ['text' => 'Велюр', 'value' => 'velyur'],
        ['text' => 'Гобелен', 'value' => 'gobelen'],
        ['text' => 'Жаккард', 'value' => 'zhakkard'],
        ['text' => 'Искус. кожа', 'value' => 'iskustvennaya-kozha'],
        ['text' => 'Искус. замша', 'value' => 'iskusstvennaya-zamsha'],
        ['text' => 'Искус. шерсть', 'value' => 'iskusstvennaya-sherst'],
        ['text' => 'Микровелюр', 'value' => 'mikrovelyur'],
        ['text' => 'Микровельвет', 'value' => 'mikrovelvet'],
        ['text' => 'Микрожакард', 'value' => 'mikrozhakard'],
        ['text' => 'Микрофибра', 'value' => 'mikrofibra'],
        ['text' => 'Натуральная кожа', 'value' => 'naturalnaya-kozha'],
        ['text' => 'Рогожка', 'value' => 'rogozhka'],
        ['text' => 'Скочгард', 'value' => 'skochgard'],
        ['text' => 'Терможакард', 'value' => 'termozhakard'],
        ['text' => 'Флок', 'value' => 'flok'],
        ['text' => 'Шенилл', 'value' => 'shenill']
    ];
$config['$root$']['collection_type_ru'] =
    [
        'barkhat' => 'Бархат',
        'velyur' => 'Велюр',
        'gobelen' => 'Гобелен',
        'zhakkard' => 'Жаккард',
        'iskustvennaya-kozha' => 'Искус. кожа',
        'iskusstvennaya-zamsha' => 'Искус. замша',
        'iskusstvennaya-sherst' => 'Искус. шерсть',
        'mikrovelyur' => 'Микровелюр',
        'mikrovelvet' => 'Микровельвет',
        'mikrozhakard' => 'Микрожакард',
        'mikrofibra' => 'Микрофибра',
        'naturalnaya-kozha' => 'Натуральная кожа',
        'rogozhka' => 'Рогожка',
        'skochgard' => 'Скочгард',
        'termozhakard' => 'Терможакард',
        'flok' => 'Флок',
        'shenill' => 'Шенилл'
    ];
/**
 * Незабыть добавить поставщика в БД
 */
$config['$root$']['collection_supplier'] =
    [
        ['text' => '---', 'value' => ''],
        ['text' => 'Адилет', 'value' => 'adilet'],
        ['text' => 'Arben', 'value' => 'arben'],
        ['text' => 'Андрия', 'value' => 'andria'],
        ['text' => 'ЛамПлит', 'value' => 'lamplit'],
        ['text' => 'Марал', 'value' => 'maral'],
        ['text' => 'Союз-М', 'value' => 'souz-m'],
        ['text' => 'Leticiya', 'value' => 'leticiya']
    ];
$config['$root$']['collection_supplier_ru'] =
    [
        'adilet' => 'Адилет',
        'andria' => 'Андрия',
        'arben' => 'Arben',
        'egida' => 'Egida',
        'lamplit' => 'ЛамПлит',
        'maral' => 'Марал',
        'souz-m' => 'Союз-М',
        'leticiya' => 'Leticiya'
    ];
$config['$root$']['collection_country'] =
    [
        ['text' => '---', 'value' => ''],
        ['text' => 'Египет', 'value' => 'egypt'],
        ['text' => 'Китай', 'value' => 'china'],
        ['text' => 'Марокко', 'value' => 'morocco'],
        ['text' => 'Россия', 'value' => 'russia'],
        ['text' => 'Турция', 'value' => 'turkey'],
    ];
$config['$root$']['collection_country_ru'] =
    [
        'china' => 'Китай',
        'morocco' => 'Марокко',
        'turkey' => 'Турция'
    ];
$config['$root$']['char_type'] =
    [
        ['text' => 'Число', 'value' => 0],
        ['text' => 'Один из списка', 'value' => 1],
        ['text' => 'Несколько из списка', 'value' => 2],
        ['text' => 'Текст', 'value' => 3]
    ];
$config['$root$']['char_type_ru'] =
    [
        0 => 'Число',
        1 => 'Один из списка',
        2 => 'Несколько из списка',
        3 => 'Текст'
    ];
$config['$root$']['images_alt'] =
    [
        ['text' => '---', 'value' => ''],
        ['text' => 'Вид спереди', 'value' => 'Вид спереди'],
        ['text' => 'Вид по диагонали', 'value' => 'Вид по диагонали'],
        ['text' => 'Вид сбоку', 'value' => 'Вид сбоку'],
        ['text' => 'Вид сзади', 'value' => 'Вид сзади'],
        ['text' => 'Металлокаркас', 'value' => 'Металлокаркас'],
        ['text' => 'Механизм', 'value' => 'Механизм'],
        ['text' => 'Ножки', 'value' => 'Ножки'],
        ['text' => 'Подушки', 'value' => 'Подушки'],
        ['text' => 'Подлокотник', 'value' => 'Подлокотник'],
        ['text' => 'Спальное место', 'value' => 'Спальное место'],
        ['text' => 'Текстура ткани', 'value' => 'Текстура ткани'],
        ['text' => 'Ящик для белья', 'value' => 'Ящик для белья'],
    ];
$config['$root$']['colors'] =
    [
        ['value' => '-', 'text' => '-', 'color' => 'rgb(0, 0, 0)'],
        ['value' => 'white', 'text' => 'Белый', 'color' => 'rgb(255, 255, 255)'],
        ['value' => 'beige', 'text' => 'Бежевый', 'color' => 'rgb(245, 245, 220)'],
        ['value' => 'lightblue', 'text' => 'Голубой', 'color' => 'rgb(66, 170, 255)'],
        ['value' => 'yellow', 'text' => 'Желтый', 'color' => 'rgb(255, 255, 0)'],
        ['value' => 'green', 'text' => 'Зеленый', 'color' => 'rgb(0, 128, 0)'],
        ['value' => 'brown', 'text' => 'Коричневый', 'color' => 'rgb(150, 75, 0)'],
        ['value' => 'red', 'text' => 'Красный', 'color' => 'rgb(255, 0, 0)'],
        ['value' => 'orange', 'text' => 'Оранжевый', 'color' => 'rgb(255, 165, 0)'],
        ['value' => 'pink', 'text' => 'Розовый', 'color' => 'rgb(252, 15, 192)'],
        ['value' => 'grey', 'text' => 'Серый', 'color' => 'rgb(128, 128, 128)'],
        ['value' => 'silver', 'text' => 'Серебристый', 'color' => 'rgb(192, 192, 192)'],
        ['value' => 'blue', 'text' => 'Синий', 'color' => 'rgb(0, 0, 255)'],
        ['value' => 'purple', 'text' => 'Фиолетовый', 'color' => 'rgb(139, 0, 255)'],
        ['value' => 'black', 'text' => 'Черный', 'color' => 'rgb(0, 0, 0)']
//      'golden'    => ['text'=>'Золотистый',   'color'=>'rgb(255, 215, 0)'],
];
$config['$root$']['colors_ru'] =
    [
        'white' => 'Белый',
        'beige' => 'Бежевый',
        'lightblue' => 'Голубой',
        'yellow' => 'Желтый',
        'green' => 'Зеленый',
        'brown' => 'Коричневый',
        'red' => 'Красный',
        'orange' => 'Оранжевый',
        'pink' => 'Розовый',
        'grey' => 'Серый',
        'silver' => 'Серебристый',
        'blue' => 'Синий',
        'purple' => 'Фиолетовый',
        'black' => 'Черный',
//      'golden'    => ['text'=>'Золотистый',   'color'=>'rgb(255, 215, 0)'],
];

$config['$root$']['design_type'] =
    [
        ['value' => 'Абстракция', 'text' => 'Абстракция'],
        ['value' => 'Вензеля', 'text' => 'Вензеля'],
        ['value' => 'Геометрия', 'text' => 'Геометрия'],
        ['value' => 'Город', 'text' => 'Город'],
        ['value' => 'Детский', 'text' => 'Детский'],
        ['value' => 'Животные', 'text' => 'Животные'],
        ['value' => 'Классика', 'text' => 'Классика'],
        ['value' => 'Клетка', 'text' => 'Клетка'],
        ['value' => 'Купон', 'text' => 'Купон'],
        ['value' => 'Медальон', 'text' => 'Медальон'],
        ['value' => 'Мозаика', 'text' => 'Мозаика'],
        ['value' => 'Однотон', 'text' => 'Однотон'],
        ['value' => 'Однотон фактурный', 'text' => 'Однотон фактурный'],
        ['value' => 'Пейсли', 'text' => 'Пейсли'],
        ['value' => 'Полосы', 'text' => 'Полосы'],
        ['value' => 'Рептилия', 'text' => 'Рептилия'],
        ['value' => 'Ромб', 'text' => 'Ромб'],
        ['value' => 'Флористика', 'text' => 'Флористика'],
    ];
$config['$root$']['design_type_ru'] =
    [
        'Абстракция'=> 'Абстракция',
        'Вензеля'=> 'Вензеля',
        'Геометрия'=> 'Геометрия',
        'Город'=> 'Город',
        'Детский'=> 'Детский',
        'Животные'=> 'Животные',
        'Классика'=> 'Классика',
        'Клетка'=> 'Клетка',
        'Купон'=> 'Купон',
        'Медальон'=> 'Медальон',
        'Мозаика'=> 'Мозаика',
        'Однотон'=> 'Однотон',
        'Однотон фактурный'=> 'Однотон фактурный',
        'Пейсли'=> 'Пейсли',
        'Полосы'=> 'Полосы',
        'Рептилия'=> 'Рептилия',
        'Ромб'=> 'Ромб',
        'Флористика'=> 'Флористика',
    ];
$config['$root$']['make_blocks'] = [
    ['value' => '0', 'text' => '---'],
    ['value' => '1', 'text' => '1-й цех'],
    ['value' => '2', 'text' => '2-й цех'],
    ['value' => '3', 'text' => '3-й цех']
];
$config['$root$']['order']['per_page'] = 20;
$config['$root$']['order']['status'] = [
    ['text' => '---', 'value' => '0'],
    ['text' => 'Заявка', 'value' => 'new'],
    ['text' => 'В обработке', 'value' => 'processing'],
    ['text' => 'Отказ', 'value' => 'failure'],
    ['text' => 'На подтверждении', 'value' => 'on_confirm'],
    ['text' => 'Клиент подтвердил', 'value' => 'user_confirmed'],
    ['text' => 'На производстве', 'value' => 'make'],
    ['text' => 'Обратная связь', 'value' => 'feedback'],
    ['text' => 'Доставлен', 'value' => 'delivered'],
    ['text' => 'Рекламация', 'value' => 'reclamation'],
    ['text' => 'Отказ (Готово)', 'value' => 'failure-ready'],
    ['text' => 'Возврат', 'value' => 'return'],
//    ['text' => 'Передан на доставку', 'value' => 'delivery'],
//    ['text' => 'Отгружен', 'value' => 'shipped'],
//    ['text' => 'Оплачен', 'value' => 'paid'],
];
$config['$root$']['payment_type'] = [
    ['text' => 'Наличные', 'value' => 'cash'],
    ['text' => 'Онлайн', 'value' => 'online'],
    ['text' => 'Картой в магазине', 'value' => 'card'],
];
$config['$root$']['payment_name'] = [
    ['text' => '---', 'value' => 0],
    ['text' => 'Аванс', 'value' => 'prepayment'],
    ['text' => 'Оплата', 'value' => 'payment'],
    ['text' => 'Агентские', 'value' => 'agent_commission'],
    ['text' => 'Клиентские услуги', 'value' => 'client_services'],
];
/**
 * Дубль значений из базы для формирования фида marketa
 * char_id = 5
 */
$config['$root$']['mehanizm'] = [
    ['text' => 'Отсутствует', 'value' => 'otsutsvuet'],
    ['text' => 'Аккордеон', 'value' => 'akkordeon'],
    ['text' => 'Аккордеон Евро', 'value' => 'akkordeon-evro'],
    ['text' => 'Банкетка', 'value' => 'banketka'],
    ['text' => 'Венеция +', 'value' => 'veneciya-plus'],
    ['text' => 'Выкатной', 'value' => 'vykatnoj'],
    ['text' => 'Дельфин', 'value' => 'delfin'],
    ['text' => 'Еврокнижка', 'value' => 'evroknizhka'],
    ['text' => 'Еврокнижка вбок', 'value' => 'evroknizhka-vbok'],
    ['text' => 'Караван', 'value' => 'karavan'],
    ['text' => 'Клик-кляк', 'value' => 'klik-kljak'],
    ['text' => 'Книжка', 'value' => 'knizhka'],
    ['text' => 'Софа', 'value' => 'sofa'],
    ['text' => 'Тик-так', 'value' => 'tik-tak'],
    ['text' => 'Французская раскладушка', 'value' => 'francuzskaya-raskladushka'],
    ['text' => 'Бельгийская раскладушка', 'value' => 'belgiyskaya-raskladushka'],
    ['text' => 'Еврософа', 'value' => 'evrosofa']
];
$config['$root$']['car_number'] = [
    ['text' => '---', 'value' => 0],
    ['text' => 'Газель 1', 'value' => 1],
    ['text' => 'Газель 2', 'value' => 2],
    ['text' => 'Газель 3', 'value' => 3],
    ['text' => 'Газель 4', 'value' => 4],
    ['text' => 'Газель 5', 'value' => 5],
    ['text' => 'Газель 6', 'value' => 6],
    ['text' => 'Газель 7', 'value' => 7],
    ['text' => 'Газель 8', 'value' => 8],
    ['text' => 'Газель 9', 'value' => 9],
];
$config['$root$']['category']['per_page'] = 20;
$config['$root$']['category']['group_by'] = [
    ['text' => '---', 'value' => ''],
    ['text' => 'Форма', 'value' => 'Форма'],
    ['text' => 'Назначение', 'value' => 'Назначение'],
    ['text' => 'Механизм', 'value' => 'Механизм'],
    ['text' => 'Дополнительно', 'value' => 'Дополнительно'],
];
$config['$root$']['collection']['per_page'] = 20;
$config['$root$']['make']['per_page'] = 20;
$config['$root$']['blog']['per_page'] = 20;

$config['$root$']['sklonenie'] = [
    'divany' => ['диван', 'дивана', 'диванов'],
    'sofy' => ['софа', 'софы', 'соф'],
    'kresla' => ['кресло', 'кресла', 'кресел'],
];
$config['$root$']['work_type'] = [
    ['value' => '', 'text' => '---'],
    ['text' => 'Столярка', 'value' => 'stolyary'],
    ['text' => 'Швейка', 'value' => 'shvei'],
    ['text' => 'Драпировка', 'value' => 'drapera'],
];
$config['$root$']['collection_video'] = [
    514 => [
        'src' => '/video/tkani-1.mp4',
        'poster' => '/video/1.webp',
    ],
    515 => [
        'src' => '/video/tkani-1.mp4',
        'poster' => '/video/1.webp',
    ],
    511 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    513 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    22 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    467 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    509 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    510 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    512 => [
        'src' => '/video/tkani-2.mp4',
        'poster' => '/video/2.webp',
    ],
    114 => [
        'src' => '/video/tkani-3.mp4',
        'poster' => '/video/2.webp',
    ],
    454 => [
        'src' => '/video/tkani-3.mp4',
        'poster' => '/video/2.webp',
    ],
    21 => [
        'src' => '/video/tkani-4.mp4',
        'poster' => '/video/4.webp',
    ],
    16 => [
        'src' => '/video/tkani-5.mp4',
        'poster' => '/video/5.webp',
    ],
    18 => [
        'src' => '/video/tkani-5.mp4',
        'poster' => '/video/5.webp',
    ]
];
$config['$root$']['no-watermark-public-key'] = 'mlySzrTYDuccIKtMdjq55rjri77B72UW';
$config['$root$']['week_day'] = [
    1 => 'Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'
];
$config['$root$']['costs_items'] = [
    ['text' => '---', 'value' => ''],
    ['text' => 'Авито', 'value' => 'Авито'],
    ['text' => 'Аренда офиса', 'value' => 'Аренда офиса'],
    ['text' => 'Дизайн', 'value' => 'Дизайн'],
    ['text' => 'Зарплата', 'value' => 'Зарплата'],
    ['text' => 'Интернет', 'value' => 'Интернет'],
    ['text' => 'Сервер', 'value' => 'Сервер'],
    ['text' => 'Телефония', 'value' => 'Телефония'],
    ['text' => 'Уборщица', 'value' => 'Уборщица'],
    ['text' => 'Яндекс.Маркет', 'value' => 'Яндекс.Маркет'],
    ['text' => 'Яндекс.Директ', 'value' => 'Яндекс.Директ'],
    ['text' => 'Seo', 'value' => 'Seo'],
    ['text' => 'Прочее', 'value' => 'Прочее']
];

/* Алиасы соответсвия данных с сайтов kypit => fisher */
$config['$root$']['kypit-divan']['aliases'] = [
    'make_ids' => [
        1 => 1, /* leticiya */
        2 => 11, /* mdv-mebel-dlja-vas */
        3 => 3, /* leticiya-plus */
        4 => 8, /* dihall */
        5 => 7, /* fiesta */
        6 => 7, /* divama */
        7 => 9, /* fisher */

    ],
    'category_ids' => [
        216 => 8, /* Прямые диваны*/
        217 => 9, /* Угловые диваны */
        218 => 12, /* Кресла */
        219 => 101, /* Пуфы */
        220 => 10, /* Софа */
        221 => 104, /* Кровати */
        222 => 129, /* Матрасы */
        223 => 11, /* Тахта */
    ],
    'chars' => [
        'Габариты: Длина' => ['char_id' => 1],
        'Габариты: Глубина' => ['char_id' => 2],
        'Габариты: Высота' => ['char_id' => 14],
        'Спальное место: Ширина' => ['char_id' => 3],
        'Спальное место: Длина' => ['char_id' => 4],
        'Место для сиденья: Высота' => ['char_id' => 28],
        'Место для сиденья: Глубина до подушек' => ['char_id' => 30],
        'Место для сиденья: Глубина без подушек' => ['char_id' => 15],
        'Место для сиденья: Длина раскладывающейся части' => ['char_id' => 47],
        'Высота опор (ножек)' => ['char_id' => 24],
        'Ящик для белья: Длина х Глубина х Высота' => ['char_id' => 12],
        'Спинка: Глубина' => ['char_id' => 41],
        'Спинка: Высота от пола' => ['char_id' => 42],
        'Спинка: Высота от сиденья' => ['char_id' => 43],
        'Подлокотник 1: Ширина' => ['char_id' => 31],
        'Подлокотник 1: Глубина' => ['char_id' => 25],
        'Подлокотник 1: Высота от пола' => ['char_id' => 29],
        'Подлокотник 2: Ширина' => ['char_id' => 38],
        'Подлокотник 2: Глубина' => ['char_id' => 39],
        'Подлокотник 2: Высота от пола' => ['char_id' => 40],
        'Большие подушки: Ширина х Высота' => ['char_id' => 49],
        'Декоративные подушки: Ширина х Высота' => ['char_id' => 20],
        'Размеры столика' => ['char_id' => 21],
        'Форма изделия' => ['char_id' => 51, 'aliases' => [
            'Прямой диван' => 'Прямой',
            'Угловой диван' => 'Угловой',
        ]],
        'Модульный' => ['char_id' => 26],
        'Кол-во спальных мест' => ['char_id' => 6],
        'Назначение' => ['char_id' => 18],
        'Цвет' => ['char_id' => 17],
        'Стиль' => ['char_id' => 52],
        'Механизм трансформации' => ['char_id' => 5, 'aliases' => [
            'Отсутствует (нераскладной)' => 'Отсутствует'
        ]],
        'Каркас' => ['char_id' => 8],
        'Материалы' => ['char_id' => 9],
        'Наполнитель спального места' => ['char_id' => 10],
        'Жесткость спального места' => ['char_id' => 48],
        'Максимальная нагрузка' => ['char_id' => 13],
        'Вес изделия' => ['char_id' => 27],
        'Объем упаковки' => ['char_id' => 37],
        'Количество мест' => ['char_id' => 36],
        'Особенности' => ['char_id' => 50],
        'Подлокотники' => ['char_id' => 19, 'aliases' => [
            'Без подлокотников' => 'Нет',
            'С подлокотниками' => 'Есть',
            'С 1 подлокотником' => 'Есть',
            'С деревянными подлокотниками' => 'Есть',
            'С деревянными накладками' => 'Есть',
            'С мягкими подлокотниками' => 'Есть',
            'Со столиком' => 'Есть'
        ]],
        'Сиденье'  => ['char_id' => 7, 'aliases' => [
            '1-местное' => 1,
            '2-местное' => 2,
            '3-местное' => 3,
            '4-местное' => 4,
            '5-местное' => 5
        ]]
    ]
];

$config['$root$']['lift'] = [
    ['text' => 'Пассажирский', 'value' => '0'],
    ['text' => 'Грузовой', 'value' => '1']
];

$config['$root$']['rejected_types'] = [
    'manufacture' => 'Пр-во',
    'client' => 'Клиент',
    'shop-manager' => 'Менеджер',
    'delivery' => 'Доставка',
    'sum' => 'Итого',
    '' => 'Неопределено'
];

return $config;
