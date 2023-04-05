{if $orderProducts|count > 0}
    {$amount = 0}
    <table class="table report-agent">
        <tr>
            <th width="30">{component field template="checkbox" inputClasses="select-all"}</th>
            <th>Номер<br>заказа</th>
            <th class="product">Изделие</th>
            <th>Кол-во</th>
            <th width="120">Аген-кие</th>
        </tr>
        {foreach $orderProducts as $orderProduct}
            <tr data-order_product_id="{$orderProduct->getId()}" data-agent_commission="{$orderProduct->getAgentCommission()}">
                <td>
                    {if $orderProduct->getManagerPaid()}
                        <span class="checkbox-green"></span>
                    {else}
                        {component field template="checkbox" inputClasses="select-order"}
                    {/if}

                </td>
                <td><a href="{$ADMIN_URL}order/{$orderProduct->getOrderId()}/">{$orderProduct->getAgentNumber()}</a></td>
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
                    <td>x {$orderProduct->getCount()}</td>
                    <td>
                        {$orderProduct->getAgentCommission(true)|default:'-'}
                        {$amount = $amount + $orderProduct->getAgentCommission()}
                    </td>
                {/if}
            </tr>
        {/foreach}
        <tr>
            <th colspan="4">ИТОГО</th>
            <th class="agent-commision">{$amount|GetPrice:1}</th>
        </tr>
    </table>
    {LS::Append('managerAmount', $amount)}
    <p class="report-agent-note">В отчет попадают все заказы, которые:<br>
        1. Имеют любой статус "На производстве", "Обратная связь", "Доставлен" <br>
        2. Заказы из статуса рекламация должны быть перенесены в доставлено после ее разрешения, чтобы попасть в зарплату<br>
        3. Дата оформления заказа в выбранный период<br>
        4. Обработаны указанным менеджером.</p>
{/if}