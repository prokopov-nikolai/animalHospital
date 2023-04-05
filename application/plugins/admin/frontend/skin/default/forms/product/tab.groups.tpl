<p>
    <input type="text" class="search-item" placeholder="Порту" autocomplete="off">
    <small class="note">Начните вбивать название и выберите из выпадающего списка</small>
</p>

<div class="group-items">
    {$sGroupName = ''}
    {foreach $oProduct->getGropusItems() as $oItem}
        {if $sGroupName != $oItem->getGroupName()}
            <div class="cl" style="border-bottom: #ccc solid 1px; margin: 20px 0;"></div>
            {$sGroupName = $oItem->getGroupName()}
        {/if}
        {include file="{$aTemplatePathPlugin.admin}product/ajax.groups.item.tpl"}
    {/foreach}
</div>