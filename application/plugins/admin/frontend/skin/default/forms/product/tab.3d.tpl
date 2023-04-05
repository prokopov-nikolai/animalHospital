<label for="">Выберите изображения для загрузки</label>
<input type="file" name="photo-3d[]" multiple>
<small>Фото на этой вкладке будут отсортированы по названию по возрастанию. Файлы следуюет нумеровать от 1 до 60</small>
<div class="dflex sortable">
    {foreach $oProduct->getPhotos3d() as $oMedia}
        <div class="photo-3d {if $oMedia->getMain()}main{/if}" data-id="{$oMedia->getId()}">
            <img src="{$oMedia->getFileWebPath('300x')}" alt=""><br>
            {$oMedia->getAlt()}
            <div class="remove"></div>
        </div>
    {/foreach}
</div>
<div class="cl" style="height: 50px;"></div>

{capture name='script'}
    <script>
        $(function(){
            $('#product-3d .sortable').sortable({
                stop: function(){
                    var aPhoto = [];
                    $('#product-3d .photo-3d').each(function() {
                        aPhoto.push($(this).data('id'));
                    });
                    ls.ajax.load(ADMIN_URL+'product/ajax/media/sort/', {
                        sort: aPhoto,
                    });
                }
            });
            $('.photo-3d .remove').on('click', function() {
                if (confirm('Удалить? Уверены?')) {
                    var oPhoto = $(this).parents('.photo-3d');
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
