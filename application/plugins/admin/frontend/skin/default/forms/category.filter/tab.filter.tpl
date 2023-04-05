<div class="dflex">
    {component field template='text'
    label   = 'Цена от'
    name    = 'category_filter[price_from]'
    value   = $oCategoryFilter->getPriceFrom()}
    {component field template='text'
    label   = 'Цена до'
    name    = 'category_filter[price_to]'
    value   = $oCategoryFilter->getPriceTo()}
</div>

{component field template='select'
label       = 'Производитель'
name        = 'category_filter[make][]'
items       = $aMakeSelect
selectedValue = $oCategoryFilter->getMakeArrayId()
isMultiple  = true}

{component field template='text'
label       = 'Название'
name        = 'category_filter[name]'
items       = $aCategorySelect
note        = "Часть названии LIKE '%name%'"
value = $oCategoryFilter->getName()}

{component field template='select'
label           = 'Цвет'
name            = 'category_filter[color][]'
items           = Config::Get('colors')
selectedValue   = $oCategoryFilter->getColorArray()
isMultiple  = true}

{component field template='checkbox'
label       = 'Новинки'
name        = 'category_filter[novinki]'
checked     = $oCategoryFilter->getNovinki()}

{component field template='checkbox'
label       = 'Со скидкой'
name        = 'category_filter[sale]'
checked     = $oCategoryFilter->getSale()}

<h3>Характеристики</h3>
<div class="chars-list">
    {foreach $oCategoryFilter->getChars() as $oChar}
        {include file="{$aTemplatePathPlugin.admin}category.filter/char.type.{$oChar->getTypeText()}.tpl"}
    {/foreach}
</div>

{component field template='text'
label           = 'Добавить хар-ку'
name            = 'chars'
inputClasses    = 'chars autocomplete-pro w600'
inputAttributes = ['autocomplete' => 'off']}

{capture name="scripts"}
<script>
    $(function () {
        /**
         * Поиск характеристики
         */
        $('.chars.autocomplete-pro').autocompletePro({
            name: 'chars',
            url: ADMIN_URL + 'char/ajax/search/',
            url_search: ADMIN_URL + 'product/design/',
            render: function (obj) {
                var item =
                    '<div class="row" data-id="' + obj.id + '">' +
                    '<span>' + obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ' : '') + '</span>' +
                    '</div>';
                return item;
            }
        }, function (obj) {
            ls.ajax.load(ADMIN_URL + 'char/ajax/get-html/', { id: obj.id }, function(answ){
                if ($('#char'+answ.iId).length > 0) {
                    ls.msg.error('Такая хар-ка уже добавлена');
                } else {
                    $('.chars-list').append(answ.sHtml);
                    if (answ.sType == 'select.one' || answ.sType == 'select.multiple') {
                        $('#char' + answ.iId).selectStylized();
                        log($('#char' + answ.iId));
                    }
                }
            });
        });
        $('.char .ls-icon-remove').on('click', function(){
            $(this).parents('.char').remove();
        });
    });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}