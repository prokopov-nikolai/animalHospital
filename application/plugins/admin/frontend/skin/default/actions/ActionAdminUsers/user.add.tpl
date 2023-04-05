{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'users'}
	{$sMenuSelectSub = 'users_add'}
{/block}

{block name='layout_content'}
	<h1>{$oUser->getFio()}</h1>
	{include file="{$aTemplatePathPlugin.admin}forms/user.tpl"}
{/block}