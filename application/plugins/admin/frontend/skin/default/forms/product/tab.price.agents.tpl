{if !$oMake}
    <p class="ls-alert ls-alert--error">Необходимо выбрать производителя</p>
{else}
    <table class="table prices">
        <tr>
            <td></td>
            {foreach $oMake->getGroupsArray() as $iGroupNum => $sGroupName}
                <td class="prices">{$sGroupName}</td>
            {/foreach}
            <td></td>
        </tr>
        {foreach $aAgent as $oAgent}
            <tr>
                <th>{$oAgent->getFio()} // {$oAgent->getPhone(true)}</th>
                {foreach $oMake->getGroupsArray() as $iGroupNum => $sGroupName}
                    <td>
                        <input type="text" data-make-group="{$iGroupNum}"
                               name="product_price_agents[{$oAgent->getId()}][{$iGroupNum}]"
                               value="{(isset($aPriceAgent[$oAgent->getId()][$iGroupNum])) ? $aPriceAgent[$oAgent->getId()][$iGroupNum] : '-'}"
                               autocomplete="off" disabled
                               class="prices">
                    </td>
                {/foreach}
                <td><a href="" class="ls-icon-remove"></a></td>
            </tr>
        {/foreach}
    </table>
{/if}