{if $oCategory}
{foreach $oCategory->getOptions() as $oOption}
    <span class="h4">{$oOption->getTitle()}</span>
    <span class="ls-button option-check-all" data-id="{$oOption->getId()}">Выбрать все</span>
    <div class="option-block option{$oOption->getId()}" id="option-values">
        {foreach $oOption->getValues() as $oOptionValue}
                {$bChecked = false}
                {foreach $oProduct->getOptionvalues() as $oOV}
                    {if $oOV->getId() == $oOptionValue->getId()}
                        {$bChecked = true}
                    {/if}
                {/foreach}
            <div class="option-value dflex flex-align-items-center" data-id="{$oOptionValue->getId()}">
                <div class="img">
                    {if $oImage = $oOptionValue->getImage()}
                        <img src="{$oImage->getFileWebPath('50x50crop')}" alt="">
                    {/if}
                </div>
                <div class="checkbox">
                    <input id="op-val-{$oOptionValue->getId()}" type="checkbox" name="product[option_values][]" value="{$oOptionValue->getId()}"{if $bChecked} checked{/if}>
                </div>
                <label for="op-val-{$oOptionValue->getId()}" class="title">{$oOptionValue->getTitle()} ({$oOptionValue->getMargin()})"</label>
            </div>

        {/foreach}
    </div>
{/foreach}
<div class="cl"></div>
{/if}