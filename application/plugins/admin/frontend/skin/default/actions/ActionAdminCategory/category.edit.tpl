{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'category'}
    {$sMenuSelectSub = 'category'}
{/block}

{block name='layout_content'}
    <h2 class="page-sub-header">Редактирование категории: {$oCategory->getTitle()}</h2>
    {include file="{$aTemplatePathPlugin.admin}forms/category.tpl"}
{/block}
