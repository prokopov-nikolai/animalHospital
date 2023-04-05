{foreach $aChar as $oChar}
    {$bChecked = false}
    {foreach $oCategory->getChars() as $oCh}
        {if $oCh->getId() == $oChar->getId()}
            {$bChecked = true}
        {/if}
    {/foreach}
    {component field template='checkbox'
    name        = 'category[char][]'
    label       = $oChar->getTitle()
    value       = $oChar->getId()
    checked     = $bChecked}
{/foreach}
<div class="cl"></div>
