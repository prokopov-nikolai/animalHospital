{$tabs = []}

{if LS::HasRight('2_users_edit')}
    {capture name='sTabMain'}     {include file="{$aTemplatePathPlugin.admin}forms/user/tab.main.tpl"}     {/capture}
    {$tabs[] = [ 'text' => 'Основное',    'body' => $smarty.capture.sTabMain]}
{/if}
{if LS::HasRight('3_users_edit_rights') && $oUser->getId()}
    {capture name='sTabRights'}   {include file="{$aTemplatePathPlugin.admin}forms/user/tab.rights.tpl"}   {/capture}
    {$tabs[] = [ 'text' => 'Права',       'body' => $smarty.capture.sTabRights,  'uid' => 'user-rights']}
{/if}

<form action="" method="post" id="user-form" enctype="multipart/form-data">
    {component 'tabs' classes='' mods='align-top' tabs=$tabs}

    {component 'button'
    text = 'Сохранить'
    mods = 'primary'
    name = "submit_user_{$sEvent}"}
    &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
</form>

{capture name='script'}
    <script>
        $(function () {
            $('input[name="user[phone]"], input[name="user[phone_dop]"]').mask('+7 (999) 999-99-99');
            {if LS::HasRight('3_users_edit_rights') && $oUser->getId()}
                $('#user-rights input[type="checkbox"]').on('click', function() {
                    let aData = {
                        iRightId: this.value,
                        bChecked: this.checked,
                        iUserId: {$oUser->getId()}
                    };
                    ls.ajax.load(ADMIN_URL+'users/ajax/right/change/', aData);
                });
            {/if}
            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#user-form').submit();
                    return false;
                }
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}
