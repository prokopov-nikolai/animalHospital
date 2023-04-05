{if count($userOrders) > 1 }
    {foreach $userOrders as $order}
        {if $order->getId() != $oOrder->getId()}
            <a href="{$ADMIN_URL}order/{$order->getId()}/">Заказа №{$order->getId()}</a><br>
        {/if}
    {/foreach}
{/if}