{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'groups'}
{/block}

{block name='layout_content'}
	{if $sCollectionTitle}
		{include file="{$aTemplatePathPlugin.admin}fabric/collection.tpl" }
	{else}
		{include file="{$aTemplatePathPlugin.admin}fabric/collection.list.tpl" }
	{/if}
{/block}