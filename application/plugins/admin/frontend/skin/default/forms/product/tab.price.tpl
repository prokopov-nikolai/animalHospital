{if !$oMake}
    <p class="ls-alert ls-alert--error">Необходимо выбрать производителя</p>
{else}
<table class="table prices">
    <tr>
        <td></td>
        <td></td>
        {foreach $oMake->getGroupsArray() as $iGroupNum => $sGroup}
                <td class="prices">{$sGroup}</td>
        {/foreach}
    </tr>
    <tr>
        <th style="border-bottom-color: transparent;">
            Цена
        </th>
        <th style="border-bottom-color: transparent;">руб.</th>
        {foreach $oMake->getGroupsArray() as $iGroupNum => $aGroup}
                <td rowspan="2"><input type="text" class="prices price{$iGroupNum}" name="prices[{$iGroupNum}]" value="{$oProduct->getPriceMakeByMakeGroup($iGroupNum)}" autocomplete="off"></td>
        {/foreach}
    </tr>
    <tr>
        <th colspan="1" style="border-top-color: transparent;">
            <button class="ls-button" id="paste-from-buffer">Из буфера</button>
        </th>
        <th colspan="1" style="border-top-color: transparent;">
            <button class="ls-button" id="paste-price-dihall">DiHall</button>
        </th>
    </tr>
    <tr>
        <th rowspan="2">Наценка</th>
        <th style="width: 65px;">
            <input type="text" class="margin-percent-common" style="width: 32px; padding: 5px!important;"/>%
        </th>
    {foreach $oMake->getGroupsArray() as $iGroupNum => $aGroup}
        <td>
            <input type="text" data-group="{$iGroupNum}" class="margin-percent margin-percent{$iGroupNum}" value="{if $oProduct->getPriceMakeByMakeGroup($iGroupNum) > 0}{($oProduct->getMarginByMakeGroup($iGroupNum)/$oProduct->getPriceMakeByMakeGroup($iGroupNum)*100)|number_format:2:'.':''}{else}0{/if}" autocomplete="off" >
        </td>
    {/foreach}
    </tr>
    <tr>
        <th>руб.</th>
    {foreach $oMake->getGroupsArray() as $iGroupNum => $aGroup}
        <td><input type="text" data-group="{$iGroupNum}" class="margin margin{$iGroupNum}" name="margin[{$iGroupNum}]" value="{$oProduct->getMarginByMakeGroup($iGroupNum)|default:0}" autocomplete="off"></td>
    {/foreach}
    </tr>
    <tr>
        <th style="border-bottom-color: transparent;">Скидка</th>
        <th style="border-bottom-color: transparent;"><input type="text" class="discount-percent-common" style="width: 32px; padding: 5px!important;"/>%</th>
        {foreach $oMake->getGroupsArray() as $iGroupNum => $aGroup}
            <td rowspan="2">
                <input type="text" class="discount-percent discount{$iGroupNum}" name="discount[{$iGroupNum}]" value="{($oProduct && $oProduct->getDiscountDateByMakeGroup($iGroupNum)) ? $oProduct->getDiscountDateByMakeGroup($iGroupNum) : '0'}" />
            </td>
        {/foreach}
    </tr>
    <tr>
        <th style="border-top-color: transparent;">
            {component field template='date'
            label       = 'Начало'
            classes     = 'date'
            name        = 'product[discount_date_from]'
            inputAttributes  = ['autocomplete' => 'off']
            value       = $oProduct->getDiscountDateFrom('d.m.Y')}
        </th>
        <th style="border-top-color: transparent;">
            {component field template='date'
            label       = 'Окончание'
            classes     = 'date'
            name        = 'product[discount_date_to]'
            inputAttributes  = ['autocomplete' => 'off']
            value       = $oProduct->getDiscountDateTo('d.m.Y')}
        </th>
    </tr>
    <tr>
        <th>Итого</th>
        <th>руб.</th>
        {$aItog = []}
        {foreach $oMake->getGroupsArray() as $iGroupNum => $aGroup}
            <td>
                {if $oProduct->getPriceMakeByMakeGroup($iGroupNum) != '' && $oProduct->getDiscountByMakeGroup($iGroupNum) != ''}
                    {$iItog = ($oProduct->getPriceMakeByMakeGroup($iGroupNum)+$oProduct->getMarginByMakeGroup($iGroupNum))*(1 - $oProduct->getDiscountByMakeGroup($iGroupNum)/100)}
                {else}
                    {$iItog = 0}
                {/if}
                {$aItog[$iGroupNum] = $iItog}
                <input type="text" data-group="{$iGroupNum}" class="{if $iItog < $oProduct->getPriceMakeByMakeGroup($iGroupNum)}red {/if}summa summa{$iGroupNum}" name="summa[]" value="{if $oProduct->getPriceMakeByMakeGroup($iGroupNum) > 0}{(int)$iItog}{/if}" />
            </td>
        {/foreach}
    </tr>
    <tr>
        <th>Марж-ть</th>
        <th>руб.</th>
        {foreach $oMake->getGroupsArray() as $iGroupNum => $aGroup}
            <td>
                {if $aItog[$iGroupNum]}
                    {GetPrice($aItog[$iGroupNum] - $oProduct->getPriceMakeByMakeGroup($iGroupNum), 1)}
                {/if}
            </td>
        {/foreach}
    </tr>
</table>
    <div class="cl" style="height: 20px;"></div>

{* Наценка *}
{*{include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"*}
{*sName        = 'product[margin]'*}
{*sLabel       = 'Наценка'*}
{*sValue       = {($oProduct && $oProduct->getMargin()) ? $oProduct->getMargin() : '0.00'}}*}

{* Стоимость доставки *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"
sName        = 'product[price_delivery]'
sLabel       = 'Стоимость доставки для клиента'
sValue       = {($oProduct) ? $oProduct->getPriceDelivery() : '500'}}

{* Стоимость доставки *}
{include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"
sName        = 'product[price_delivery_make]'
sLabel       = 'Стоимость доставки производителя'
sValue       = {($oProduct) ? $oProduct->getPriceDeliveryMake() : '0'}}

{* Ставка Яндекс Маркет *}
{*{include file="{$aTemplatePathPlugin.admin}components/field/field.text.tpl"*}
{*sName        = 'product[bid]'*}
{*sLabel       = 'Ставка Яндекс Маркет'*}
{*sValue       = {($oProduct && $oProduct->getBid()) ? $oProduct->getBid() : '10'}}*}

{*<label for="product[price_min]" class="form-field-label">Минимальная розничная цена:</label><br>*}
{*{($oProduct) ? $oProduct->getPriceMin(true): ''}*}

{* discount *}

{/if}

