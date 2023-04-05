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
    <table class="table delivery" style="width: ;">
        <tr>
            <th rowspan="2" class="not-print">Машина</th>
            <th rowspan="2"><div style="display: block; width: 80px;">Заказ</div></th>
            <th rowspan="2"><div style="display: block; width: 120px;">Адрес доставки</div></th>
            <th rowspan="2"><div style="display: block; width: 150px;">Клиент</div></th>
            <th rowspan="2"><div style="display: block; width: 160px;">Товар</div></th>
            <th rowspan="2">Сумма<br>товара</th>
            <th colspan="4" class="ta-c">Услуги</th>
            <th rowspan="2" class="ta-c">Предоплата</th>
            <th rowspan="2"><div style="display: block; width: 160px;">Примечание</div></th>
        </tr>
        <tr>
            <th class="ta-c"><div style="display: block; width: 60px;">Дост-ка</div></th>
            <th class="ta-c"><div style="display: block; width: 60px;">МКАД,<br>ТТК,<br>ЦЕНТР</div></th>
            <th class="ta-c"><div style="display: block; width: 60px;">Занос</div></th>
            <th class="ta-c"><div style="display: block; width: 60px;">Сборка</div></th>
        </tr>
        {foreach $aOrder as $oOrder}
            <tr data-id="{$oOrder->getId()}" class="{$oOrder->getStatus()}">
                <td class="not-print">
                    {component field template='select'
                    name            = 'car_number'
                    selectedValue   = $oOrder->getCarNumber()
                    items           = Config::Get('car_number')
                    classes         = 'w120'
                    inputClasses    = 'ajax-save'
                    inputAttributes  = ['data-field' => 'car_number', 'data-order_id' => {$oOrder->getId()}]}
                </td>
                <td style="width: 150px;">
                    {if $oAgent = $oOrder->getAgent()}{$oAgent->getFio()}{/if}<br>
                    <a href="{$ADMIN_URL}order/{$oOrder->getId()}/">Заказ №{$oOrder->getAgentNumber()}</a><br>
                    <b>{$oOrder->getId()}</b>
                    </div>
                </td>
                <td style="width: 100px;">
                    <a href="https://yandex.ru/maps/?z=16&text={$oOrder->getAddress()|urlencode}"
                       target="_blank">{$oOrder->getAddress()}</a></td>
                <td style="width: 100px;">
                    {$oUser = $oOrder->getUser()}
                    {$oUser->getFio()}<br><span class="nobr">{$oUser->getPhone(true)}</span>
                </td>
                <td style="width: 200px!important;">
                    {foreach $oOrder->getProducts() as $oOrderProduct}
{*                        {$oOrderProduct->getProductTitle()|pr}*}
{*                        {$oOrderProduct->_getData()|prex}*}
                        <div class="product">- <b>{$oOrderProduct->getProductPrefix()} {$oOrderProduct->_getDataOne('product_title')} ({$oOrderProduct->getMakeTitle()})</b></div>
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
                <td style="width: 50px;">
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        {if $oOrderProduct->getRepair()}
                            -
                        {else}
                            <span>{GetPrice($oOrderProduct->getPrice()*$oOrderProduct->getCount(), 1)}</span>
                            {$iSumProduct = $iSumProduct + $oOrderProduct->getPrice()*$oOrderProduct->getCount()}
                        {/if}
                    {/foreach}
                </td>
                <td class="nowrap" style="width: 50px;">
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        {if $oOrderProduct->getRepair()}
                        -
                        {else}
                            + {GetPrice($oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount(),true)}
                            <br>
                            {$iSumDelivery = $iSumDelivery + $oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount()}
                        {/if}
                    {/foreach}
                </td>
                <td class="nowrap" style="width: 50px;">
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        {if $oOrderProduct->getRepair()}
                        -
                        {else}
                            + {GetPrice($oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount(), true)}
                            <br>
                            {$iSumDeliveryMKAD = $iSumDeliveryMKAD + $oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount()}
                        {/if}
                    {/foreach}
                </td>
                <td class="nowrap" style="width: 50px;">
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        {if $oOrderProduct->getRepair()}
                        -
                        {else}
                            + {GetPrice($oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount(), true)}
                            <br>
                            {$iSumZanos = $iSumZanos + $oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount()}
                        {/if}
                    {/foreach}
                </td>
                <td class="nowrap" style="width: 50px;">
                    {foreach $oOrder->getProducts() as $oOrderProduct}
                        {if $oOrderProduct->getRepair()}
                        -
                        {else}
                            + {GetPrice($oOrderProduct->getPriceSborki()*$oOrderProduct->getCount(), true)}
                            <br>
                            {$iSumZanos = $iSumZanos + $oOrderProduct->getPriceSborki()*$oOrderProduct->getCount()}
                        {/if}
                    {/foreach}
                </td>
                <td class="nowrap" style="width: 100px;">
                    {if $oOrderProduct->getRepair()}
                    <b>РЕМОНТ</b>
                    {else}
                        - {$oOrder->getPrepayment(true, false)}<br>
                        {$iItog = 0}
                        {foreach $oOrder->getProducts() as $oOrderProduct}
                            {$iItog = $iItog + $oOrderProduct->getPrice()*$oOrderProduct->getCount()}
                            {$iItog = $iItog + $oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount()}
                            {$iItog = $iItog + $oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount()}
                            {$iItog = $iItog + $oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount()}
                            {$iItog = $iItog + $oOrderProduct->getPriceSborki()*$oOrderProduct->getCount()}
                        {/foreach}
                        {$iItog = $iItog - $oOrder->getPrepayment()}

                        {$iSumItog = $iSumItog + $iItog}

                        <b class="fz12 nobr">Итого остаток:</b><br>
                        <b class="fz16">{GetPrice($iItog, true, true)}</b>
                    {/if}
                </td>
                <td style="width: 200px;">
                    {$oOrder->getFloor()} этаж<br>
                    {GetSelectText($oOrder->getServiceLift(), 'lift')} лифт<br>
                    {$oOrder->getComment()}
                    {if $oOrder->getLastCommentText()}<br><b>({$oOrder->getLastCommentText()})</b>{/if}
                </td>
            </tr>
        {/foreach}
        <tr>
            <th class="not-print"></th>
            <th colspan="4">ИТОГО (заказов {$aOrder|count})</th>
            <th class="fz14 ta-c">{GetPrice($iSumProduct, true, true)}</th>
            <th class="fz14 ta-c">{GetPrice($iSumDelivery, true, true)}</th>
            <th class="fz14 ta-c">{GetPrice($iSumDeliveryMKAD, true, true)}</th>
            <th class="fz14 ta-c" colspan="2">{GetPrice($iSumZanos, true, true)}</th>
            <th class="fz20 ta-c">{GetPrice($iSumItog, true, true)}</th>
            <th></th>
        </tr>
    </table>
    {*{component pagination paging=$aPaging}*}
{/if}