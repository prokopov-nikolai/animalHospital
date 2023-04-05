{if $aImage|count}
    {foreach $aImage as $aI}
        <div class="img dflex fle">
            <input type="checkbox" class="checkbox" value="{$aI.src}" checked />
            <img src="{$aI.src}" alt="" width="200">
            <div class="size">
                {$aI.size[3]}
            </div>
        </div>
    {/foreach}
{/if}
<button class="ls-button--primary ls-button" id="load-images">Скачать</button>