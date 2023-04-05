{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_head_end'}
    <style>
        @media print {
            @page {
                size:landscape;
            }
        }
    </style>
{/block}

{block name='layout_options'}
    {$sMenuSelect = 'report'}
    {$sMenuSelectSub = 'report_summary'}
{/block}

{block name='layout_content'}
    <h1>Сводный отчет</h1>
    
    <table class="table">
        <tr>
            <th>Дата</th>
            <th>Кол-во заказов</th>
            <th>Агентские</th>
            <th data-tooltip="Общий размер скидок за месяц">Скидки</th>
            <th>Расходы</th>
            <th>Средняя мар-ть</th>
            <th>Средняя в день</th>
            <th>ИТОГО</th>
        </tr>
        {foreach $orders as $orderMonth}
{*            {$orderMonth|prex}*}
            <tr>
                {$month = date("m.Y", strtotime($orderMonth->getDateMonthYear()))}
                <td>{$month}</td>
                <td>{$orderMonth->getOrdersCount()}</td>
                <td>{$orderMonth->_getDataOne('margin')|GetPrice:1:0}</td>
                <td>{$orderMonth->getDiscountSum()|GetPrice:1:0}</td>
                <td>
                    {if $costs[$month]}
                        {$costs[$month]->getSum()|GetPrice:1:0}
                    {/if}
                </td>
                <td>{round($orderMonth->_getDataOne('margin')/$orderMonth->getOrdersCount(), 0)|GetPrice:1:0}</td>
                <td>
                    {if $dateCurrent->format('m.Y') == date("m.Y", strtotime($orderMonth->getDateMonthYear()))}
                        {round($orderMonth->getOrdersCount()/$dateCurrent->format('d'), 1)}
                    {else}
                        {round($orderMonth->getOrdersCount()/$orderMonth->getLastDay(), 1)}
                    {/if}
                </td>
                <th>
                    {if $costs[$month]}
                        {($orderMonth->_getDataOne('margin') - $costs[$month]->getSum())|GetPrice:1:0}
                    {else}
                        {$orderMonth->_getDataOne('margin')|GetPrice:1:0}
                    {/if}</th>
            </tr>
        {/foreach}
    </table>

{/block}

{block name='scripts' append}
    <script>
        $(function () {
        });
    </script>
{/block}