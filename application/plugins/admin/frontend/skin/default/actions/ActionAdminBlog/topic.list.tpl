{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'blog'}
    {$sMenuSelectSub = 'blog_topic'}
{/block}

{block name='layout_content'}
    <h2>Статьи</h2>
    <div class="cl h20"></div>
    <a href="{$ADMIN_URL}blog/topic/add/" class="ls-button">Добавить</a>
    <div class="cl h20"></div>

    {include file="{$aTemplatePathPlugin.admin}blog.topic/list.tpl"}
{/block}