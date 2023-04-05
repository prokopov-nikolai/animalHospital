<?php

$config = array();

// Подключение скриптов шаблона
$config['head']['template']['js'] = array(
	'___path.skin.assets.web___/js/libs/ls.ajax.js',
	'___path.skin.assets.web___/js/libs/modal.js',
	'___path.skin.assets.web___/js/libs/jquery.autocompletePro-0.3.js',
	'___path.skin.assets.web___/js/libs/tabs.js',
	'___path.skin.assets.web___/js/libs/jquery.notifier.js',
	'___path.skin.assets.web___/js/libs/notification.js',
	'___path.skin.assets.web___/js/libs/jquery.maskedinput.js',
	'___path.skin.assets.web___/js/libs/jquery.select.stylized.js',
	'___path.skin.assets.web___/js/libs/nprogress.js',
	'___path.skin.assets.web___/js/init.js'
);

// Подключение стилей шаблона
$config['head']['template']['css'] = array(
	"___path.skin.assets.web___/css/libs/libs.css",
	"___path.skin.assets.web___/css/style.css",
);

//$config['components'] = Config::Get('components');
//$config['components'][] = 'bootstrap';

return $config;