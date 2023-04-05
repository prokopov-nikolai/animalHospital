{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'pets'}
	{$sMenuSelectSub = 'pets_add'}
{/block}

{block name='layout_content'}
	<h1>{$oPet->getNickName()}</h1>
	{include file="{$aTemplatePathPlugin.admin}forms/pet.tpl"}
{/block}