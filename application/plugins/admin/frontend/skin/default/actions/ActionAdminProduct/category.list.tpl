{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'product'}
{/block}

{block name='layout_content'}
    <div class="dflex blocks">
        <div class="block">
            <div class="title">Найти товар</div>
            Название товара&nbsp;&nbsp; <input type="text" class="product autocomplete-pro"
                                               value="{$smarty.get.search}">
            <small class="note">Начните вбивать название товара. Затем кликните по нужному, чтобы <b>перейти в
                    редактирование</b></small>
        </div>
        <form action="{$ADMIN_URL}product/add/" method="post">
            <div class="block">

                <div class="title">Добавить новый товар</div>
                Название товара&nbsp;&nbsp;<div class="autocomplete-wrap" style="display: inline-block;"><input
                            type="text" class="product" name="product_name"></div>
                {component button text="Добавить" classes='fr' attributes=['style'=>'top:5px; right: -20px;']}
            </div>
            <div class="cl" style="height: 30px;"></div>
            {if $oCategory}
                {component field template='hidden' name='category_id' value=$oCategory->getId()}
            {/if}
        </form>
    </div>
    <h2 class="page-sub-header">Выберите категорию{if $iCategoryId}: {$oCategory->getTitle()}{/if}</h2>
    {if $iCategoryId}
        {if $_aRequest.action && $_aRequest.action ==  'add'}
            {* Добавление подкатегории (уже была неудачная попытка)*}
            {include file="{$aTemplatePathPlugin.admin}forms/form.add.category.tpl" bAction='add' bRedactorInit=true}
        {else}
            {* Редактирование категории *}
            {include file="{$aTemplatePathPlugin.admin}forms/form.add.category.tpl" bAction='update' oCategoryCurrent=$oCategory}
            {*{$oCategory|prex}*}
            {if $oCategory->getSubCats()}
                {include file="{$aTemplatePathPlugin.admin}category/list.tpl" aCategoryTree=$oCategory->getSubCats()}
            {/if}
            {* Добавление подкатегории*}
            {include file="{$aTemplatePathPlugin.admin}forms/form.add.category.tpl" bAction='add' bRedactorInit=true}
        {/if}
    {else}
        {* Корневая категори *}
        {include file="{$aTemplatePathPlugin.admin}category/list.tpl" bProductList=true}
        <div class="cl" style="height: 20px"></div>
        <a href="{$ADMIN_URL}product/import-data/" class="ls-button">Импорт товаров</a>
        <a href="{$ADMIN_URL}product/design/import-data/" class="ls-button">Импорт дизайнов</a>
        <a href="{$ADMIN_URL}product/import-kypit-divan/" class="ls-button">Импорт c купить диван</a>
    {/if}
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.product.autocomplete-pro').autocompletePro({
                name: 'products',
                url: ADMIN_URL + 'product/ajax/search/',
                url_search: ADMIN_URL + 'product/',
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
