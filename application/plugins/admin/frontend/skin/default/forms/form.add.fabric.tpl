<script type="text/javascript">
	$(function(){
		$('#submit-add-fabric').bind('click', function(){
			$('#form-add-fabric .dn').slideToggle();
			$('#submit-add-fabric').unbind('click');
			return false;
		});
	});
</script>


<div class="cl" style="height: 20px;"></div>
<form action="" method="post" enctype="multipart/form-data"  onsubmit="ls.plugin.shop.fabric.addFabric($(this)); return false;" id="form-add-fabric">
	<div class="dn">
		{* Производитель ткани *}
		{if $bTypeHidden === true}
			{include file='components/field/field.hidden.tpl'
			sName        = 'fabric[make_title]'
			sValue       = $oFabric->getMakeTitle()}
		{else}
			{include file='components/field/field.text.tpl'
			sName        = 'fabric[make_title]'
			sValue       = ''
			sLabel       = 'Производитель ткани'}
		{/if}

		{* Название коллекции *}
		{if $bTypeHidden === true}
			{include file='components/field/field.hidden.tpl'
				sName        = 'fabric[collection_title]'
				sValue       = $oFabric->getCollectionTitle()}
		{else}
			{include file='components/field/field.text.tpl'
				sName        = 'fabric[collection_title]'
				sValue       = ''
				sLabel       = 'Название коллекции'}
		{/if}

		{* Название ткани *}
		{include file='components/field/field.text.tpl'
			sName        = 'fabric[title]'
			sLabel       = 'Название ткани'}

		{* Изображение *}
		{include file='components/field/field.file.tpl'
			sName        = 'fabric_file'
			sLabel       = 'Выберите изображение'}

		{* Ссылка на изображение *}
		{include file='components/field/field.text.tpl'
			sName        = 'fabric_url'
			sLabel       = 'Или укажите ссылка на изображение'}
	</div>

	{* Название типа ткани *}
	{include file='components/field/field.hidden.tpl'
		sName        = 'fabric[type_title]'
		sValue       = ($oFabric) ? $oFabric->getTypeTitle() : ''}

	{* Айди группы *}
	{include file='components/field/field.hidden.tpl'
		sName        = 'fabric[group_id]'
		sValue       = $oGroup->getId()}
	<br>
	{* Сохранить *}
	{include file='components/button/button.tpl'
		sId='submit-add-fabric'
		sClasses='btn btn-primary'
		sText='Добавить ткань'}
</form>