{if $orderProducts|count > 0}
    {$count = 0}
    {$amount = 0}
    <table class="table report-agent">
        <tr>
            <th width="30">{component field template="checkbox" inputClasses="select-all"}</th>
            <th>Дата</th>
            <th>Номер<br>заказа</th>
            <th>Статус</th>
            <th>Фабрика</th>
            <th class="product">Изделие</th>
            <th>Кол-во</th>
            <th width="120">Аген-кие</th>
            <th width="120">Тип отказа</th>
            <th width="120">Причина отказа</th>
        </tr>
        {foreach $orderProducts as $orderProduct}
            <tr data-order_id="{$orderProduct->getOrderId()}" data-agent_commission="{$orderProduct->getAgentCommission()}">
                <td>
                    {if $orderProduct->getClosed()}
                        <span class="checkbox-red"></span>
                    {else}
                        {component field template="checkbox" inputClasses="select-order"}
                    {/if}
                </td>
                <td>{$orderProduct->getDateAdd()|date_format:'d.m.Y'}</td>
                <td><a href="{$ADMIN_URL}order/{$orderProduct->getOrderId()}/">{$orderProduct->getAgentNumber()}</a></td>
                <td>{GetSelectText($orderProduct->getStatus(), 'order.status')}</td>
                <td>{$orderProduct->getMakeTitle()}</td>
                <td>{$orderProduct->getTitleFull()}<br>
                    <div class="fabrics">
                    {foreach [1,2,3,4] as $iNum}
                        {if $orderProduct->getFabricLength($iNum) > 0}
                            <div class="fabric fabric{$iNum}">{if $oFabric = $orderProduct->getFabric($iNum)}{$oFabric->getAlt()} ({$oFabric->getSupplier()}){/if}</div>
                        {/if}
                    {/foreach}
                    </div>
                </td>
                {if $orderProduct->getOrderStatus() == 'shipped'}
                    <td>x {$orderProduct->getCount()}</td>
                    <td>
                        - {GetPrice($orderProduct->getPriceMake()*$orderProduct->getCount(), true)}
                        {$iAmount = $iAmount - $orderProduct->getPriceMake()*$orderProduct->getCount()}
                    </td>
                {else}
                    <td>
                        x {$orderProduct->getCount()}
                        {$count = $count + $orderProduct->getCount()}
                    </td>
                    <td>
                        {$orderProduct->getAgentCommission(true)|default:'-'}
                        {$amount = $amount + $orderProduct->getAgentCommission()}
                    </td>
                {/if}
                <td>{$rejectedTypes[$orderProduct->getRejectedType()]}</td>
                <td>{$orderProduct->getRejectedCause()}</td>
            </tr>
        {/foreach}
        <tr>
            <th colspan="6">ИТОГО</th>
            <th class="count">{$count}</th>
            <th class="agent-commision">{$amount|GetPrice:1}</th>
            <th></th>
            <th></th>
        </tr>
    </table>
    {LS::Append('managerAmount', $amount)}
    <p class="report-agent-note"></p>
{/if}