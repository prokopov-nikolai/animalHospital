{if count($orders) > 0 }
    {foreach $orders as $order}
        <a href="{$ADMIN_URL}order/{$order->getId()}/">Заказа №{$order->getId()}</a><br>
    {/foreach}
{/if}