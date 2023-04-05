{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'discount'}
{/block}

{block name='layout_content'}
    {* Форма добавления товара *}
    {*{if $oCategory}{include file="{$aTemplatePathPlugin.admin}forms/form.add.product.tpl" bAction='add'}{/if}*}
    <h2 class="page-sub-header">Скидки на товары</h2>
{*    <div class="dflex blocks">*}
{*        <div class="block">*}
{*            <div class="title">Найти товар</div>*}
{*            Название товара&nbsp;&nbsp; <input type="text" class="product autocomplete-pro" value="{$smarty.get.search}" >*}
{*            <small class="note">Начните вбивать название товара. Затем кликните по нужному, чтобы <b>перейти в*}
{*                    редактирование</b></small>*}
{*        </div>*}
{*        <form action="{$ADMIN_URL}product/add/" method="post">*}
{*            <div class="block">*}

{*                <div class="title">Добавить новый товар</div>*}
{*                Название товара&nbsp;&nbsp;<div class="autocomplete-wrap" style="display: inline-block;"><input*}
{*                            type="text" class="product" name="product_name"></div>*}
{*                {component button text="Добавить" classes='fr' attributes=['style'=>'top:5px; right: -20px;']}*}
{*            </div>*}
{*            <div class="cl" style="height: 30px;"></div>*}
{*            {if $oCategory}*}
{*                {component field template='hidden' name='category_id' value=$oCategory->getId()}*}
{*            {/if}*}
{*        </form>*}
{*    </div>*}
    {include file="{$aTemplatePathPlugin.admin}product/discount.list.tpl"}
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.product.autocomplete-pro').autocompletePro({
                name: 'products',
                url: ADMIN_URL + 'product/ajax/search/',
                {if $oCategory}
                url_search: ADMIN_URL + 'product/category/' + {$oCategory->getId()} + '/',
                {else}
                url_search: ADMIN_URL + 'product/',
                {/if}
                name_search: 'search',
                render: function (obj) {
                    var item =
                        '<div class="row" data-id="' + obj.id + '">' +
                        '<span>' + obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ' : '') + '</span>' +
                        '</div>';
                    return item;
                }
            }, function (obj) {
                window.location.href = ADMIN_URL + 'product/' + obj.id + '/';
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}
