{**
 * Регистрация
 *}

{extends 'layouts/layout.login.tpl'}

{block 'layout_page_title'}
    {$aLang.auth.registration.title}
{/block}

{block 'layout_content'}
    {component 'auth' template='registration'}
{/block}

{block 'layout_footer_scripts'}
    <script src="https://www.google.com/recaptcha/api.js?render={Config::Get('module.validate.recaptcha.6LfCK_shAAAAADYQKDfQrF1bxYHP3lDoQ2Er5Zmh')}"></script>
{/block}