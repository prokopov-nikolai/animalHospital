<form action="" method="post" id="form-category-filter">
	{* Заголовок *}
	{include file='components/field/field.text.tpl'
	sName        = 'filter[title]'
	sLabel       = 'Заголовок (h1)'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getTitle() : ''}|escape}

	{* Урл категории *}
	{include file='components/field/field.text.tpl'
	sName        = 'filter[url]'
	sLabel       = 'Урл категории'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getUrl() : ''}}
	{*bIsDisabled  = true*}

	{* seo_title *}
	{include file='components/field/field.text.tpl'
	sName        = 'filter[seo_title]'
	sLabel       = 'seo_title'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getSeoTitle() : ''}}

	{* seo_keywords *}
	{include file='components/field/field.text.tpl'
	sName        = 'filter[seo_keywords]'
	sLabel       = 'seo_keywords'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getSeoKeywords() : ''}}

	{* seo_description *}
	{include file='components/field/field.text.tpl'
	sName        = 'filter[seo_description]'
	sLabel       = 'seo_description'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getSeoDescription() : ''}}

	{* text *}
	{include file='components/field/field.textarea.tpl'
	sName        = 'filter[text_top]'
	sLabel       = 'text_top'
	iRows        = 10
	sInputClasses = 'ace_redactor'
	sInputAttributes='style="display:none;" data-redactor-id="redactor"'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getTextTop() : ''}}
	<div id="redactor" style="min-height:200px;"></div>
	<div class="cl" style="height: 30px;"></div>

	{* text *}
	{include file='components/field/field.textarea.tpl'
	sName        = 'filter[text]'
	sLabel       = 'text'
	iRows        = 10
	sInputClasses = 'ace_redactor'
	sInputAttributes='style="display:none;" data-redactor-id="redactor1"'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getText() : ''}}
	<div id="redactor1" style="min-height:300px;"></div>
	<div class="cl" style="height: 30px;"></div>

	{*<div id="image_url"></div>*}
	{*<input type="file" id="image_file" style="display: none;"/>*}
	{*<button id="upload_image_url">Загрузить картинку</button>*}
	{if !$oCategoryFilter}
		<p style="color:#D60000;">Изображение можно будет добавлять после добавления</p>
	{else}
		<label for="" style="margin: 0 0 -20px;">Загрузите изображение</label>
		{include file="{$aTemplatePathPlugin.admin}upload_media.tpl" bReload=false sTargetType='media' iTargetId={$oCategoryFilter->getId()}}
		<div id="media_list">
			{foreach $aMedia as $oMedia}
				{include file="{$aTemplatePathPlugin.admin}media_item.tpl"}
			{/foreach}
			<a href="{Config::Get('url_adm')}media/">Посмотреть все изображения</a>
		</div>
	{/if}
	{include file="{$aTemplatePathPlugin.admin}modal.media.tpl"}
	{literal}
		<script>
			$(function(){
				$('#media_modal').modal();
				bindMedia();
			});
			window.bindMedia = function(){
				$('.media').unbind('click').bind('click', function(){
					var mediaId = $(this).data('id');
					ls.ajax.load('{Config::Get('url_adm')}media/'+mediaId,{}, function(answ){
						$('#media_modal .modal-content').html(answ.sHtml);
						$('#media_modal button').bind('click', function(){
							if ($(this).attr('id') == 'generate_preview') {
								if ($('#image_format').val() == '') {
									alert('Введите формат изображения');
								} else {
									ls.ajax.load('{Config::Get('url_adm')}media/' + mediaId + '/create', {format: $('#image_format').val()}, function (answ) {
										$('#image_format_link').val(answ.sFilePath);
										$('#media_modal .img').html('<img src="' + answ.sFilePath + '">');
									});
								}
							}
						});
						$('#media_modal').modal('show');
					});
					return false;
				});
				$('.media .ls-icon-remove').unbind('click').bind('click', function(e){
					e.preventDefault();
					e.stopPropagation();
					var oM = $(this).parents('.media');
					if(confirm('Вы действительно хотите удалить изображение?')){
						ls.ajax.load('{Config::Get('url_adm')}media/'+oM.data('id')+'/delete/', {}, function(){
							oM.remove();
						});
					}
					return false;
				});
			}
		</script>
	{/literal}
	{include file='components/field/field.textarea.tpl'
	sName        = 'filter[links]'
	sLabel       = 'Links'
	iRows        = 10
	sInputClasses = 'ace_redactor'
	sInputAttributes='style="display:none;" data-redactor-id="redactor2"'
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getLinks() : ''}}
	<div id="redactor2" style="min-height:200px;"></div>
	<div class="cl" style="height: 30px;"></div>


	{* join *}
	{include file='components/field/field.textarea.tpl'
	sName        = 'filter[join]'
	sLabel       = '#join'
	iRows        = 5
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getJoin() : ''}|escape}

	{* where *}
	{include file='components/field/field.textarea.tpl'
	sName        = 'filter[where]'
	sLabel       = '#where'
	iRows        = 5
	sValue       = {($oCategoryFilter) ? $oCategoryFilter->getWhere() : ''}|escape}

	{if $oCategoryFilter}
		{$sButtonText = 'Редактировать'}{else}{$sButtonText = 'Добавить'}{/if}
	{include file='components/button/button.tpl'
		sId        ='submit-'|cat:$bAction|cat:'-category-filter'
		sClasses   ='btn btn-primary'
		sText      =$sButtonText}
</form>

<script>
	$(document).bind('keydown', 'ctrl+s', function(e) {
		if(e.ctrlKey && (e.which == 83)) {
			e.preventDefault();
			$('#form-category-filter').submit();
			return false;
		}
	});
</script>