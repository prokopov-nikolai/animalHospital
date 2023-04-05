{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'fabric'}
	{$sMenuSelectSub = 'collection_add'}
{/block}

{block name='layout_head_end'}
	<script type="text/javascript">
		$(function(){
			ls.ajax.form('ADMIN_URLfabric/ajax/fabric_edit/', '#fabric_edit', function(aData){
				window.location.href = aData.sUrlRedirect;
			});
		});
	</script>
{/block}

{block name='layout_content'}
	<h2>Переносим ткань</h2>
	{*{$oFabric|pr}*}
	<form action="" method="post" id="fabric_edit">
		<div class="field">
			<label for="" class="field-label">Коллекция</label>
			<select name="collection_title" id="" class="field-input">
				{foreach $aCollectionSelect as $aData}
					<option value="{$aData.value}" {if {$aData.value} == $oFabric->getCollectionTitle()|cat:'/'|cat:$oFabric->getMakeTitle()} selected{/if}>{$aData.text}</option>
				{/foreach}
			</select>
		</div>

		<input type="hidden" name="id" value="{$oFabric->getId()}"/>

		<div class="field">
			<label for="" class="field-label">Название ткани</label>
			{$oFabric->getTitle()}
		</div>

		<div class="field">
			<label for="" class="field-label">Производитель</label>
			{$oFabric->getMakeTitle()}
		</div>

		<div class="field">
			{$oMedia = $oFabric->getMedia()}
			<img src="{$oMedia[0]->getFileWebPath('200crop')}" alt=""/>
		</div>

		<button class="btn btn-primary">Обновить</button>
		{if $oFabric->getHide() == 0}
			<a href="{Config::Get('url_adm')}fabric/hide/{$oFabric->getId()}/" class="btn btn-danger">Скрыть ткань</a>
		{else}
			<a href="{Config::Get('url_adm')}fabric/show/{$oFabric->getId()}/" class="btn btn-success">Отобразить ткань</a>
		{/if}
	</form>
	<div class="list-image"></div>
{/block}