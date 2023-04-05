{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'pets'}
	{$sMenuSelectSub = 'pets_add'}
{/block}

{block name='layout_content'}
	{* TODO: Языковик *}
	<h1>Питомцы</h1>
	<div class="dflex blocks">
		<div class="block">
			<div class="title">Поиск</div>
			Кличка, ФИО, Телефон &nbsp;&nbsp; <input type="text" class="pets autocomplete-pro" value="{$smarty.get.search|escape}">
			<small class="note">Начните вбивать данные. Затем кликните по нужному элементу, чтобы перейти в <b>редактирование</b></small>
			<div class="cl" style="height: 20px;"></div>
		</div>
		<div class="block">
			{component button text="Добавить" url="{$ADMIN_URL}pets/add/"}
		</div>
	</div>
	{include file="{$aTemplatePathPlugin.admin}pets/list.tpl"}
	{component 'pagination' total=+$paging.iCountPage current=+$paging.iCurrentPage url="{$paging.sBaseUrl}/page__page__/{$paging.sGetParams}" showPager="true"}
{/block}

{block name="scripts"}
	{capture name="script"}
		<script>
			$('.pets.autocomplete-pro').autocompletePro({
				name: 'pets',
				name_search: 'search',
				url: ADMIN_URL+'pets/ajax/search/',
				url_search: ADMIN_URL+'pets/',
				render : function(obj){
					var item =
							'<div class="row" data-id="'+obj.id+'">' +
							'<span>' + obj.nickname + ' // ' + obj.species + ' // ' + obj.user_fio + ' // ' + obj.user_phone + '</span>'
					'</div>';
					return item;
				}
			}, function(obj){
				window.location.href = ADMIN_URL+'pets/'+obj.id+'/';
			});
		</script>
	{/capture}

	{LS::Append('scripts', $smarty.capture.script)}
{/block}