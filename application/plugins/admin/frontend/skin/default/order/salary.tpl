<table class="table{if !$smarty.get.print} rtable{/if}">
    <tr>{foreach $aDate as $aD}<th colspan="2"  style="border-left:#666 solid 1px;border-right:#666 solid 1px;">{$aD.date}</th>{/foreach}</tr>
    <tr>{foreach $aDate as $aD}<th colspan="2" style="border-left:#666 solid 1px;border-right:#666 solid 1px;">{$aD.name|upper}</th>{/foreach}</tr>
    {for $i=1 to $iMaxCount step 1}
        <tr>
            {foreach $aDate as $aD}
                {if is_array($aSalary[$aD.date]) && count($aSalary[$aD.date]) > 0}
                    {$oOP = array_shift($aSalary[$aD.date])}
                    <td{if $oOP->getOrderStatus() == 'failure'} title="ОТКАЗ"{elseif $oOP->getOrderStatus() == 'return'} title="ВОЗВРАТ"{/if} class="order-status-{$oOP->getOrderStatus()}" style="border-left:#666 solid 1px;border-right:#ddd solid 1px;"><a href="{$ADMIN_URL}/order/{$oOP->getOrderId()}/" title="Заказ №{$oOP->getOrderId()}">{$oOP->_getDataOne('title')}</td>
                    <td{if $oOP->getOrderStatus() == 'failure'} title="ОТКАЗ"{elseif $oOP->getOrderStatus() == 'return'} title="ВОЗВРАТ"{/if} class="order-status-{$oOP->getOrderStatus()}" style="border-right:#666 solid 1px;">{$oOP->$sFunction()}</td>
                {else}
                    <td style="border-left:#666 solid 1px;"></td>
                    <td style="border-right:#666 solid 1px;"></td>
                {/if}
            {/foreach}
        </tr>
    {/for}
</table>
<div class="cl h20"></div>