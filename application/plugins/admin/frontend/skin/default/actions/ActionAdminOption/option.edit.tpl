{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'option'}
{/block}

{block name='layout_content'}
	<h1>{$oOption->getTitle()}</h1>
	{include file="{$aTemplatePathPlugin.admin}forms/option.tpl"}
{/block}