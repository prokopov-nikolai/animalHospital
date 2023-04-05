<script type="text/javascript">
	$(function(){
		$('.type-title').click(function(){
			$('input[name="type_title"]').val($(this).html());
			return false;
		});
	});
</script>

<form action="" method="post" onsubmit="ls.plugin.shop.fabric.updateTypeTitle($(this)); return false;">
	{* Название типа *}
	{include file='components/field/field.text.tpl'
		sName        = 'type_title'
		sValue       = $oFabric->getTypeTitle()|escape:'html'
		sLabel       = 'Тип ткани'}

	{* Название коллекции *}
	{include file='components/field/field.hidden.tpl'
		sName        = 'collection_title'
		sValue       = $oFabric->getCollectionTitle()|escape:'html'}

	{* Список типов для подстановки *}
	{foreach $aType as $oType}
		<a href="#" class="type-title">{$oType->getTypeTitle()}</a>
	{/foreach}
	<div class="clear" style="height: 20px;"></div>

	{* Сохранить *}
	{include file='components/button/button.tpl'
		sId='submit-update-type-title'
		sClasses='btn btn-primary'
		sText='Сохранить'}
</form>