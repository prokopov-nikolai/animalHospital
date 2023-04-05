{**
 * Восстановление пароля.
 * Пароль отправлен на емэйл пользователя.
 *}

{extends 'layouts/layout.base.tpl'}

{block 'layout_page_title'}
	{$aLang.auth.reset.title}
{/block}

{block 'layout_content'}
	{$aLang.auth.reset.notices.success_send_password}
	<div class="pt-20">
		<a href="{router page='auth/login'}">{$aLang.auth.login.title}</a><br />
		<a href="/">Главная</a>
	</div>
{/block}