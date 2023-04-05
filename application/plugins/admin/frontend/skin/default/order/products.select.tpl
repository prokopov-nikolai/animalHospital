{$items = []}
{foreach $orderProducts as $orderProduct}
    {$items[] = ['text' => $orderProduct->getProductTitleFull(), 'value' => $orderProduct->getId()]}
{/foreach}
{component field template='select'
    label = "&nbsp;<br>Товар"
    name = 'order_product_id'
    classes = 'order-product-id'
    items = $items}