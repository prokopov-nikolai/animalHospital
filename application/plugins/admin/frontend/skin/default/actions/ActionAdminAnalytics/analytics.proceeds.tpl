{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'analytics'}
    {$sMenuSelectSub = 'analytics_proceeds'}
{/block}


{block name='scripts' append}
    <script src="/application/plugins/admin/frontend/skin/default/assets/js/chart.js"></script>
    <script src="/application/plugins/admin/frontend/skin/default/assets/js/chart.utils.js"></script>

    {$ordersCount = 0}
    {$label = []}
    {$data = []}
    {$reclamations = []}
    {$returns = []}
    {foreach $orders as $order}
        {$ordersCount = $ordersCount + $order->getOrdersCount()}
        {$q = array_unshift($label, $order->getDateFormat('d.m'))}
        {$q = array_unshift($data, $order->getOrdersCount())}
        {$reclamationCount = ($dataRejected['reclamation'][$order->getDateFormat('Y-m-d')]) ? $dataRejected['reclamation'][$order->getDateFormat('Y-m-d')] : 0}
        {$q = array_unshift($reclamations, $reclamationCount)}
        {$returnCount = ($dataRejected['return'][$order->getDateFormat('Y-m-d')]) ? $dataRejected['return'][$order->getDateFormat('Y-m-d')] : 0}
        {$q = array_unshift($returns, $returnCount)}
    {/foreach}

    <script>
        const ctx = document.getElementById('chart');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: {$label|json_encode},
                datasets: [
                    {
                        label: '# Заказы',
                        data: {$data|json_encode},
                        borderWidth: 2,
                        tension: 0.4,
                        borderColor: Utils.CHART_COLORS.green
                    },
                    {
                        label: '# Рекламации',
                        data: {$reclamations|json_encode},
                        borderWidth: 2,
                        tension: 0.4,
                        borderColor: Utils.CHART_COLORS.blue
                    },
                    {
                        label: '# Возврат',
                        data: {$returns|json_encode},
                        borderWidth: 2,
                        tension: 0.4,
                        borderColor: Utils.CHART_COLORS.red
                    }
                ]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });


        /**
         * Поиск агента
         */
        $('.autocomplete-pro.agent').autocompletePro({
                name: 'agent',
                url: '/ajax/search/agent/',
                data: {
                    field: 'value'
                },
                render: function (obj) {
                    var item =
                        '<div class="row" data-id="' + obj.id + '">' +
                        '<span>' + obj.fio + ' // ' + obj.phone + '</span>'
                    '</div>';
                    return item;
                }
            },
            function (obj) {
                $('#agent_id').val(obj.id);
                $(this).val(obj.fio);
            }
        );
        /**
         * Поиск товара
         */
        $('.autocomplete-pro.product').autocompletePro({
            name: 'products',
            name_search: 'search',
            url: ADMIN_URL+'product/ajax/search/',
            data: {},
            render : function(obj){
                var item =
                    '<div class="row" data-id="'+obj.id+'">' +
                    '<span>'+obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ': '')+'</span>'+
                    '</div>';
                return item;
            }
        }, function(obj){
            $('#product-id').val(obj.id);
            $(this).val(obj.name);
        });
    </script>
{/block}

{block name='layout_content'}
    <h2>Объемы продаж</h2>
    {include file="{$aTemplatePathPlugin.admin}analytics/filter.proceeds.tpl"}

    <canvas id="chart" style="max-width: 1000px;" height="100"></canvas>
    <p></p>
    <table class="table analytics" style="max-width: 400px;">
        <tr>
            <th>Дата</th>
            <th>Выручка</th>
            <th>Кол-во (товаров), шт.</th>
            <th>Кол-во (заказов), шт.</th>
            <th>Кол-во рекламаций, шт.</th>
            <th>Кол-во возвраты, шт.</th>
        </tr>
        {$sum = 0}
        {$pc = 0}
        {$oc = 0}
        {$rc = 0}
        {$rec = 0}
        {foreach $orders as $order}
            <tr class="{if $currentWeekday == 0 || $currentWeekday == 6} day-off{/if}">
                <td class="nowrap">
                    {$order->getDateFormat('d.m')}  (<span class="weekday">{$weekdays[$currentWeekday]}</span>)
                </td>
                <td>{$order->getSum()|number_format:0:',':' '}</td>
                <td>{$order->getProductsCount()}</td>
                <td>{$order->getOrdersCount()}</td>
                {$reclamationCount = ($dataRejected['reclamation'][$order->getDateFormat('Y-m-d')]) ? $dataRejected['reclamation'][$order->getDateFormat('Y-m-d')] : 0}
                <td>{$reclamationCount}</td>
                {$returnCount = ($dataRejected['return'][$order->getDateFormat('Y-m-d')]) ? $dataRejected['return'][$order->getDateFormat('Y-m-d')] : 0}
                <td>{$returnCount}</td>
            </tr>
            {$sum = $sum + $order->getSum()}
            {$pc = $pc + $order->getProductsCount()}
            {$oc = $oc + $order->getOrdersCount()}
            {$rc = $rc + $reclamationCount}
            {$rec = $rec + $returnCount}
            {$currentWeekday = ($currentWeekday - 1 + 7) % 7}
        {/foreach}
        <tr>
            <th>ИТОГО</th>
            <th>{$sum|number_format:0:',':' '}</th>
            <th>{$pc|number_format:0:',':' '}</th>
            <th>{$oc|number_format:0:',':' '}</th>
            <th>{$rc|number_format:0:',':' '} ({($rc/$pc*100)|number_format:1}%)</th>
            <th>{$rec|number_format:0:',':' '} ({($rec/$pc*100)|number_format:1}%)</th>
        </tr>
    </table>
{/block}