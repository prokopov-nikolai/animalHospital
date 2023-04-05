<table class="table">
    <tr>
        <th>id</th>
        <th>Название</th>
        <th>Url</th>
        <th></th>
    </tr>
    {foreach $aBlog as $oBlog}
        <tr>
            <td>{$oBlog->getId()}</td>
            <td>{$oBlog->getTitle()}</td>
            <td>{$oBlog->getUrl()}</td>
            <td>
                <a href="{$ADMIN_URL}blog/{$oBlog->getId()}/" class="ls-icon-edit" data-tooltip="Редактировать"></a> &nbsp;
                <a href="{$ADMIN_URL}blog/delete/{$oBlog->getId()}/" class="ls-icon-remove"></a></td>
        </tr>
    {/foreach}
</table>

{component pagination paging=$aPaging}
