{capture name='sTabMain'}  {include file="{$aTemplatePathPlugin.admin}forms/option/tab.main.tpl"} {/capture}
{capture name='sTabItems'}  {include file="{$aTemplatePathPlugin.admin}forms/option/tab.items.tpl"} {/capture}


<form action="" method="post" id="form-option">
    {component 'tabs' classes='' mods='align-top' tabs=[
    [ 'text' => 'Основное',   'body' => $smarty.capture.sTabMain],
    [ 'text' => 'Значения',   'body' => $smarty.capture.sTabItems]
    ]}

    {component 'button'
    text = 'Сохранить'
    mods = 'primary'
    name = "submit_option_{$sEvent}"}
    &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
</form>

{capture name='script'}
    <script>
        $(function(){
            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#form-option').submit();
                    return false;
                }
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}