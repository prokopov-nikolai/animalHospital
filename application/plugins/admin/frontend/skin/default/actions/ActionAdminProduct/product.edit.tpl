{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'product'}
{/block}

{block name='layout_content'}
    <h2 class="page-sub-header">{($oProduct->getTitleFull()) ? $oProduct->getTitleFull(): $oProduct->getTitle()}</h2>
    {include file="{$aTemplatePathPlugin.admin}forms/product.tpl" bAction='update'}
{/block}