<div class="item dflex flex-align-items-center" data-id="{$oItem->getId()}">
    <img src="{$oItem->getMainPhotoUrl('100x')}" alt="">
    <input type="text" name="group_name" value="{$oItem->getGroupName()}" placeholder="Название группы">
    <input type="text" name="item_name" value="{$oItem->getItemName()}" placeholder="Название товара">
    <div class="ls-icon-remove"></div>
</div>