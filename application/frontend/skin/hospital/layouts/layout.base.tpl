<!DOCTYPE html>
<html lang="ru">
<head>
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/components/fonts/montserrat/Montserrat-Regular.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/components/fonts/montserrat/Montserrat-ExtraBold.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/components/fonts/montserrat/Montserrat-SemiBold.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/components/fonts/montserrat/Montserrat-Bold.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/components/fonts/montserrat/Montserrat-Light.woff2" as="font" type="font/woff2" crossorigin>
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/skin/hospital/assets/css/style.css" as="style">
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/skin/hospital/assets/css/libs/libs.css" as="style">
    <link rel="preload" href="{Config::Get('path.root.web')}/application/frontend/skin/hospital/assets/js/libs/jquery-3.3.1.min.js" as="script">
    {block 'vars'}{/block}
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{$sHtmlTitle|htmlspecialchars_decode}</title>
    <meta name="description" content='{$sHtmlDescription|htmlspecialchars_decode}'>
    <meta name="keywords" content='{$sHtmlKeywords|htmlspecialchars_decode}'>
    {if $sHtmlCanonical}
        <link rel="canonical" href="{$sHtmlCanonical}" />{/if}

    <!-- facebook meta -->
    {hook run='meta'}

    <link rel="shortcut icon" href="{Config::Get('path.skin.assets.web')}/images/favicon/favicon.svg?v2" type="image/svg+xml">
    <link rel="shortcut icon" href="{Config::Get('path.skin.assets.web')}/images/favicon/favicon.png?v2" type="image/png">
    <script src="{Config::Get('path.skin.assets.web')}/js/libs/jquery-3.3.1.min.js?{$sCacheHash}"></script>

    {block 'layout_head_styles'}
        {* Подключение стилей указанных в конфиге *}
        {$aHtmlHeadFiles.css}
    {/block}

    {block name='layout_options'}{/block}
    {block 'layout_header_styles'}{/block}
    {block 'layout_header_scripts'}{/block}
    {hook run='html_head_end'}

</head>
<body>
{include file="header.tpl"}
<section class="main-content">
    {block 'layout_content'}{/block}
</section>
{include file="footer.tpl"}
<div id="modal-back"></div>
{if Config::Get('debug_mode')} {hook run='body_end'} {/if}
{block 'layout_footer_scripts'}
    <script>
        let LIVESTREET_SECURITY_KEY = '{$LIVESTREET_SECURITY_KEY}',
            DIR_WEB_ROOT = '{Config::Get('path.root.web')}',
            sCacheHash = '{$sCacheHash}',
            oLazy = {
                Update: false
            };
        var
            log = log || function (a) {
                if (bDebug) console.log(a)
            };
    </script>
    {$aHtmlHeadFiles.js}
    {LS::Get('scripts')}
{/block}
</body>
</html>