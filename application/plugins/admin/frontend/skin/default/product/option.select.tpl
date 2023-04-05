{$oUserOptionValue = $aUserOptionValues[$oOption->getId()]}
<div class="option {$oOption->getType()} option-value"
     id="option{$oOption->getId()}"
     data-id="{$oOption->getId()}"
     data-value_id="">
    <div class="_title">{$oOption->getAlias()}</div>
    <div class="_remove ls-icon-remove"></div>
    <select class="option" name="{$oOption->getId()}">
        {foreach $oOption->getValues() as $oOV}
            <option value="{$oOV->getId()}"{if $oUserOptionValue && $oUserOptionValue->getId() == $oOV->getId()} selected{/if}>{$oOV->getTitle()} (+{if $oOV->getMargin() != 0 && $oOV->getMargin() < 100}{(int)$oOV->getMargin()}{else}{GetPrice($oOV->getMargin(), true, true)}{/if})</option>
        {/foreach}
    </select>
</div>