{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'collection'}
    {$sMenuSelectSub = 'collection_add'}
{/block}

{block name='layout_content'}
    <h2 class="page-sub-header">{$oCollection->getTitle()}</h2>
    {include file="{$aTemplatePathPlugin.admin}forms/collection.tpl"}
{/block}
