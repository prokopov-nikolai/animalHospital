{* Название категории *}
{component field template='text'
name        = 'category[title]'
label       = 'Название категории'
value       = {($oCategory) ? $oCategory->getTitle() : ''}}

{* Название категории *}
{component field template='text'
name        = 'category[product_prefix]'
label       = 'Префикс товара'
value       = {($oCategory) ? $oCategory->getProductPrefix() : ''}}

{* Урл категории *}
{*{component field template='text'*}
{*name        = 'category[url]'*}
{*label       = 'Урл категории'*}
{*isDisabled  = true*}
{*value       = {($oCategory) ? $oCategory->getUrlFull() : ''}}*}

{* Урл категории *}
{component field template='hidden'
name        = 'category[url]'
value       = {($oCategory) ? $oCategory->getUrl() : ''}}

<label for="" class="ls-label">Урл</label>
<div class="ls-field"><a href="{$oCategory->getUrlFull()}" target="_blank">{$oCategory->getUrlFull()}</a></div>
{component field template='checkbox'
name        = 'update_url'
label       = 'Обновить урл'}

{* Описание *}
{component field template='textarea'
name            = 'category_filter[text_top]'
label           = 'Описание (вверху)'
rows            = 10
inputClasses    = 'ace-redactor'
inputAttributes = ['style' => "display:none;", 'data-redactor-id' => "category-text-top"]
value           = $oCategory->getTextTop()}
<div id="category-text-top" style="min-height:200px;"></div>
<div class="cl" style="height: 30px;"></div>

{* Описание *}
{component field template='textarea'
name            = 'category_filter[text]'
label           = 'Описание (внизу)'
iRows           = 10
inputClasses    = 'ace-redactor'
inputAttributes = ['style' => "display:none;", 'data-redactor-id' => "category-text-bottom"]
value           = $oCategory->getText()}
<div id="category-text-bottom" style="min-height:200px;"></div>
<div class="cl" style="height: 30px;"></div>
