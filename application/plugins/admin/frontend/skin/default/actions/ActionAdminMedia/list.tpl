{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'media'}
{/block}
{block name='layout_page_title'}
    Изображения
{/block}

{block name='layout_content'}
    {include file="{$aTemplatePathPlugin.admin}upload_media.tpl"}

    <div id="media_list">
    {foreach $aMedia as $oMedia}
        {include file="{$aTemplatePathPlugin.admin}media_item.tpl"}
    {/foreach}
    </div>
    {component 'pagination' total=+$paging.iCountPage current=+$paging.iCurrentPage url="{$paging.sBaseUrl}/page__page__/{$paging.sGetParams}" showPager="true"}
    {component modal
        id='media_modal'
        title='Изображение'
        content='_'}
    {literal}
        <script>
            $(function(){
                $('.media').click(function(){
                    var mediaId = $(this).data('id');
                    ls.ajax.load(ADMIN_URL+'media/'+mediaId,{}, function(answ){
                       $('#media_modal .ls-modal-body').html(answ.sHtml);
                        $('#media_modal button').on('click', function(){
                            if ($(this).attr('id') == 'generate_preview') {
                                if ($('#image_format').val() == '') {
                                    alert('Введите формат изображения');
                                } else {
                                    ls.ajax.load(ADMIN_URL + 'media/' + mediaId + '/create', {format: $('#image_format').val()}, function (answ) {
                                        $('#image_format_link').val(answ.sFilePath);
                                        $('#media_modal .img').html('<img src="' + answ.sFilePath + '">');
                                    });
                                }
                            }
                        });
                        ModalShow($('#media_modal'));
                    });
                   return false;
                });
                $('.media .ls-icon-remove').click(function(e){
                    e.preventDefault();
                    e.stopPropagation();
                    var oM = $(this).parents('.media');
                    if(confirm('Вы действительно хотите удалить изображение?')){
                        ls.ajax.load(ADMIN_URL+'media/'+oM.data('id')+'/delete/', {}, function(){
                            oM.remove();
                        });
                    }
                    return false;
                });
                $('#media_modal .ls-modal-close').on('click', function(){
                    ModalHide(true, $('#media_modal'));
                });
            });
        </script>
    {/literal}
{/block}