<div class="dflex">
    <div class="block w1">
        <table class="table products services rtable">
            <tr>
                <th width="20" rowspan="2">#</th>
                <th class="title" rowspan="2">Наименование</th>
                <th {if LS::HasRight('38_order_margin_view')} colspan="2"{/if}>ТОВАР</th>
                <th colspan="8" style="border-bottom:#333 solid 1px;">Услуги</th>
                <th rowspan="2">Кол-во</th>
                <th rowspan="2" class="{if !LS::HasRight('38_order_margin_view')} hide{/if}">Агентские</th>
            </tr>
            <tr>
                <th>Цена<br>клиента</th>
                <th class="{if !LS::HasRight('38_order_margin_view')} hide{/if}">Цена<br>фабрики</th>
                <th style="border-left:#333 solid 1px;">Доставка<br>клиента</th>
                <th>Доставка<br><nobr>Эксп-в</nobr></th>
                <th style="border-left:#333 solid 1px;">Доставка<br>МКАД+ТТК<br>клиента</th>
                <th>Доставка<br>МКАД+ТТК<br><nobr>Эксп-в</nobr></th>
                <th style="border-left:#333 solid 1px;">Занос<br>клиента</th>
                <th>Занос<br><nobr>Эксп-в</nobr></th>
                <th style="border-left:#333 solid 1px;">Сборка<br>клиента</th>
                <th style="border-right:#333 solid 1px;">Сборка<br><nobr>Эксп-в</nobr></th>
            </tr>
            {foreach from=$oOrder->getProducts() item='oOrderProduct' name="products"}
                {$bIsDisabled = false}
                {* Дисейблим заказа если доставлен *}
                {if $oOrder->getStatus() == 'delivered'}{$bIsDisabled = true}{/if}
                <tr class="order-product" data-product-design-id="{$oOrderProduct->getProductDesignId()}">
                    <td class="number">{$smarty.foreach.products.index+1}</td>
                    <td class="title">
                        {$oOrderProduct->getTitleFull()}
                    </td>
                    <td class="data nobr no-border-right price">( <span>{$oOrderProduct->getPrice(true)}</span></td>
                    <td class="data nobr no-border-left price-make{if !LS::HasRight('38_order_margin_view')} hide{/if}">- &nbsp;<span>{$oOrderProduct->getPriceMake(true)}</span></td>
                    <td class="data nobr no-border-right">
                        + &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceDelivery()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_delivery]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_delivery']
                            value           = $oOrderProduct->getPriceDelivery()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-left">
                        - &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceDeliveryMake()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_delivery_make]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_delivery_make']
                            value           = $oOrderProduct->getPriceDeliveryMake()}
                        {/if}
                    </td class="data nobr">
                    <td class="data nobr no-border-right">
                        + &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceDeliveryDop()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_delivery_dop]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_delivery_dop']
                            value           = $oOrderProduct->getPriceDeliveryDop()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-left">
                        - &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceDeliveryDopMake()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_delivery_dop_make]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_delivery_dop_make']
                            value           = $oOrderProduct->getPriceDeliveryDopMake()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-right">
                        + &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceZanosa()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_zanosa]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_zanosa']
                            value           = $oOrderProduct->getPriceZanosa()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-left">
                        - &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceZanosaMake()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_zanosa_make]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_zanosa_make']
                            value           = $oOrderProduct->getPriceZanosaMake()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-right">
                        + &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceSborki()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_sborki]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_sborki']
                            value           = $oOrderProduct->getPriceSborki()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-left">
                        - &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceSborkiMake()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_sborki_make]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price_sborki_make']
                            value           = $oOrderProduct->getPriceSborkiMake()}
                        {/if}
                        ) &nbsp;
                    </td>
                    <td class="data nobr">
                        x &nbsp;{$oOrderProduct->getCount()}
                    </td>
                    <td class="data nobr agent-commission{if !LS::HasRight('38_order_margin_view')} hide{/if}">
                        = &nbsp;<span>{$oOrderProduct->getAgentCommission()|default:'-'}</span>
                    </td>
                </tr>
            {/foreach}
        </table>
    </div>
</div>