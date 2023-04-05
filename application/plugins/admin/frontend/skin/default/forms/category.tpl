{capture name='sTabMain'}   {include file="{$aTemplatePathPlugin.admin}forms/category/tab.main.tpl"} {/capture}
{capture name='sTabSeo'}    {include file="{$aTemplatePathPlugin.admin}forms/category/tab.seo.tpl"} {/capture}
{capture name='sTabChars'}  {include file="{$aTemplatePathPlugin.admin}forms/category/tab.chars.tpl"} {/capture}

<div class="ls-clearfix">
    <form action="" method="post" enctype="multipart/form-data" id="form-category">
        {component 'tabs' classes='' mods='align-top' tabs=[
        [ 'text' => 'Основное',   'body' => $smarty.capture.sTabMain],
        [ 'text' => 'Seo',   'body' => $smarty.capture.sTabSeo],
        [ 'text' => 'Хар-ки',   'body' => $smarty.capture.sTabChars]
        ]}

        {component field template='hidden'
        name        = 'category[id]'
        value       = $oCategory->getId()}

        {component button text='Сохранить' mods='primary'}
        &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
    </form>
</div>

{capture name='script'}
    <script type="text/javascript">
        $(function () {
            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#form-category').submit();
                    return false;
                }
            });
        });
    </script>

{/capture}

{LS::Append('scripts', $smarty.capture.script)}
