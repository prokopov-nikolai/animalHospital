<div class="option-value" data-id="{$oOptionValue->getId()}">
    <div class="dflex">
        <div class="img">
            {if $oImage = $oOptionValue->getImage()}
                <img src="{$oImage->getFileWebPath('50x50crop')}" alt="">
            {/if}
        </div>
        <input type="text" name="title" placeholder="Название" value="{$oOptionValue->getTitle()}">
        <input type="text" name="margin" placeholder="Наценка" value="{$oOptionValue->getMargin()}">
        <div class="ls-icon-remove"></div>
    </div>
</div>