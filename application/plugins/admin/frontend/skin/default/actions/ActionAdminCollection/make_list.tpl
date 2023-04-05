{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'fabric'}
{/block}

{block name='layout_content'}
	<h3>Добавить коллекцию</h3>
	<form action="{Config::Get('url_adm')}fabric/collection/add/" method="post" enctype="multipart/form-data">
		<table class="table">
			<tr>
				<td><div class="ls-field">
						<label for="">Название коллекции</label><br>
						<input type="text" name="collection_title" value="">
					</div></td>
				<td><div class="ls-field">
						<label for="">Тип ткани</label><br>
						<select name="type_title">
							{foreach Config::Get('plugin.shop.fabric_type_descr') as $sType => $aD}
								<option value="{$aD.title}">{$aD.title}</option>
							{/foreach}
						</select>
					</div>
				</td>
				<td><div class="ls-field">
						<label for="">Изображения</label><br>
						<input type="file" name="images[]" multiple="true">
					</div></td>
			</tr>
			<tr>
				<td>
					<div class="ls-field">
						<label for="">Группа</label><br>
						<select name="group_id" id="">
							{for $i = 0 ; $i < 16; $i++}<option value="{$i}">{($i == 0) ? 'Спец.' : $i|cat:'-я'}</option>{/for}
						</select>
					</div>
				</td>
				<td>&nbsp;<br><button class="button button--primary">Добавить</button></td>
				<td></td>
			</tr>

		</table>
		<input type="hidden" name="make_title" value="{$sMakeTitle}"/>

	</form>
	<h2 class="page-sub-header">Производитель: {$sMakeTitle}</h2>
		<table class="table">
		<tr>
			<th>Название</th>
			<th>Тип</th>
			<th>Группа</th>
			<th>Цена (руб.)</th>
			<th></th>
		</tr>
		{foreach $aFabricMakeCollection as $oFC}
			<tr>
				<td><a href="{Config::Get('url_adm')}fabric/{$oFC->getGroupId()}/collection/{$oFC->getCollectionTitle()}/{$sMakeTitle}/">{$oFC->getCollectionTitle()}</a></td>
				<td><select class="type" data-collection_title="{$oFC->getCollectionTitle()}">
						<option value="---">---</option>
						{foreach $aFabriType as $oFT}
							<option value="{$oFT->getTypeTitle()}" {if $oFT->getTypeTitle() == $oFC->getTypeTitle()} selected=""{/if}>{$oFT->getTypeTitle()}</option>
						{/foreach}
					</select>
				</td>
				<td><select style="width: 100px;" class="group" id="" data-sMakeTitle="{$sMakeTitle}" data-sCollectionTitle="{$oFC->getCollectionTitle()}" data-iGroupIdOld="{$oFC->getGroupId()}">{for $i = 0 ; $i < 16; $i++}
							<option value="{$i}"{if $i == $oFC->getGroupId()} selected="" {/if}>{($i == 0) ? 'Спец.' : $i|cat:'-я'}</option>{/for}</select>
				</td>
				<td><input value="{$oFC->getPrice()}" style="width: 100px;" type="text" class="fabric-price" data-sMakeTitle="{$sMakeTitle}" data-sCollectionTitle="{$oFC->getCollectionTitle()}"></td>
				<td><a class="icon-ls-remove" href="/admin/fabric/{$oFC->getGroupId()}/collection/{$oFC->getCollectionTitle()}/remove/" onclick="return confirm('Вы действительно хотите удалить коллекцию {$oFC->getCollectionTitle()}');"></a></td>
			</tr>
		{/foreach}
	</table>
	<script type="text/javascript">
		$(function(){
			$('select.group').change(function(){
				var  $this = $(this);
				var oData = $(this).data();
				oData.igroupidnew = $(this).val();
				ls.ajax.load('ADMIN_URLfabric/ajax/change_group/', oData, function(){
					$this.data('igroupidold', oData.igroupidnew);
					ls.msg.notice('Успешно');
				});
			});
			$('select.type').change(function(){
				var  $this = $(this);
				var oData = $(this).data();
				oData.type_title = $(this).val();
				ls.ajax.load('ADMIN_URLfabric/ajax/update_type_title/', oData, function(){
					ls.msg.notice('Успешно');
				});
			});
			$('.fabric-price').change(function(){
				var  $this = $(this);
				var oData = $(this).data();
				oData.price = $(this).val();
				ls.ajax.load('ADMIN_URLfabric/ajax/update_price/', oData, function(){
					ls.msg.notice('Успешно');
				});
			});
		});
	</script>
{/block}
