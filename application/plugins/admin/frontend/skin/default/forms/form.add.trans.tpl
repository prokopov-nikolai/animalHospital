<form action="" method="post" enctype="multipart/form-data" id="form-char-{$bAction}">
	<div class="dn trans-add">
	{* Дата *}
	{include file='components/field/field.text.tpl'
		sName        = 'trans[date]'
		sLabel       = 'Дата'
		sInputClasses     = 'date datepicker '
		sValue       = {$smarty.now|date_format:'Y-m-d H:i:s'}}

	{* Тип *}
	{include file='components/field/field.select.tpl'
		sName        = 'trans[direction]'
		sLabel       = 'Пополнение / Расход'
		aItems       = [['text' =>'---', 'value' => 0], ['text' =>'Пополнение', 'value' => 'income'], ['text' =>'Расход', 'value' => 'outcome']]}

	{* Наименование *}
	{include file='components/field/field.select.tpl'
		sName        = 'trans[title]'
		sLabel       = 'Наименование'
		aItems       = [
		['text' =>'---', 'value' => 0],
		['text' =>'Пополнение', 'value' => 'Пополнение'],
		['text' =>'Yandex.Market', 'value' => 'Yandex.Market'],
		['text' =>'Yandex.Direct', 'value' => 'Yandex.Direct'],
		['text' =>'Товары@mail.ru', 'value' => 'Товары@mail.ru'],
		['text' =>'Google.AdWords', 'value' => 'Google.AdWords'],
		['text' =>'Отзывы', 'value' => 'Отзывы'],
		['text' =>'Ссылки', 'value' => 'Ссылки'],
		['text' =>'SEO', 'value' => 'SEO'],
		['text' =>'Продажи', 'value' => 'Продажи'],
		['text' =>'Прочее', 'value' => 'Прочее']
		]}

	{* Сумма *}
	{include file='components/field/field.text.tpl'
		sName        = 'trans[sum]'
		sLabel       = 'Сумма'}

	{* Значения *}
	{include file='components/field/field.textarea.tpl'
		sName        = 'trans[comment]'
		sLabel       = 'Комментарий'
		iRows        = 10}

	</div>
	&nbsp;<br>
	{include file='components/button/button.tpl'
		sId        ='submit-add-trans'
		sClasses   ='btn btn-primary'
		sText      ='Добавить'
		sValue     = 1}
</form>
