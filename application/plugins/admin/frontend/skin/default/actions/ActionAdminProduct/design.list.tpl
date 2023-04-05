{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'design'}
{/block}

{block name='layout_content'}
    <h1>Дизайны</h1>
    <div class="dflex blocks">
        <div class="block">
            <div class="title">Поиск дизайна</div>
            Название дизайна&nbsp;&nbsp; <input type="text" class="design autocomplete-pro" value="{$smarty.get.search}">
            <small class="note">Начните вбивать название дизайна. Затем кликните по нужному, чтобы перейти в <b>редактирование</b></small>
        </div>
        <div class="block">
            <div class="title">Добавить дизайн</div>
            Название товара&nbsp;&nbsp; <input type="text" class="product autocomplete-pro">
            <small class="note">Начните вбивать название товара. Затем кликните по нужному, чтобы <b>добавить</b></small>
        </div>
    </div>
    {if $smarty.get.avito}
        <a href="{$ADMIN_URL}product/design/">Показать все дизайны</a>
        {include file="{$aTemplatePathPlugin.admin}design/avito.list.tpl"}
    {else}
        <a href="{$ADMIN_URL}product/design/?avito=1">Показать опубликованные на Avito</a>
{*        /// <a href="{$ADMIN_URL}product/design/main-photo-update/">Изменить главное фото ДИЗАЙНА на вид сбоку</a> *}
{*        /// <a href="{$ADMIN_URL}product/main-photo-update/">Изменить главное фото ТОВАРА на вид сбоку</a>*}
        {include file="{$aTemplatePathPlugin.admin}design/list.tpl"}
    {/if}
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.product.autocomplete-pro').autocompletePro({
                name: 'products',
                url: ADMIN_URL+'product/ajax/search/',
                name_search: 'search',
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>'+obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ': '')+'</span>'+
                        '</div>';
                    return item;
                }
            }, function(obj){
                log(obj);
                ls.ajax.load(ADMIN_URL+'product/ajax/design/add/',{
                    id: obj.id
                }, function(answ) {
                    window.location.href = ADMIN_URL+'product/design/'+answ.design_id+'/';
                })
            });
            $('.design.autocomplete-pro').autocompletePro({
                name: 'designs',
                url: ADMIN_URL+'product/ajax/design/search/',
                url_search: ADMIN_URL+'product/design/',
                name_search: 'search',
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>'+obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ': '')+'</span>'+
                        '</div>';
                    return item;
                }
            }, function(obj){
                window.location.href = ADMIN_URL+'product/design/'+obj.id+'/'
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}