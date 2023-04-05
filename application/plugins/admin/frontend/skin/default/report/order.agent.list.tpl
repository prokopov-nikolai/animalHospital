{if $aOrderProduct|count == 0}Пусто{else}
{$iAmount = 0}
<table class="table report-agent">
    <tr>
        <th rowspan="2">{component field template="checkbox" inputClasses="select-all"}</th>
        <th rowspan="2">Номер<br>заказа</th>
        <th rowspan="2" class="status">Статус</th>
        <th rowspan="2" class="product">Изделие</th>
        <th colspan="2">Товар</th>
        <th colspan="2">Услуги</th>
        <th rowspan="2">Кол-во</th>
        <th rowspan="2">Скидка</th>
        <th rowspan="2" width="120">Аген-кие</th>
    </tr>
    <tr>
        <th>Цена<br>клиента</th>
        <th>Цена<br>фабрики</th>
        <th>Сумма<br>клиента</th>
        <th>Сумма<br>фабрики</th>
    </tr>
    {foreach $aOrderProduct as $oOrderProduct}
        {if $oOrderProduct->getMakePaid() == 0}
            <tr class="{if $oOrderProduct->getOrderStatus() == 'reclamation'} bg-red{/if}" data-order_product_id="{$oOrderProduct->getId()}" data-agent_commission="{$oOrderProduct->getAgentCommission()}">
            <td>
                {if $oOrderProduct->getMakePaid()}
                    <span class="checkbox-blue"></span>
                {else}
                    {component field template="checkbox" inputClasses="select-order"}
                {/if}

            </td>
            <td><a href="{$ADMIN_URL}order/{$oOrderProduct->getOrderId()}/">{$oOrderProduct->getAgentNumber()}</a></td>
            <td class="nobr">{GetSelectText($oOrderProduct->getOrderStatus(), 'order.status')}</td>
            <td>{$oOrderProduct->getTitleFull()}<br>
                <div class="fabrics">
                {foreach [1,2,3,4] as $iNum}
                    {if $oOrderProduct->getFabricLength($iNum) > 0}
                        <div class="fabric fabric{$iNum}">{if $oFabric = $oOrderProduct->getFabric($iNum)}{$oFabric->getAlt()} ({$oFabric->getSupplier()}){/if}</div>
                    {/if}
                {/foreach}
                </div>
            </td>
            {if $oOrderProduct->getOrderStatus() == 'shipped'}
                <td>0</td>
                <td>- {$oOrderProduct->getPriceMake(true)}</td>
                <td>0</td>
                <td>0</td>
                <td>x {$oOrderProduct->getCount()}</td>
                <td>
                    - {GetPrice($oOrderProduct->getPriceMake()*$oOrderProduct->getCount(), true)}
                    {$iAmount = $iAmount - $oOrderProduct->getPriceMake()*$oOrderProduct->getCount()}
                </td>
            {else}
                <td>{$oOrderProduct->getPrice(true)}</td>
                <td>- {$oOrderProduct->getPriceMake(true)}</td>
                <td>+ {$oOrderProduct->getPriceServicesAmount(true)}</td>
                <td>- {$oOrderProduct->getPriceServicesAmountMake(true)}</td>
                <td>x {$oOrderProduct->getCount()}</td>
                <td>{$oOrderProduct->getDiscount()|default:'-'}</td>
                <td>
                    {($oOrderProduct->getAgentCommission() - $oOrderProduct->getDiscount())|default:'-'}
                    {$iAmount = $iAmount + $oOrderProduct->getAgentCommission()-$oOrderProduct->getDiscount()}
                </td>
            {/if}
        </tr>
        {/if}
    {/foreach}
    <tr>
        <th colspan="10">ИТОГО</th>
        <th class="agent-commision">{$iAmount}</th>
    </tr>
</table>
    <p class="report-agent-note">В отчет попадают все заказы, которые:<br>
        1. имеют любой статус "На производстве", "Обратная связь", "Доставлен", "Рекламация" <br>
        2. "Дата доставки" или отгрузки попадает в выбранный период<br>
        3. Переданы на указанную фабрику.</p>
{/if}