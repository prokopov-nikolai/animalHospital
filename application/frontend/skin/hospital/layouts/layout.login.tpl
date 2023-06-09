<!DOCTYPE html>
<html lang="ru">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <title>{block name='layout_title'}{$sHtmlTitle}{/block}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, , initial-scale=1.0">
    <meta name="description" content="{block name='layout_description'}{$sHtmlDescription}{/block}">
    <meta name="keywords" content="{block name='layout_keywords'}{$sHtmlKeywords}{/block}">


    <link href='https://fonts.googleapis.com/css?family=Roboto:400,100italic,100,300,300italic,400italic,500,500italic,700,700italic,900,900italic&subset=latin,latin-ext,cyrillic'
          rel='stylesheet' type='text/css'>
    <link rel="shortcut icon" href="{Config::Get('path.skin.assets.web')}/images/favicon/favicon.svg?v2"
          type="image/svg+xml">


    {$aHtmlHeadFiles.css}

    <script src="{Config::Get('path.skin.assets.web')}/js/libs/jquery-3.3.1.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/ls.ajax.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/jquery.form.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/parsley.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/utils.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/nprogress.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/jquery.notifier.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/notification.js?{$sCacheHash}"></script>
    <script src="{Config::Get('path.skin.assets.web')}/js/auth.js?{$sCacheHash}"></script>

    <script>
        if (navigator.userAgent.match(/Android/i)) {
            var viewport = document.querySelector("meta[name=viewport]");
        }
        if (navigator.userAgent.match(/Android/i)) {
            window.scrollTo(0, 1);
        }
        var LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}',
        LANGUAGE = [],
        ADMIN_URL = '/{Config::Get('url_adm')}/',
        bDebug = true,
        log = log || function (a) {
            if (bDebug) console.log(a)
        };
        var aRouter = [];
        {foreach $aRouter as $sPage => $sPath}
        aRouter['{$sPage}'] = '{$sPath}';
        {/foreach}
    </script>


</head>

<body>
<section class="{$sAction} {$sEvent}">
    {block name='layout_page_title' hide}
        <h1>{$smarty.block.child}</h1>
    {/block}
    {* Системные сообщения *}
    {if $aMsgError}
        {component 'alert' text=$aMsgError mods='error' close=true}
    {/if}

    {if $aMsgNotice}
        {component 'alert' text=$aMsgNotice close=true}
    {/if}
    {block 'layout_content'}{/block}
</section>

{block 'layout_footer_scripts'}
    {$aHtmlHeadFiles.js}
    {LS::Get('scripts')}
{/block}
</body>
</html>