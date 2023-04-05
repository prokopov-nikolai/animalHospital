{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'make'}
{/block}

{block name='layout_content'}
	<h1>{$oMake->getTitle()}</h1>
	{include file="{$aTemplatePathPlugin.admin}forms/make.tpl"}
{/block}