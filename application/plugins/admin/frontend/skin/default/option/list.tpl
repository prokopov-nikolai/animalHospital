<table class="table">
    <tr>
        <th>id</th>
        <th>Название</th>
        <th></th>
    </tr>

    {foreach $aOption as $oOption}
        <tr>
            <td>{$oOption->getId()}</td>
            <td>{$oOption->getTitle()}</td>
            <td width="70"><a href="{$ADMIN_URL}option/{$oOption->getId()}/" class="ls-icon-pencil"></a></td>
        </tr>
    {/foreach}
</table>