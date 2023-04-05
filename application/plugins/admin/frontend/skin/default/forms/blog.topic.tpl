{capture name='sTabMain'}   {include file="{$aTemplatePathPlugin.admin}forms/blog.topic/tab.main.tpl"} {/capture}
{capture name='sTabSeo'}    {include file="{$aTemplatePathPlugin.admin}forms/blog.topic/tab.seo.tpl"} {/capture}

<div class="ls-clearfix">
    <form action="" method="post" enctype="multipart/form-data" id="blog-topic">
        {component 'tabs' classes='' mods='align-top' tabs=[
        [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
        [ 'text' => 'Seo',          'body' => $smarty.capture.sTabSeo]
        ]}

        {component field template="hidden"
        name        = 'topic[id]'
        value       = $oTopic->getId()}

        {component button text='Сохранить' mods='primary'}
        &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
    </form>
</div>
