{$sGroupTitle = ''}
{if $oCategory}
    {foreach $oCategory->getParams() as $oChar}
        {if $sGroupTitle != $oChar->getGroupTitle()}
            {if $sGroupTitle}</div>{/if}
            {$sGroupTitle = $oChar->getGroupTitle()}
            <h2>{$sGroupTitle}</h2>
            <div class="dflex">
        {/if}
        {*{$oChar|prex}*}
        {if $oChar->getType() == 0}
            {component field template='text'
            name        = 'product[char]['|cat:{$oChar->getId()}|cat:']'
            label       = "{$oChar->getTitle()} {($oChar->getUnit()) ? {$oChar->getUnit()} : ''}"
            value       = $oProduct->getCharValueById($oChar->getId())}
        {elseif $oChar->getType() == 3}
            {$mCharValue=($oProduct) ? $oProduct->getCharValueById($oChar->getId()): ''}
            {*{$sUnit = $oChar->getUnit() ? '(' : ''}*}
            {include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"
            sName        = 'product[char]['|cat:{$oChar->getId()}|cat:']'
            sLabel       = "{$oChar->getTitle()} {($oChar->getUnit()) ? {$oChar->getUnit()} : ''}"
            sValue       = $mCharValue|escape}
        {elseif $oChar->getType() == 1}
            {$mCharValue=($oProduct) ? $oProduct->getCharValueById($oChar->getId()): ''}
            {$mCharValue=$mCharValue|translit}
            {*{$mCharValue|pr}*}
            {include file="{$aTemplatePathPlugin.admin}components/field/field.select.tpl"
            sName        = 'product[char]['|cat:{$oChar->getId()}|cat:']'
            sLabel       = "{$oChar->getTitle()} {($oChar->getUnit()) ? {$oChar->getUnit()} : ''}"
            aItems       = $oChar->getSelectValues()
            sClasses     = 'select'
            sSelectedValue= $mCharValue}
        {elseif $oChar->getType() == 2}
            {$mCharValue=($oProduct) ? $oProduct->getCharValueById($oChar->getId()): ''}
            <div class="field columns columns3">
                <label class="field-label" for="">{$oChar->getTitle()}</label>
                {*{$mCharValue|pr}*}
                {foreach $oChar->getValsArray() as $aV}
                    {include file="{$aTemplatePathPlugin.admin}components/field/field.checkbox.tpl"
                    sName        = 'product[char]['|cat:{$oChar->getId()}|cat:'][]'
                    sLabel       = $aV.text
                    sValue       = $aV.value
                    bChecked     = {($oProduct && is_array($mCharValue) && in_array($aV.value, $mCharValue)) ? true : false}}
                    {*<input type="checkbox" class="field-input" name="product[char][{$oChar->getId()}}" value="{$aV.value}" id="char{$oChar->getId()}_{$aV.value}"/>*}
                    {*<label for="char{$oChar->getId()}_{$aV.value}" class="field-label">{$aV.text}</label>*}
                {/foreach}
            </div>
        {/if}
    {/foreach}
    </div>
{/if}
