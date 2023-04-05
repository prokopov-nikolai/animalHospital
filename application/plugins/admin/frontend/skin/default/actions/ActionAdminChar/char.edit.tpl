{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'char'}
{/block}

{block name='layout_content'}
	<h1>Редактирование характеристики</h1>
	{include file="{$aTemplatePathPlugin.admin}forms/char.tpl"}
{/block}