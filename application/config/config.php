<?php
/*-------------------------------------------------------
*
*   LiveStreet Engine Social Networking
*   Copyright © 2008 Mzhelskiy Maxim
*
*--------------------------------------------------------
*
*   Official site: www.livestreet.ru
*   Contact e-mail: rus.engine@gmail.com
*
*   GNU General Public License, version 2:
*   http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
*
---------------------------------------------------------
*/
$config['sys']['cache']['use']      = true;               // использовать кеширование или нет
$config['sys']['cache']['type']     = 'memory';             // тип кеширования: file, xcache и memory. memory использует мемкеш, xcache - использует XCache
$config['sys']['cache']['dir']      = '___path.tmp.server___/';       // каталог для файлового кеша, также используется для временных картинок. По умолчанию подставляем каталог для хранения сессий
$config['sys']['cache']['prefix']   = 'rtk_cache'; // префикс кеширования, чтоб можно было на одной машине держать несколько сайтов с общим кешевым хранилищем


/**
 * Настройки почтовых уведомлений
 */
$config['sys']['mail']['type']             = 'smtp';                 // Какой тип отправки использовать
$config['sys']['mail']['from_email']       = 'email@site.ru';      // Мыло с которого отправляются все уведомления
$config['sys']['mail']['from_name']        = 'site.RU';  // Имя с которого отправляются все уведомления
$config['sys']['mail']['charset']          = 'UTF-8';                // Какую кодировку использовать в письмах
$config['sys']['mail']['smtp']['host']     = 'ssl://smtp.yandex.ru';            // Настройки SMTP - хост
$config['sys']['mail']['smtp']['port']     = 465;                     // Настройки SMTP - порт
$config['sys']['mail']['smtp']['user']     = 'email@site.ru';                     // Настройки SMTP - пользователь
$config['sys']['mail']['smtp']['password'] = 'password2023';                     // Настройки SMTP - пароль
$config['sys']['mail']['smtp']['secure']   = '';                     // Настройки SMTP - протокол шифрования: tls, ssl
$config['sys']['mail']['smtp']['auth']     = true;                   // Использовать авторизацию при отправке


/**
 * !!!!! ВНИМАНИЕ !!!!!
 *
 * Ничего не изменяйте в этом файле!
 * Все изменения нужно вносить в файл config/config.local.php
 */
define('LS_VERSION', '2.0.0');


// Модуль Image
$config['module']['image']['driver'] = 'gd';
$config['module']['image']['params']['default']['size_max_width'] = 7000;
$config['module']['image']['params']['default']['size_max_height'] = 7000;
$config['module']['image']['params']['default']['format_auto'] = true;
$config['module']['image']['params']['default']['format'] = 'jpg';
$config['module']['image']['params']['default']['quality'] = 95;
$config['module']['image']['params']['default']['watermark_use'] = false;    // Использовать ватермарк или нет
$config['module']['image']['params']['default']['watermark_type'] = 'image'; // Тип: image - накладывается изображение. Другие типы пока не поддерживаются
$config['module']['image']['params']['default']['watermark_image'] = Config::Get('path.root.server').'/watermark/fisher-store.ru.png'; // Полный серверный путь до картинки ватермарка
$config['module']['image']['params']['default']['watermark_position'] = 'center'; // Значения: bottom-left, bottom-right, top-left, top-right, center
$config['module']['image']['params']['default']['watermark_min_width'] = 300; // Минимальная ширина изображения, начиная с которой будет наложен ватермарк
$config['module']['image']['params']['default']['watermark_min_height'] = 200; // Минимальная высота изображения, начиная с которой будет наложен ватермарк


/**
 * Основные настройки путей
 * Если необходимо установить движек в директорию(не корень сайта) то следует сделать так:
 * $config['path']['root']['web']    = 'http://'.$_SERVER['HTTP_HOST'].'/subdir';
 * и увеличить значение $config['path']['offset_request_url'] на число вложенных директорий,
 * например, для директории первой вложенности www.site.ru/livestreet/ поставить значение равное 1
 */
$config['path']['root']['server'] = dirname(dirname(dirname(__FILE__)));
$config['path']['root']['web'] = isset($_SERVER['HTTP_HOST']) ? 'http://' . $_SERVER['HTTP_HOST'] : null;
$config['path']['offset_request_url'] = 0;


/**
 * Настройки HTML вида
 */
$config['view']['skin'] = 'developer';        // Название текущего шаблона
$config['view']['theme'] = 'default';            // тема оформления шаблона (шаблон должен поддерживать темы)
$config['view']['name'] = 'Your Site';                   // название сайта
$config['view']['description'] = 'Description your site'; // seo description
$config['view']['keywords'] = 'site, google, internet';      // seo keywords
$config['view']['wysiwyg'] = false;  // использовать или нет визуальный редактор TinyMCE
$config['view']['noindex'] = true;   // "прятать" или нет ссылки от поисковиков, оборачивая их в тег <noindex> и добавляя rel="nofollow"
$config['view']['img_resize_width'] = 570;    // до какого размера в пикселях ужимать картинку по щирине при загрузки её в топики и комменты
$config['view']['img_max_width'] = 5000;    // максимальная ширина загружаемых изображений в пикселях
$config['view']['img_max_height'] = 5000;    // максимальная высота загружаемых изображений в пикселях
$config['view']['img_max_size_url'] = 500;    // максимальный размер картинки в kB для загрузки по URL


/**
 * Общие настройки
 */
$config['general']['admin_mail'] = 'admin@admin.adm'; // email администратора
$config['general']['captcha']['type'] = 'recaptcha'; // тип используемой каптчи: kcaptcha, recaptcha

/**
 * Настройки модулей
 */
// User
$config['module']['user']['time_login_remember'] = 60 * 60 * 24 * 7;   // время жизни куки когда пользователь остается залогиненым на сайте, 7 дней
$config['module']['user']['count_auth_session'] = 4; // Количество разрешенных сессий пользователя (авторизаций в разных браузерах)
$config['module']['user']['count_auth_session_history'] = 10; // Общее количество сессий для хранения (значение должно быть больше чем count_auth_session)

// Модуль Lang
$config['module']['lang']['delete_undefined'] = true;   // Если установлена true, то модуль будет автоматически удалять из языковых конструкций переменные вида %%var%%, по которым не была произведена замена
// Модуль Notify
$config['module']['notify']['delayed'] = false;    // Указывает на необходимость использовать режим отложенной рассылки сообщений на email
$config['module']['notify']['insert_single'] = false;    // Если опция установлена в true, систему будет собирать записи заданий удаленной публикации, для вставки их в базу единым INSERT
$config['module']['notify']['per_process'] = 10;       // Количество отложенных заданий, обрабатываемых одним крон-процессом
$config['module']['notify']['dir'] = 'emails'; // Путь до папки с емэйлами относительно шаблона
$config['module']['notify']['prefix'] = 'email';  // Префикс шаблонов емэйлов

// Модуль Security
$config['module']['security']['hash'] = "livestreet_security_key"; // "примесь" к строке, хешируемой в качестве security-кода
/**
 * Модуль Validate
 */
/* пока не применяется. убрал регистрацию за ненадобностью */
// Настройки Google рекаптчи - https://www.google.com/recaptcha/admin/site/570108866#createsite
$config['module']['validate']['recaptcha'] = array(
    'site_key' => '6LfCK_shAAAAADYQKDfQrF1bxYHP3lDoQ2Er5Zmh', // Ключ
    'secret_key' => '6LfCK_shAAAAAPJWNis1M0FztvdrAoxqTEvCL4mT', // Секретный ключ
    'use_ip' => false, // Использовать при валидации IP адрес клиента
);

// Какие модули должны быть загружены на старте
$config['module']['autoLoad'] = array('Hook', 'Cache', 'Logger', 'Security', 'Session', 'Lang', 'Message');
/**
 * Настройка базы данных
 */
$config['db']['params']['host'] = 'localhost';
$config['db']['params']['port'] = '3306';
$config['db']['params']['user'] = 'root';
$config['db']['params']['pass'] = '';
$config['db']['params']['type'] = 'mysqli';
$config['db']['params']['dbname'] = 'social';
$config['db']['tables']['engine'] = 'InnoDB';  // InnoDB или MyISAM
/**
 * Настройка таблиц базы данных
 */
$config['db']['table']['prefix'] = 'prefix_';

$config['db']['table']['blog']              = '___db.table.prefix___blog';
$config['db']['table']['blog_topic']        = '___db.table.prefix___blog_topic';
$config['db']['table']['category']          = '___db.table.prefix___category';
$config['db']['table']['category_filter']   = '___db.table.prefix___category_filter';
$config['db']['table']['category_filter_items'] = '___db.table.prefix___category_filter_items';
$config['db']['table']['category_chars']    = '___db.table.prefix___category_chars';
$config['db']['table']['char']              = '___db.table.prefix___char';
$config['db']['table']['collection']        = '___db.table.prefix___collection';
$config['db']['table']['design']            = '___db.table.prefix___design';
$config['db']['table']['make']              = '___db.table.prefix___make';
$config['db']['table']['make_collections']  = '___db.table.prefix___make_collections';
$config['db']['table']['media']             = '___db.table.prefix___media';
$config['db']['table']['notify_task']       = '___db.table.prefix___notify_task';
$config['db']['table']['option']            = '___db.table.prefix___option';
$config['db']['table']['option_values']     = '___db.table.prefix___option_values';
$config['db']['table']['order']             = '___db.table.prefix___order';
$config['db']['table']['order_products']    = '___db.table.prefix___order_products';
$config['db']['table']['order_rejected']    = '___db.table.prefix___order_rejected';
//$config['db']['table']['plugin_manager_migration'] = '___db.table.prefix___plugin_migration';
//$config['db']['table']['plugin_manager_version'] = '___db.table.prefix___plugin_version';
$config['db']['table']['product']           = '___db.table.prefix___product';
$config['db']['table']['product_chars']     = '___db.table.prefix___product_chars';
$config['db']['table']['product_groups']    = '___db.table.prefix___product_groups';
$config['db']['table']['product_options']   = '___db.table.prefix___product_options';
$config['db']['table']['product_option_values'] = '___db.table.prefix___product_option_values';
$config['db']['table']['product_prices']    = '___db.table.prefix___product_prices';
$config['db']['table']['product_similars']  = '___db.table.prefix___product_similars';
$config['db']['table']['storage'] = '___db.table.prefix___storage';
$config['db']['table']['user']              = '___db.table.prefix___user';
$config['db']['table']['user_session'] = '___db.table.prefix___session';
$config['db']['table']['user_reminder'] = '___db.table.prefix___reminder';



/**
 * Настройки роутинга
 */
$config['url_adm'] = 'jarvis';
$config['url4symb'] = substr($config['url_adm'], 0, 4);

$config['router']['rewrite'] = [];
// Правила реврайта для REQUEST_URI
$config['router']['uri'] = [
    '~^page\-num\-(\d+)~i' => "index/page-num-\\1",
    '~(dostavka|kontakty|politika|o-kompanii|wa)~' => 'page/\\1'
];
// Распределение action
$config['router']['page']['error']          = 'ActionError';
$config['router']['page']['index']          = 'ActionIndex';
$config['router']['page']['auth']           = 'ActionAuth';
$config['router']['page']['page']           = 'ActionPage';
// Глобальные настройки роутинга
$config['router']['config']['default']['action'] = 'index';
$config['router']['config']['default']['event'] = null;
$config['router']['config']['default']['params'] = null;
$config['router']['config']['default']['request'] = null;
$config['router']['config']['action_not_found'] = 'error';
// Принудительное использование https для экшенов. Например, 'login' и 'registration'
$config['router']['force_secure'] = array();


/**
 * Подключение компонентов
 */
if (isset($_SERVER['REQUEST_URI']) && !in_array(substr($_SERVER['REQUEST_URI'], 1, 4), array('auth', 'admi', $config['url4symb'], 'logi'))) {
    $config['components'] = array(
//		'ls-core',
//		'ls-component',
//		'pagination',
//		'modal',
//		'tabs',
//		'notification',
//		'auth'
    );
} else {
    $config['components'] = array(
        // Базовые компоненты
//        'css-reset', 'css-helpers', 'typography', 'forms', 'grid',
//        'ls-vendor', 'ls-core', 'ls-component', 'lightbox', 'avatar', 'slider', 'details', 'alert', 'dropdown', 'button', 'block',
//        'nav', 'tooltip', 'tabs', 'modal', 'table', 'text', 'uploader', 'email', 'field', 'pagination', 'editor', 'more', 'crop',
//        'performance', 'toolbar', 'actionbar', 'badge', 'autocomplete', 'icon', 'item', 'highlighter', 'jumbotron', 'notification', 'blankslate',

        // Компоненты приложения
//        'auth', 'userbar', 'toolbar-scrollup',
    );
}

//$config['head']['default']['js'] = array(
//	"https://www.google.com/recaptcha/api.js?onload=__do_nothing__&render=explicit" => array('merge' => false),
//);
$config['head']['default']['css'] = array();

// Подключение темы
//if ( $config['view']['theme'] ) {
//	$config['head']['default']['css'][] = "___path.skin.web___/themes/___view.theme___/style.css";
//}


/**
 * Установка локали
 */
setlocale(LC_ALL, "ru_RU.UTF-8");
date_default_timezone_set('Europe/Moscow'); // See http://php.net/manual/en/timezones.php

/**
 * Настройки типографа текста Jevix
 * Добавляем к настройках из /framework/config/jevix.php
 */
$config['jevix'] = array_merge_recursive((array)Config::Get('jevix'), require(dirname(__FILE__) . '/jevix.php'));

$config['months'] = ['', 'Январь','Февраль','Март','Апрель','Май','Июнь','Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь'];

$config['products_popular'] = [
    1231, /* Этро люкс с опорой №5 */
    1385, /* Кайман */
    1414, /* Шуга */
    1289, /* Фокс */
    1412, /* Глэм */
    1465, /* Сайли */
    1384, /* Милано */
    1378, /* Остин */
    1287, /* Оскар-2 с опорой №12 */
    1432, /* Кайман-3 */
    1286, /* Мадрид люкс */
    1375, /* Ява */
    1461, /* Порту */
];

return $config;