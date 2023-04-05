{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'blog'}
    {$sMenuSelectSub = 'blog_blogs'}
{/block}

{block name='layout_content'}
    <h2>Разделы</h2>
    <div class="cl h20"></div>
    <a href="{$ADMIN_URL}blog/add/" class="ls-button">Добавить</a>
    <div class="cl h20"></div>

    {include file="{$aTemplatePathPlugin.admin}blog/list.tpl"}
{/block}