<!DOCTYPE html>
<html lang="ru">
<head>
    {include file="gtm.head.tpl"}
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
    <link rel="shortcut icon" href="{Config::Get('path.skin.assets.web')}/images/favicon/favicon.png?v2"
          type="image/png">

    {$aHtmlHeadFiles.css}

    <script>
        if (navigator.userAgent.match(/Android/i)) {
            var viewport = document.querySelector("meta[name=viewport]");
        }
        if (navigator.userAgent.match(/Android/i)) {
            window.scrollTo(0, 1);
        }
    </script>


</head>

<body class="{$sBodyClasses}{($IS_MOBILE) ? ' IS_MOBILE' : {($IS_TABLET) ? 'IS_TABLET' : ''}}">
{include file="gtm.body.tpl"}
<section class="error">
    {block name='layout_page_title' hide}
        <h1>{$smarty.block.child}</h1>
    {/block}

    {block 'layout_content'}{/block}
</section>
</body>
</html>