{foreach $aChar as $oChar}
    {$bChecked = false}
    {foreach $oCategoryFilter->getParams() as $oCh}
        {if $oCh->getId() == $oChar->getId()}
            {$bChecked = true}
        {/if}
    {/foreach}
    {component field template='checkbox'
    name        = 'category_filter[param][]'
    label       = $oChar->getTitle()
    value       = $oChar->getId()
    checked     = $bChecked}
{/foreach}
<div class="cl"></div>