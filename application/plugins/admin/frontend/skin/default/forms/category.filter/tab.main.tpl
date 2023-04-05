{component field template='select'
label       = 'Родительская категория'
name        = 'category_filter[parent_id]'
items       = $aCategoryFilterSelect
selectedValue = $oCategoryFilter->getParentId()}

{component field template='select'
label       = 'Группа'
name        = 'category_filter[group_by]'
items       = Config::Get('category.group_by')
selectedValue = $oCategoryFilter->getGroupBy()}

{component field template='text'
name        = 'category_filter[title]'
label       = 'Название'
value       = $oCategoryFilter->getTitle()}

{component field template='text'
name        = 'category_filter[alias]'
label       = 'Алиас'
value       = $oCategoryFilter->getAlias()}

{component field template='text'
name        = 'category_filter[product_prefix]'
label       = 'Префикс товара'
value       = $oCategoryFilter->getProductPrefix()}

{component field template='text'
name        = 'category_filter[url]'
label       = 'Урл категории'
value       = $oCategoryFilter->getUrl()}

{component field template='text'
name        = 'category_filter[url]'
label       = 'Полный урл категории'
isDisabled  = true
value       = $oCategoryFilter->getUrlFull()}

{component field template='textarea'
name            = 'category_filter[text_top]'
label           = 'Описание (вверху)'
iRows           = 10
inputClasses    = 'ace-redactor'
inputAttributes = ['style' => "display:none;", 'data-redactor-id' => "filter-text-top"]
value       = $oCategoryFilter->getTextTop()}
<div id="filter-text-top" style="min-height:200px;"></div>
<div class="cl" style="height: 30px;"></div>

{component field template='textarea'
name            = 'category_filter[text_bottom]'
label           = 'Описание (внизу)'
iRows           = 10
inputClasses    = 'ace-redactor'
inputAttributes = ['style' => "display:none;", 'data-redactor-id' => "filter-text-bottom"]
value       = $oCategoryFilter->getTextTop()}
<div id="filter-text-bottom" style="min-height:200px;"></div>
<div class="cl" style="height: 30px;"></div>

{component field template='checkbox'
label       = 'Отображать в меню'
name        = 'category_filter[in_menu]'
checked      = $oCategoryFilter->getInMenu()}

{component field template='checkbox'
label       = 'Базовая категория, в которой лежат товары'
name        = 'category_filter[base]'
checked      = $oCategoryFilter->getBase()}

{*{if $oCategoryFilter->getParentId() == 0}*}
{*    <small>Новинки, популярное, распродажа выводятся только для категорий 1 уровня</small>*}
{*    {component field template='checkbox'*}
{*    label       = 'Новинки'*}
{*    name        = 'category_filter[menu_novinki]'*}
{*    checked      = $oCategoryFilter->getNovinki()}*}

{*    {component field template='checkbox'*}
{*    label       = 'Популярное'*}
{*    name        = 'category_filter[menu_popular]'*}
{*    checked      = $oCategoryFilter->getPopular()}*}

{*    {component field template='checkbox'*}
{*    label       = 'Распродажа'*}
{*    name        = 'category_filter[menu_sale]'*}
{*    checked      = $oCategoryFilter->getSale()}*}
{*{/if}*}
