{capture name='sTabMain'}   {include file="{$aTemplatePathPlugin.admin}forms/blog/tab.main.tpl"} {/capture}
{capture name='sTabSeo'}    {include file="{$aTemplatePathPlugin.admin}forms/blog/tab.seo.tpl"} {/capture}

<div class="ls-clearfix">
    <form action="" method="post" enctype="multipart/form-data" id="blog-topic">
        {component 'tabs' classes='' mods='align-top' tabs=[
        [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
        [ 'text' => 'Seo',          'body' => $smarty.capture.sTabSeo]
        ]}

        {component field template="hidden"
        name        = 'blog[id]'
        value       = $oBlog->getId()}

        {component button text='Сохранить' mods='primary'}
    </form>
</div>