{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'category'}
    {$sMenuSelectSub = 'category'}
{/block}

{block name='layout_content'}
    <h1>Выберите категорию{if $iCategoryId}: {$oCategory->getTitle()}{/if}</h1>

    <div class="cl h20"></div>
    {component button
    mods    ='primary'
    url     = "/{Config::Get('plugin.admin.url')}/category/add/"
    text    = 'Добавить'}
    <div class="cl h20"></div>

    {include file="{$aTemplatePathPlugin.admin}category/list.tpl" bProductList=false}
{/block}
