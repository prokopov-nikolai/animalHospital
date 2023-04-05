{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'seo'}
{/block}

{block name='layout_content'}
    <h1>SEO</h1>
    {include file="{$aTemplatePathPlugin.admin}forms/seo.meta.tpl"}
{/block}