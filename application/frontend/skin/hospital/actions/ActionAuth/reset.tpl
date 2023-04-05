{**
 * Форма восстановления пароля
 *}

{extends 'layouts/layout.login.tpl'}

{block 'layout_page_title'}
    {$aLang.auth.reset.title}
{/block}

{block 'layout_content'}
    {component 'auth' template='reset'}
{/block}