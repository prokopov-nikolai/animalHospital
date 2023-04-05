{capture name='sTabMain'}  {include file="{$aTemplatePathPlugin.admin}forms/make/tab.main.tpl"} {/capture}
{capture name='sTabSeo'}   {include file="{$aTemplatePathPlugin.admin}forms/make/tab.seo.tpl"} {/capture}


<form action="" method="post" id="form-make">
    {component 'tabs' classes='' mods='align-top' tabs=[
    [ 'text' => 'Основное',   'body' => $smarty.capture.sTabMain],
    [ 'text' => 'Seo',   'body' => $smarty.capture.sTabSeo]
    ]}

    {component 'button'
    text = 'Сохранить'
    mods = 'primary'
    name = "submit_user_{$sEvent}"}
    &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
</form>

{capture name='script'}
    <script>
        $(function(){
            $('input[name="make[phone]"]').mask('+7 (999) 999-99-99');
            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#form-make').submit();
                    return false;
                }
            });
        });
    </script>
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}
