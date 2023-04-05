{**
 * Форма восстановления пароля
 *}

{extends 'layouts/layout.login.tpl'}

{block 'layout_page_title'}
    Введите новый пароль
{/block}

{block 'layout_content'}
    {component 'auth' template='reset_password'}
{/block}