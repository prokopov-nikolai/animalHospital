{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'order'}
	{$sMenuSelectSub = 'order_dump'}
{/block}

{block name="layout_head_end"}

{/block}

{block name='layout_content'}
	<a href="{Config::Get('url_adm')}order/dump/?create=1" class="button" style="background: #dff0d8; color: #468847; border: #468847 solid 1px;">Создать</a>
	<br>&nbsp;<br>
	{if $bFileExists}
		<a href="/application/tmp/dump_order.sql" class="button">Скачать</a> дамп от {$date}
		<br>&nbsp;<br>
		<a href="/admin/order/dump/?insert=1" class="button" style="background: #d60000; border: #d60000 solid 1px; color: #fff;" onclick="return confirm('Вы уверены, что хотите откатить изменения?');">Откатить</a>
		<br>&nbsp;<br>
	{/if}<br>
{/block}