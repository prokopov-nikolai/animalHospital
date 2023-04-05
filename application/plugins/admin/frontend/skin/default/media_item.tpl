<a href="{$ADMIN_URL}media/{$oMedia->getId()}" class="media" data-id="{$oMedia->getId()}">
    <img src="{$oMedia->getFileWebPath('100x100crop')}" alt="">
            <span class="info">
                {$oMedia->getWidth()}x{$oMedia->getHeight()}px<br>
                {$iS = ($oMedia->getFileSize()/1024)}
                {if $iS < 1024}
                {$iS|number_format:0:',':' '}Kb
                {else}
                {($iS/1024)|number_format:1:',':' '}Mb
                {/if}<br>
                {$oMedia->getTargetType()}<br>
                target_id = {$oMedia->getTargetId()}<br>
            </span>
    <span class="ls-icon-remove"></span>
</a>