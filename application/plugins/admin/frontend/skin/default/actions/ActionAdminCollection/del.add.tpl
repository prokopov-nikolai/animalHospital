{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'fabric'}
	{$sMenuSelectSub = 'collection_add'}
{/block}

{block name='layout_content'}
	<h2 class="page-sub-header">Добавляем коллекцию тканей</h2>
	{include file="{$aTemplatePathPlugin.admin}forms/form.add.collection.tpl" }
{/block}
