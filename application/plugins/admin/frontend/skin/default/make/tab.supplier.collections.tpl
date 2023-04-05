{*{$aCollection|pr}*}
{if is_array($aCollection) && count($aCollection) > 0}
    <table class="table">
        {foreach $aCollection as $oCollection}
            <tr>
                <td width="50%" class="collection-title">{$oCollection->getTitle()}</td>
                <td width="50%" class="make-group">{component field template='select'
                    items           = $aMakeGroupsForSelect
                    inputClasses    = 'make-collection'
                    inputAttributes = ['data-make-id'=> $oMake->getId(), 'data-collection-id' => $oCollection->getId()]
                    selectedValue   = ($oCollection->getMakeGroup() == '') ? -1 : $oCollection->getMakeGroup()}</td>
            </tr>
        {/foreach}
    </table>
{/if}