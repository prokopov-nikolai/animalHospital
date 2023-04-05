{foreach $aOption as $oOption}
    {$bChecked = false}
    {foreach $oCategoryFilter->getOptions() as $oO}
        {if $oO->getId() == $oOption->getId()}
            {$bChecked = true}
        {/if}
    {/foreach}
    {component field template='checkbox'
    name        = 'category_filter[option][]'
    label       = $oOption->getTitle()
    value       = $oOption->getId()
    checked     = $bChecked}
{/foreach}
<div class="cl"></div>