{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'collection'}
    {$sMenuSelectSub = 'collection_list'}
{/block}

{block name='layout_content'}
    <h2 class="page-sub-header">Список коллекций</h2>
    <div class="dflex blocks">
        <div class="block">
            <div class="title">Найти коллекцию</div>
            Название кол-ции&nbsp;&nbsp; <input type="text" class="collection autocomplete-pro">
            <div class="cl"></div>
            <small class="note">Начните вбивать название коллекции. Затем кликните по нужному, чтобы <b>перейти в
                    редактирование</b></small>
        </div>
        <div class="block">
            <form action="{$ADMIN_URL}collection/add/" method="post">
                <div class="title">Добавить новую коллекцию</div>
                Название кол-ции&nbsp;&nbsp;<div class="autocomplete-wrap" style="display: inline-block;"><input
                            type="text" class="product" name="collection_title"></div>
                {component button text="Добавить кол-цию" classes='fr' attributes=['style'=>'top:10px; right: 40px;']}

            </form>
        </div>
        <div class="cl" style="height: 30px;"></div>
    </div>
    {include file="{$aTemplatePathPlugin.admin}collection/filter.tpl"}
    {include file="{$aTemplatePathPlugin.admin}collection/list.tpl"}
    {component pagination paging=$aPaging }
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.collection.autocomplete-pro').autocompletePro({
                name: 'collections',
                url: ADMIN_URL + 'collection/ajax/search/',
                url_search: ADMIN_URL + 'collection/',
                render: function (obj) {
                    var item =
                        '<div class="row" data-id="' + obj.id + '">' +
                        '<span>' + obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ' : '') + '</span>' +
                        '</div>';
                    return item;
                }
            }, function (obj) {
                window.location.href = ADMIN_URL + 'collection/edit/' + obj.id + '/';
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}