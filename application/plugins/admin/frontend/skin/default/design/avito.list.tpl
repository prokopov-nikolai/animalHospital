<table class="table">
    <tbody>
    <tr>
        <th></th>
        <th></th>
        <th></th>
        <th>Название</th>
        <th>Наценка</th>
        <th>Цена</th>
        <th>Дата начала</th>
        <th>Дата окончания</th>
        <th>Скрыт</th>
        <th></th>
    </tr>
    {foreach $aDesign as $i => $oDesign}
        <tr>
            <td>{$i+1}</td>
            <td>{$oDesign->getId()}</td>
            <td><a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/"><img
                            src="{$oDesign->getMainPhotoUrl('300x')}" alt="" width="100"></a></td>
            <td>
                <a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/">{$oDesign->getProductPrefix()} {$oDesign->getTitle()}</a>
            </td>
            <td>{$oDesign->getAvitoMargin()}</td>
            <td>{$oDesign->getAvitoPrice(true, true)}</td>
            <td>{$oDesign->getAvitoDateBegin()|date_format:'d.m.Y H:i'}</td>
            <td>{$oDesign->getAvitoDateEnd()|date_format:'d.m.Y H:i'}</td>
            <td>{($oDesign->getHide()) ? 'скрыт' : '-'}</td>
            <td><a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/" class="ls-icon-edit"></a></td>
        </tr>
    {/foreach}
    </tbody>
</table>