{**
 * Страница входа
 *}

{extends 'layouts/layout.login.tpl'}

{block 'layout_page_title'}
    {$aLang.auth.login.title}
{/block}

{block 'layout_content'}
    {component 'auth' template='login' showExtra=true}
{/block}