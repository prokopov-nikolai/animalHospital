<table class="table">
    <tr>
        <th>Изобр-е</th>
        <th>Название</th>
        <th>Мин.<br>цена</th>
        <th>Скрыт</th>
        <th>Снят.<br>с пр-ва</th>
        <th></th>
    </tr>
    {foreach $aProduct as $oP}
        <tr>
            <td><a href="/{Config::Get('url_adm')}/product/{$oP->getId()}/"><img src="{$oP->getMainPhotoUrl('300x')}" alt="" width="100"></a></td>
            <td><a href="/{Config::Get('url_adm')}/product/{$oP->getId()}/">{$oP->getTitle()}</a></td>
            <td>{$oP->getPriceMake()|number_format:0:'.':' '}</td>
            <td>{($oP->getHide()) ? 'да' : '-'}</td>
            <td>{($oP->getNotProduced()) ? 'да' : '-'}</td>
            <td>
                <a href="{$ADMIN_URL}product/redirect/{$oP->getId()}/" class="ls-icon-share" target="_blank" data-tooltip="Открыть с клиентской стороны"></a> &nbsp;
                <a href="{$ADMIN_URL}product/{$oP->getId()}/" class="ls-icon-edit" data-tooltip="Редактировать"></a> &nbsp;
                <a href="{$ADMIN_URL}product/delete/{$oP->getId()}/" class="ls-icon-remove"></a></td>
        </tr>
    {/foreach}
</table>

{component pagination paging=$aPaging}
