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
        let LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}',
            SESSION_ID = '{$_sPhpSessionId}',
            SESSION_NAME = '{$_sPhpSessionName}',
            ADMIN_URL = '{$ADMIN_URL}';
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
<body class="{if $bMenuHide == true}aside-hide{/if}" {if $smarty.get.print}onload="window.print();"{/if}>
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

            {block name='layout_content'}{/block}
            {block name='layout_content_end'}{/block}
        </section>
</div>
<footer>
    <div class="wrap">
        &copy; 2023-{$smarty.now|date_format:'Y'}
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
