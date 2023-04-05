{$oProduct = $oDesign->getProduct()}
<div class="ls-field">
    <label class="ls-label">Название товара</label>
    &nbsp;&nbsp; <input type="text" class="product autocomplete-pro" value="{$oProduct->getTitleFull()}" style="width: 300px;">
    &nbsp;&nbsp;&nbsp;<a href="{$ADMIN_URL}product/{$oProduct->getId()}/" target="_blank" title="Перейти в карточку товара" class="ls-icon-pencil"></a>
    <small class="note">Начните вбивать название товара. Затем кликните по нужному, чтобы <b>изменить</b></small>
</div>
{component field template='hidden'
name    = 'design[product_id]'
id      = 'product_id'
value   = ($oDesign) ? $oDesign->getProductId() : ''}

{component field template='text'
label   = 'Название дизайна'
name    = 'design[title]'
value   = ($oDesign) ? $oDesign->_getDataOne('title') : ''}

{component field template='text'
label   = 'Url'
name    = 'design[url]'
note    = 'Если пусто, то будет сгенерировано автоматически'
value   = ($oDesign) ? $oDesign->getUrl() : ''}

{* Новинка *}
{component field template='date'
label           = 'Дата истечения новинки'
name            = 'design[date_new_before]'
value           = $oDesign->getDateNewBefore()|date_format:'d.m.Y'
inputAttributes = [ 'autocomplete' => 'off']}

{component field template='select'
label           = 'Цвет'
name            = 'design[color]'
items           = Config::Get('colors')
selectedValue   = $oDesign->getColor()}

{component field template='checkbox'
label   = 'В наличии'
name    = 'design[in_stock]'
value   = 1
checked = ($oDesign) ? $oDesign->getInStock() : ''}

{* Просмотры *}
{component field template='text'
label           = 'Количество просмотров'
name            = 'design[views]'
value           = $oDesign->getViews()}

{* Номер в слайдере *}
{component field template='text'
label           = 'Номер в слайдере'
name            = 'design[slide_number]'
value           = $oDesign->getSlideNumber()}

{component field template='checkbox'
label   = 'Снято с производства'
name    = 'design[not_produced]'
value   = 1
checked = ($oDesign) ? $oDesign->getNotProduced() : ''}

{component field template='checkbox'
label   = 'Скрыть'
name    = 'design[hide]'
value   = 1
checked = ($oDesign) ? $oDesign->getHide() : ''}

{* about *}
{component field template='textarea'
name            = 'design[text]'
label           = 'Описание'
rows            = 10
inputClasses    = 'ace-redactor'
inputAttributes = ['style' => "display:none;", 'data-redactor-id' => "design-text"]
value           = ($oDesign) ? $oDesign->getText() : ''}
<div id="design-text" style="min-height:200px;"></div>
<div class="cl" style="height: 30px;"></div>