{$tabs = []}

{if LS::HasRight('5_pets_edit')}
    {capture name='sTabMain'}     {include file="{$aTemplatePathPlugin.admin}forms/pet/tab.main.tpl"}     {/capture}
    {$tabs[] = [ 'text' => 'Основное',    'body' => $smarty.capture.sTabMain]}
{/if}

<form action="" method="post" id="pet-form" enctype="multipart/form-data">
    {component 'tabs' classes='' mods='align-top' tabs=$tabs}

    {component 'button'
    text = 'Сохранить'
    mods = 'primary'
    name = "submit_pet_{$sEvent}"}
    &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
</form>

{capture name='script'}
    <script>
        $(function () {
            $('.user.autocomplete-pro').autocompletePro({
                name: 'users',
                name_search: 'search',
                url: ADMIN_URL+'users/ajax/search/',
                url_search: ADMIN_URL+'user/',
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>' + obj.fio + ' // ' + obj.phone + ' // ' + obj.email + ' // ' + (obj.is_agent ? 'Агент' : '' ) + '</span>'
                    '</div>';
                    return item;
                }
            }, function(obj){
                $('.user.autocomplete-pro').val(obj.fio);
                $('#pet-user-id').val(obj.id);
            });

            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#pet-form').submit();
                    return false;
                }
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}
