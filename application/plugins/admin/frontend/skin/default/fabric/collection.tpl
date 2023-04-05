<h2 class="page-sub-header">{$oGroup->getTitle()} - {$sCollectionTitle|escape:'html'}</h2>

{include file="{$aTemplatePathPlugin.admin}forms/form.add.colllection.type.tpl" oFabric=$aFabric[0]}

<div class="admin-fabric-list">
	{foreach $aFabric as $oFabric}
		{include file="{$aTemplatePathPlugin.admin}fabric/fabric.tpl"}
	{/foreach}
</div>

{include file="{$aTemplatePathPlugin.admin}forms/form.add.fabric.tpl" bTypeHidden=true}