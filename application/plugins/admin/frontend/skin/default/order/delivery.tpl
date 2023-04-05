{if $aOrder|count == 0}
    <div class="cl h20"></div>
    Пусто
    <div class="cl h20"></div>
{else}
    {$iSumProduct}
    {$iSumDelivery}
    {$iSumDeliveryMKAD}
    {$iSumZanos}
    {$iSumItog}
    <table class="table delivery{if !$smarty.get.print} rtable{/if}">
        <tr>
            <th rowspan="2">Адрес доставки</th>
            <th rowspan="2">Заказ</th>
            <th rowspan="2">Клиент</th>
            <th rowspan="2" width="140">Товар</th>
            <th rowspan="2" width="100">Сумма<br>товара</th>
            <th colspan="4" class="ta-c">Услуги</th>
            <th rowspan="2" class="ta-c">Предоплата</th>
            <th rowspan="2">Примечание</th>
            <th rowspan="2">Машина</th>
        </tr>
        <tr>
            <th class="ta-c">Доставка</th>
            <th class="ta-c">МКАД,<br>ТТК,<br>ЦЕНТР</th>
            <th class="ta-c">Занос</th>
            <th class="ta-c">Сборка</th>
        </tr>
        {foreach $aOrder as $oOrder}
            <tr data-id="{$oOrder->getId()}" class="{$oOrder->getStatus()}">
                <td><a href="https://yandex.ru/maps/?z=16&text={$oOrder->getAddress()|urlencode}"
                       target="_blank">{$oOrder->getAddress()}</a></td>
                <td>
                    {$oOrder->getAgent()->getFio()}<br>
                    <a href="{$ADMIN_URL}order/{$oOrder->getId()}/">Заказ №{$oOrder->getAgentNumber()}</a>
                </td>
                <td>
                    {$oUser = $oOrder->getUser()}
                    {$oUser->getFio()}<br><span class="nobr">{$oUser->getPhone(true)}</span></td>
                <td>
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        <div class="nobr product">- {$oOrderProduct->getProductTitleFull()}</div>
                        {$sFabrics = ''}
                        {foreach [1, 2, 3, 4] as $iNum}
                            {if $oOrderProduct->getFabricLength($iNum) > 0}
                                {if $iNum > 1}{$sFabrics = "{$sFabrics} // "}{/if}
                                {$oFabric = $oOrderProduct->getFabric($iNum)}
                                {if $oFabric}{$sFabrics = "{$sFabrics} {$oFabric->getAlt()} ({$oFabric->getSupplier()})"}{/if}
                            {/if}
                        {/foreach}
                        <div class="pl10 fz12">{$sFabrics}</div>
                    {/foreach}
                </td>
                <td>
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        <span class="nobr">{$oOrderProduct->getPrice(true)}</span>
                        <br>
                        {$iSumProduct = $iSumProduct + $oOrderProduct->getPrice()}
                    {/foreach}
                </td>
                <td>
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        + {$oOrderProduct->getPriceDelivery(true)}
                        <br>
                        {$iSumDelivery = $iSumDelivery + $oOrderProduct->getPriceDelivery()}
                    {/foreach}
                </td>
                <td>
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        + {$oOrderProduct->getPriceDeliveryDop(true)}
                        <br>
                        {$iSumDeliveryMKAD = $iSumDeliveryMKAD + $oOrderProduct->getPriceDeliveryDop()}
                    {/foreach}
                </td>
                <td>
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        + {$oOrderProduct->getPriceZanosa()}
                        <br>
                        {$iSumZanos = $iSumZanos + $oOrderProduct->getPriceZanosa()}
                    {/foreach}
                </td>
                <td>
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        + {$oOrderProduct->getPriceSborki()}
                        <br>
                        {$iSumZanos = $iSumZanos + $oOrderProduct->getPriceSborki()}
                    {/foreach}
                </td>
                <td>
                    - {$oOrder->getPrepayment(true, false)}<br>
                    {$iItog = 0}
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        {$iItog = $iItog + $oOrderProduct->getPrice()}
                        {$iItog = $iItog + $oOrderProduct->getPriceDelivery()}
                        {$iItog = $iItog + $oOrderProduct->getPriceDeliveryDop()}
                        {$iItog = $iItog + $oOrderProduct->getPriceZanosa()}
                        {$iItog = $iItog + $oOrderProduct->getPriceSborki()}
                    {/foreach}
                    {$iItog = $iItog - $oOrder->getPrepayment()}

                    {$iSumItog = $iSumItog + $iItog}

                    <b class="fz12 nobr">Итого остаток:</b><br>
                    <b class="fz16">{GetPrice($iItog, true, true)}</b>
                </td>
                <td>
                    {$oOrder->getFloor()} этаж<br>
                    {GetSelectText($oOrder->getServiceLift(), 'lift')} лифт<br>
                    {$oOrder->getComment()}
                </td>
                <td>
                    {component field template='select'
                    name            = 'car_number'
                    selectedValue   = $oOrder->getCarNumber()
                    items           = Config::Get('car_number')
                    classes         = 'w120'
                    inputClasses    = 'ajax-save'
                    inputAttributes  = ['data-field' => 'car_number', 'data-order_id' => {$oOrder->getId()}]}
                </td>
            </tr>
        {/foreach}
        <tr>
            <th colspan="4">ИТОГО</th>
            <th class="fz14 ta-c">{GetPrice($iSumProduct, true, true)}</th>
            <th class="fz14 ta-c">{GetPrice($iSumDelivery, true, true)}</th>
            <th class="fz14 ta-c">{GetPrice($iSumDeliveryMKAD, true, true)}</th>
            <th class="fz14 ta-c" colspan="2">{GetPrice($iSumZanos, true, true)}</th>
            <th class="fz20 ta-c">{GetPrice($iSumItog, true, true)}</th>
            <th></th>
            <th></th>
        </tr>
    </table>
    {*{component pagination paging=$aPaging}*}
{/if}