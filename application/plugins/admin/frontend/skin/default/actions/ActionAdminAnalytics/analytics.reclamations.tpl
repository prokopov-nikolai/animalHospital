{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'analytics'}
    {$sMenuSelectSub = 'analytics_reclamations'}
{/block}


{block name='scripts' append}{/block}

{block name='layout_content'}
    <h2>Рекламации по фабрикам</h2>
    {include file="{$aTemplatePathPlugin.admin}analytics/filter.reclamations.tpl"}



    <table class="table" style="max-width: 400px; white-space: nowrap;">
        <tr>
            <th>Фабрика</th>
            <th>Кол-во товаров</th>
            {$a = array_shift(array_values($reclamations))}
            {foreach $a as $t => $c}
                <th>{$rejectedTypes[$t]}</th>
            {/foreach}
            <th>%</th>
        </tr>
        {$count = 0}
        {$reclamationsSum['all'] = 0}
        {foreach $ordersCount as $makeId => $data}
            {$make = $makes[$makeId]}
            <tr>
                <td><a href="{$ADMIN_URL}report/failure/?date_from={$oDateFrom->format('d.m.Y')}&date_to={$oDateTo->format('d.m.Y')}&make_id[]={$makeId}&type[]=reclamation&type[]=failure-ready&type[]=return">{$make->getTitle()}</a></td>
                <td>{$ordersCount[$makeId]->getProductsCount()}</td>
                {foreach $reclamations[$makeId] as $t => $c}
                    <td>{if $c}<b>{$c}</b>{else}0{/if} ({($c/$ordersCount[$makeId]->getProductsCount()*100)|number_format:1})</td>
                    {$reclamationsSum[$t] = $reclamationsSum[$t] + $c}
                {/foreach}
                <td>{($reclamations[$makeId]['sum']/$ordersCount[$makeId]->getProductsCount()*100)|number_format:1}</td>
                {$reclamationsSum['all'] = $reclamationsSum['all'] + $reclamations[$makeId]['sum']}
            </tr>
            {$count = $count + $ordersCount[$makeId]->getProductsCount()}
        {/foreach}
        <tr>
            <th>ИТОГО</th>
            <th>{$count}</th>
            {foreach $reclamations[$makeId] as $t => $c}
                <th>{$reclamationsSum[$t]} ({($reclamationsSum[$t]/$count*100)|number_format:1})</th>
            {/foreach}
            <th>{($reclamationsSum['all']/$count*100)|number_format:1}</th>
        </tr>
    </table>

    <p class="report-agent-note">
        В отчете выводится количество товаров произведенных за выбранный период. <br>
        Количество рекламаций считается по дате их возникновения, а не дате заказа.
    </p>
{/block}