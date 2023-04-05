{if $aPriceAgent|count == 0}
    <p>Скидки не найдены</p>
{else}
    <table class="table prices">
        {foreach $aAgent as $oAgent}
            <tr>
                <th>{$oAgent->getFio()} // {$oAgent->getPhone(true)}</th>
                <td>
                    <input type="text" data-make-group="{$iGroupNum}" name="design_price_agents[{$oAgent->getId()}]"
                           value="{(isset($aPriceAgent[$oAgent->getId()])) ? $aPriceAgent[$oAgent->getId()] : '-'}" autocomplete="off" disabled
                           class="prices">
                </td>
                <td><a href="" class="ls-icon-remove"></a></td>
            </tr>
        {/foreach}
    </table>
{/if}