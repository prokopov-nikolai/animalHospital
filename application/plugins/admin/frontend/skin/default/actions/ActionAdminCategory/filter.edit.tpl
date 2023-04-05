{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'category'}
    {$sMenuSelectSub = 'category_filter'}
{/block}

{block name='layout_content'}
    <h2>{if $oCategoryFilter}Редактируем категорию фильтр{else}Добавить категорию фильтр{/if}</h2>
    {include file="{$aTemplatePathPlugin.admin}forms/category.filter.tpl"}
{/block}