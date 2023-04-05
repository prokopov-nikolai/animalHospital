{$iLevel = 1}
{foreach $aRight as $oRight}
    <div class="block level-{$iLevel}" data-key="{$oRight->getKey()}">
        {component field template='checkbox'
        label   = $oRight->getName()
        value   = $oRight->getId()
        checked = (array_key_exists($oRight->getKey(), $aUserRight)) ? true : false}
        {$aRC = $oRight->getChildren()}
        {if $aRC|count > 0}
            {include file="{$aTemplatePathPlugin.admin}right/block.tpl" aRight=$aRC iLevel=$iLevel+1}
        {/if}
    </div>
{/foreach}