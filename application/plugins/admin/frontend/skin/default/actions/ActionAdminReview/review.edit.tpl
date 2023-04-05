{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'review'}
{/block}

{block name='layout_content'}
    <h1>Редактирование</h1>
    {include file="{$aTemplatePathPlugin.admin}forms/review.tpl"}
{/block}