<h2 class="page-sub-header">{$oGroup->getTitle()}</h2>
{$sCollectionTitle = ''}
<ul class="collection_list">
{$_ = ''}
{foreach $aFabric as $oFabric}
	{if $_ != "{$oFabric->getCollectionTitle()}{$oFabric->getMakeTitle()}"}
		{$_ = "{$oFabric->getCollectionTitle()}{$oFabric->getMakeTitle()}"}
		<li>
			<a href="/{Config::Get('url_adm')}/fabric/{$oGroup->getId()}/collection/{$oFabric->getCollectionTitle()}/{$oFabric->getMakeTitle()}/">{$oFabric->getCollectionTitle()} / {$oFabric->getMakeTitle()}</a>
			<select name="" class="group_id" onchange="ls.plugin.shop.fabric.changeGroup($(this));  return false;">
				{foreach $aGroup as $oItem}
					<option value="{$oItem->getId()}"{if $oItem->getId() == $oFabric->getGroupId()} selected{/if}>{$oItem->getTitle()}</option>
				{/foreach}
			</select>
		</li>
	{/if}
{/foreach}
</ul>


{include file="{$aTemplatePathPlugin.admin}forms/form.add.fabric.tpl"}