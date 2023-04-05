<label for="">Выберите изображения для загрузки</label>
<input type="file" name="photo[]" multiple>
<small class="note">Двойной клик на фото устанавливает главное фото</small>
<div class="dflex sortable">
    {$aMediaId = []}
    {foreach $oDesign->getPhotos() as $oMedia}
        {$aMediaId[] = $oMedia->getId()}
        <div class="photo {if $oMedia->getMain()}main{/if}" data-id="{$oMedia->getId()}">
            <img src="{$oMedia->getFileWebPath('300x')}" alt="">
            {component field template='select'
            classes         = 'photo-alt'
            items           = Config::Get('images_alt')
            selectedValue   = $oMedia->getAlt()}
            <div class="ls-field">
                <label for="" class="ls-label">Ширина:</label>
                {$oMedia->getWidth()|number_format:0:',':' '} px
            </div>
            <div class="ls-field">
                <label for="" class="ls-label">Размер:</label>
                {($oMedia->getFileSize()/1000)|ceil|number_format:0:',':' '} kb
            </div>
            <div class="remove"></div>
        </div>
    {/foreach}
</div>
<div class="cl h20"></div>
Удалить все копии изображений &nbsp;{component button text='УДАЛИТЬ' url="{$ADMIN_URL}media/copy/delete/?aId={','|implode:$aMediaId}" attributes=['onclick' => "return confirm('Уверены, что хотите удалить все копии изображений?')"]}

{capture name='script'}
    <script>
        $(function(){
            $('.photo select').change(function() {
                var sAlt = $(this).val();
                var iId = $(this).parents('.photo').data('id');
                ls.ajax.load(ADMIN_URL+'product/ajax/media/update/', {
                    alt: sAlt,
                    id: iId
                });
            });
            $('.photo').on('dblclick', function(){
                var iId = $(this).data('id');
                ls.ajax.load(ADMIN_URL+'product/ajax/media/update/', {
                    main: 1,
                    id: iId,
                    design_id: iDesignId
                });
                $(this).parent().find('.main').removeClass('main');
                $(this).addClass('main');
            });
            $('.sortable').sortable({
                stop: function(){
                    var aPhoto = [];
                    $('.photo').each(function() {
                        aPhoto.push($(this).data('id'));
                    });
                    ls.ajax.load(ADMIN_URL+'product/ajax/media/sort/', {
                        sort: aPhoto,
                    });
                }
            });
            $('.photo .remove').on('click', function() {
                if (confirm('Удалить? Уверены?')) {
                    var oPhoto = $(this).parents('.photo');
                    var iMediaId = oPhoto.data('id');
                    ls.ajax.load(ADMIN_URL+'product/ajax/media/remove/', {
                        id: iMediaId,
                    }, function(){ oPhoto.fadeOut() });
                }
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}