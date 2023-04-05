<form action="" method="post" class="w600" id="review-edit" enctype="multipart/form-data">
    <div class="ls-field  ls-clearfix  ">
        <label class="ls-field-label">Товар</label>
        <div class="ls-field-holder">
            <p><a href="{$review->getProduct()->getUrlFull()}" target="_blank">{$review->getProductTitleFull()}</a></p>
        </div>
        {component field template='text'
        label   = 'Айди товара'
        name    = 'review[product_id]'
        value   = $review->getProductId()}
    </div>
    <div class="cl h20"></div>
    <div class="ls-field  ls-clearfix  ">
        <label class="ls-field-label">Дизайн</label>
        <div class="ls-field-holder">
            {$designTitle = $review->getDesignTitleFull()}
            <p>{if $designTitle}<a href="{$review->getDesign()->getUrlFull()}" target="_blank">{$designTitle}</a>{else}-{/if}</p>
        </div>
        {component field template='text'
        label   = 'Айди дизайна'
        name    = 'review[design_id]'
        value   = $review->getDesignId()}
    </div>
    <div class="cl h20"></div>
    {component field template='text'
    label   = 'ФИО'
    name    = 'review[fio]'
    value   = $review->getFio()}

    {component field template='text'
    label   = "Айди заказа <a href=\"{$ADMIN_URL}order/{$review->getOrderId()}/\">Заказа №{$review->getOrderId()}</a>"
    name    = 'review[order_id]'
    value   = $review->getOrderId()}

    {component field template='text'
    label   = 'Оценка'
    name    = 'review[rating]'
    value   = $review->getRating()}

    {component field template='textarea'
    label   = 'Комментарий'
    name    = 'review[comment]'
    rows    = 10
    value   = $review->getComment()}

    {component field template='checkbox'
    label   = 'Опубликован'
    name    = 'review[moderate]'
    checked = $review->getModerate()}

    <div class="cl h20"></div>

    {component field template='date'
    label   = 'Дата добавления'
    name    = 'review[date_add]'
    value   = $review->getDateAdd()}

    <div class="cl h20"></div>


    <input type="file" name="photos[]" multiple>

    <div class="photos dflex">
        {foreach $review->getPhotos() as $photo}
            <div class="photo" data-id="{$photo->getId()}">
                <img src="{$photo->getFileWebPath('105x')}" alt="">
                <div class="remove"></div>
            </div>
        {/foreach}
    </div>

    {component button text='Обновить' mods='primary'}
</form>


{capture name="scripts"}
    <script>
      const formReviewEdit = $('#review-edit'),
        photos = formReviewEdit.find('.photo'),
        removeButton = photos.find('.remove');
      removeButton.on('click', function() {
        let photo =  $(this).parents('.photo'),
          mediaId = photo.data('id');
        ls.ajax.load(ADMIN_URL+'media/'+mediaId+'/delete/', {}, function(){
          photo.remove();
        })
      });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}