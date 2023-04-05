<table class="table">
    <tr>
        <th>Изобр-е</th>
        <th>Название</th>
        <th>Пр-ль</th>
        <th>Мин.<br>цена</th>
        <th>Скидка с</th>
        <th>Скидка до</th>
        <th>Скрыт</th>
        <th>Снят.<br>с пр-ва</th>
        <th></th>
    </tr>
    {$sDate = ''}
    {foreach $aProduct as $oP}
        {if $sDate != $oP->getDiscountDateFrom('d.m.Y')}
            {$sDate = $oP->getDiscountDateFrom('d.m.Y')}
            <tr>
                <th colspan="9" style="text-align: center;">{$sDate}</th>
            </tr>
        {/if}
        <tr>
            <td><a href="/{Config::Get('url_adm')}/product/{$oP->getId()}/"><img src="{$oP->getMainPhotoUrl('300x')}" alt="" width="100"></a></td>
            <td><a href="/{Config::Get('url_adm')}/product/{$oP->getId()}/">{$oP->getTitle()}</a></td>
            <td>{$oP->getMake()->getTitle()}</td>
            <td>{$oP->getPriceMake()|number_format:0:'.':' '}</td>
            <td>{$oP->getDiscountDateFrom('d.m.Y')}</td>
            <td>{$oP->getDiscountDateTo('d.m.Y')}</td>
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
