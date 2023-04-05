{if count($pivotCosts)}
    <h3>Расходы свод</h3>
    <table class="table report-costs">
        <tr>
            <th>Тип</th>
            <th>Сумма</th>
        </tr>
        {foreach $pivotCosts as $cost}
            <tr>
                <td><a href="{$ADMIN_URL}report/costs/?date={$smarty.get.date}&type={$cost->getType()}">{$cost->getType()}</a></td>
                <td>{$cost->getSum()|getPrice:true}</td>
            </tr>
            {$mount = $mount + $cost->getSum()}
        {/foreach}
        <tr>
            <th>ИТОГО</th>
            <th>{$mount|GetPrice:true:true}</th>
        </tr>
    </table>
{/if}
{if count($costs)}
    {$mount = 0}
    <div class="cl h20"></div>
    <h3>Расходы детально</h3>
    <table class="table report-costs">
        <tr>
            <th>Дата</th>
            <th>Тип</th>
            <th>Сумма</th>
            <th>Комментарий</th>
            <th></th>
        </tr>
        {foreach $costs as $cost}
            <tr>
                <td>{$cost->getDate()|date_format:'d.m.Y'}</td>
                <td>{$cost->getType()}</td>
                <td>{$cost->getSum()|getPrice:true}</td>
                <td>{$cost->getComment()}</td>
                <td>
                    <div class="ls-icon-remove cost-delete" data-id="{$cost->getId()}"></div>
                </td>
            </tr>
            {$mount = $mount + $cost->getSum()}
        {/foreach}
        <tr>
            <th colspan="2">ИТОГО</th>
            <th colspan="3">{$mount|GetPrice:true:true}</th>
        </tr>
    </table>
{else}
    Пусто
{/if}