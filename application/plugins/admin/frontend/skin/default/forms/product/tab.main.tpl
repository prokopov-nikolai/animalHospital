{* Категория *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.select.tpl"
sName        = 'product[category_id]'
sLabel       = 'Категория'
aItems       = $aCategorySelect
sSelectedValue= {($oProduct) ? $oProduct->getCategoryId() : $iCategoryId}}

{* Производитель *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.select.tpl"
sName        = 'product[make_id]'
sLabel       = 'Производитель'
aItems       = $aMakeSelect
sSelectedValue= {($oProduct) ? $oProduct->getMakeId() : $iMakeId}}

{* Название *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"
sName        = 'product[title]'
sLabel       = 'Название товара'
sValue       = {($oProduct) ? $oProduct->getTitle() : ''}|escape}

<div class="field">
    <label for="" class="field-label">Полное наименование</label>
    <div class="field-value">{($oProduct) ? $oProduct->getTitleFull() : ''}</div>
</div>

{* Урл *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"
sName        = 'product[url]'
sLabel       = 'Урл товара'
sNote        = $oProduct->getUrlFull()
sValue       = "{$oProduct->getUrl()}"}

{* Цвет *}
{component field template='select'
label           = 'Цвет'
name            = 'product[color]'
items           = Config::Get('colors')
selectedValue   = $oProduct->getColor()}

{* Описание *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.textarea.tpl"
sName        = 'product[text]'
sLabel       = 'Описание'
sClasses     = 'redactor width-full text-'|cat:$bAction
sInputClasses = 'redactor'
iRows        = 10
sValue       = {($oProduct) ? $oProduct->getText() : ''}}

{* Новинка *}
{component field template='date'
label           = 'Дата истечения новинки'
name            = 'product[date_new_before]'
value           = $oProduct->getDateNewBefore()|date_format:'d.m.Y'
inputAttributes = [ 'autocomplete' => 'off']}

{* Наличие *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"
sName        = 'product[in_stock]'
sLabel       = 'В наличии'
sValue       = 1
bChecked     = {($oProduct && $oProduct->getInStock()) ? true : false}}

{* Скрыть *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"
sName        = 'product[hide]'
sLabel       = 'Скрыть товар'
sValue       = 1
bChecked     = {($oProduct && $oProduct->getHide()) ? true : false}}

{* Снят с производства *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"
sName        = 'product[not_produced]'
sLabel       = 'Снят с производства'
sValue       = 1
bChecked     = {($oProduct && $oProduct->getNotProduced()) ? true : false}}

{* Яндекс.Маркет *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"
sName        = 'product[market]'
sLabel       = 'Яндекс.Маркет (DBS)'
sValue       = 1
bChecked     = {($oProduct && $oProduct->getMarket()) ? true : false}}

{* Использовать новый умл *}
{*{include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"*}
{*sName        = 'product[new_yml]'*}
{*sLabel       = 'Новый Yml формат для маркета'*}
{*sValue       = 1*}
{*bChecked     = {($oProduct && $oProduct->getNewYml()) ? true : false}}*}

{* Использовать новый умл *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"
sName        = 'product[3d]'
sLabel       = 'Выводить 3d фото'
sValue       = 1
bChecked     = {($oProduct && $oProduct->get3d()) ? true : false}}

{* Просмотры *}
{component field template='text'
label           = 'Количество просмотров'
name            = 'product[views]'
value           = $oProduct->getViews()}

{* Номер в слайдере *}
{component field template='text'
label           = 'Популярное (номер в слайдере)'
name            = 'product[slide_number]'
value           = $oProduct->getSlideNumber()}

{* Внешний айди *}
{component field template='text'
label           = 'external_id'
name            = 'product[external_id]'
value           = $oProduct->getExternalId()}

{* Видео на ютубе *}
{component field template='text'
label           = 'youtube_video_id'
name            = 'product[youtube_video_id]'
value           = $oProduct->getYoutubeVideoId()}
