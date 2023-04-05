<table class="table">
    <tr>
        <th>id</th>
        <th>Название</th>
        <th>Кол-ции тканей</th>
        <th></th>
    </tr>

    {foreach $aMake as $oMake}
        <tr>
            <td>{$oMake->getId()}</td>
            <td>{$oMake->getTitle()}</td>
            <td width="200"><a href="{$ADMIN_URL}make/collection/{$oMake->getId()}/">Кол-ции тканей</a></td>
            <td width="70"><a href="{$ADMIN_URL}make/{$oMake->getId()}/" class="ls-icon-pencil"></a></td>
        </tr>
    {/foreach}
</table>