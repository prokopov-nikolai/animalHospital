<!DOCTYPE html>
{block name='layout_options'}{/block}
<html lang="ru">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="{block name='layout_description'}{$sHtmlDescription}{/block}">
    <meta name="keywords" content="{block name='layout_keywords'}{$sHtmlKeywords}{/block}">

    <title>{block name='layout_title'}{$sHtmlTitle}{/block}</title>

    {*<link href="{cfg name='path.skin.assets.web'}/images/favicons/favicon.ico?v1" rel="shortcut icon" />*}
    <link href="{cfg name='path.skin.assets.web'}/images/favicon/favicon.png?v1" rel="shortcut icon"/>
    <link rel="search" type="application/opensearchdescription+xml" href="{router page='search'}opensearch/"
          title="{cfg name='view.name'}"/>

    {**
     * Стили
     * CSS файлы подключаются в конфиге шаблона (ваш_шаблон/settings/config.php)
     *}
    {$aHtmlHeadFiles.css}
    <link rel="stylesheet" href="/framework/frontend/components/pagination/css/pagination.css">
    <!--[if lt IE 9]>
    <link href="{cfg name='path.skin.assets.web'}/css/ie.css" rel="stylesheet"/>
    <![endif]-->


    {**
     * RSS
     *}
    {if $aHtmlRssAlternate}
        <link rel="alternate" type="application/rss+xml" href="{$aHtmlRssAlternate.url}"
              title="{$aHtmlRssAlternate.title}">
    {/if}

    {if $sHtmlCanonical}
        <link rel="canonical" href="{$sHtmlCanonical}"/>
    {/if}


    <script>
        var PATH_ROOT = '{router page='/'}',
            PATH_SKIN = '{cfg name="path.skin.web"}',
            PATH_FRAMEWORK_FRONTEND = '{cfg name="path.framework.frontend.web"}',
            PATH_FRAMEWORK_LIBS_VENDOR = '{cfg name="path.framework.libs_vendor.web"}',

            LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}',
            SESSION_ID = '{$_sPhpSessionId}',
            SESSION_NAME = '{$_sPhpSessionName}',
            LANGUAGE = '{$oConfig->GetValue('lang.current')}',
            WYSIWYG = {if $oConfig->GetValue('view.wysiwyg')}true{else}false{/if},
            USER_PROFILE_LOGIN = {if $oUserProfile}{json var=$oUserProfile->getLogin()}{else}''{/if},
            ADMIN_URL = '{$ADMIN_URL}',
            IS_MOBILE = {($IS_MOBILE) ? 1 : 0},
            bUseDisneykeyApi = {($aSettings.use_disneykey_api) ? $aSettings.use_disneykey_api : 0};
        {if !$oUserCurrent}
        var bUserIsAuth = 0;
        {else}
        var bUserIsAuth = 1;
        var sUserName = '{$oUserCurrent->getDisplayName()}';
        var sUserEmail = '{$oUserCurrent->getMail()}';
        {/if}

        var aRouter = [];
        {foreach $aRouter as $sPage => $sPath}
        aRouter['{$sPage}'] = '{$sPath}';
        {/foreach}

    </script>
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/jquery-3.3.1.js?{$sCacheHash}"></script>
    {**
     * JavaScript файлы
     * JS файлы подключаются в конфиге шаблона (ваш_шаблон/settings/config.php)
     *}
    {$aHtmlHeadFiles.js}

    {block name='layout_head_end'}{/block}
    {hook run='html_head_end'}
    {if $smarty.get.print}
        <link href="/application/plugins/admin/frontend/skin/default/assets/css/print.css" rel="stylesheet"/>
    {/if}

</head>
<body class="{if $IS_MOBILE}IS_MOBILE {/if}{$sBodyClasses} {$BROWSER} {$BROWSER_VERSION} {if $bMenuHide == true}aside-hide{/if}" {if $smarty.get.print}onload="window.print();"{/if}>
<div id="wrapper" class="admin dflex">
    {hook run='body_begin'}
        <aside>
                {if $oUserCurrent}{$oUserCurrent->getDisplayName()}{/if}
                <a href="{router page='auth'}logout/?security_ls_key={$LIVESTREET_SECURITY_KEY}">Выйти</a>
                &nbsp;<br>&nbsp;<br>
                <a href="{$ADMIN_URL}cache_delete/" id="cache-del">Сбросить кеш</a>
                <nav class="main">
                    {foreach $aAdminMenu as $aItem}
                        <a href="{$aItem.url}"{if $sMenuSelect == $aItem.menu_key} class="active"{/if}>{LS::E()->Lang_Get($aItem.lang_key)}</a>
                        {if $aItem.sub && $sMenuSelect == $aItem.menu_key}
                            <nav class="sub">
                                {foreach $aItem.sub as $aItem1}
                                    <a href="{$aItem1.url}"{if $sMenuSelectSub == $aItem1.menu_key} class="active"{/if}>{LS::E()->Lang_Get($aItem1.lang_key)}</a>
                                {/foreach}
                            </nav>
                        {/if}
                    {/foreach}
                    {if !$oUserCurrent->getTelegramChatId()}
                        <a href="tg://resolve?domain=FisherStoreBot&start={$oUserCurrent->getId()|cat:'fisher-store'|md5}" class="telegram-bot"><i class="fa fa-telegram"></i> Telegram Bot</a>
                    {/if}
                </nav>
            </aside>
        <section{if $bMenuHide == true} class="opened"{/if}>
            {include file="{$aTemplatePathPlugin.admin}breadcrumbs.tpl"}
            {* Основной заголовок страницы *}
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

            {if Config::Get('debug_mode')}
{*                <p style="color: #d60000;">Статистика не подключена</p>*}
            {/if}
            {block name='layout_content'}{/block}

            {block name='layout_content_end'}{/block}
        </section>
</div>
<footer>
    <div class="wrap">
        &copy; 2020-{$smarty.now|date_format:'Y'} "Диваны от Фишера" - фабрика мягкой мебели.
    </div>
</footer>
{$sLayoutAfter}
<a href="#" id="toTop">
    <i class="fa fa-angle-up"></i>
</a>
<div id="modal-back"></div>
<div class="menu-show{if $bMenuHide == true} hided{/if}"></div>

{block name="scripts"}{/block}
{LS::Get('scripts')}
</body>
</html>
