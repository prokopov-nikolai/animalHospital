<table class="table">
    <tr>
        <th>id</th>
        <th>ФИО</th>
        <th>Телефон</th>
        <th>Email</th>
        <th>Агент</th>
        <th>Админ.</th>
        <th>Комментарий</th>
        <th></th>
    </tr>

    {foreach $aUser as $oU}
        <tr>
            <td>{$oU->getId()}</td>
            <td><a href="{$ADMIN_URL}user/{$oU->getId()}/">{$oU->getFio()}</a></td>
            <td>{$oU->getPhone()}</td>
            <td>{$oU->getEmail()}</td>
            <td>{($oU->getIsAgent()) ? 'Да' : '-'}</td>
            <td>{($oU->getIsAdmin()) ? 'Да' : '-'}</td>
            <td>{$oU->getComment()}</td>
            <td><a href="{$ADMIN_URL}user/{$oU->getId()}/" class="ls-icon-pencil"></a></td>
        </tr>
    {/foreach}
</table>