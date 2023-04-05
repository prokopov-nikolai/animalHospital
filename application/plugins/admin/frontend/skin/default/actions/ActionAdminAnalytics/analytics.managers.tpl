{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'analytics'}
    {$sMenuSelectSub = 'analytics_managers'}
{/block}


{block name='scripts' append}
    <script src="/application/plugins/admin/frontend/skin/default/assets/js/chart.js"></script>
    <script src="/application/plugins/admin/frontend/skin/default/assets/js/chart.utils.js"></script>

    {$ordersCount = 0}
    {$label = []}
    {$data = [19 => [], 20 => [], 1301 => []]}
    {$colors = [19 => 'green', 20 =>'blue', 1301 => 'red']}
    {foreach $orders as $date => $managerOrders}
        {foreach $managers as $id => $manager}
            {$order = $managerOrders[$id]}
            {if $id == 19}
                {$q = array_unshift($label, substr($date, 0, 5))}
            {/if}
            {$q = array_unshift($data[$manager->getId()], (($order) ? $order->getOrdersCount(): 0))}
        {/foreach}
    {/foreach}

    {* Подсчитаем нарастающим итогом *}
    {* TODO переписать на динамику*}
    {$data1 = [19 => [], 20 => [], 1301 => []]}
    {$cumulativeSum = [19 => 0, 20 => 0, 1301 => 0]}
    {foreach $managers as $id => $manager}
        {foreach $data[$id] as $i => $count}
            {$cumulativeSum[$id] = $cumulativeSum[$id] + $count}
            {$data1[$id][$i] = $cumulativeSum[$id]}
        {/foreach}
    {/foreach}

    <script>
        const ctx = document.getElementById('chart');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: {$label|json_encode},
                datasets: [
                    {foreach $managers as $id => $manager}
                    {
                        label: '# {$manager->getFio()}',
                        data: {$data1[$id]|json_encode},
                        borderWidth: 2,
                        tension: 0.4,
                        borderColor: Utils.CHART_COLORS.{$colors[$id]}
                    },
                    {/foreach}
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
    </script>
{/block}

{block name='layout_content'}
    <h2>Продажи по менеджерам</h2>
    {include file="{$aTemplatePathPlugin.admin}analytics/filter.managers.tpl"}

    <canvas id="chart" style="max-width: 1000px;" height="100"></canvas>
    <p></p>
    <table class="table" style="max-width: 400px;">
        <tr>
            <th>Дата</th>
            {foreach $managers as $manager}
                <th>{$manager->getFio()}</th>
            {/foreach}
        </tr>
        {$sum = []}
        {foreach $orders as $date => $managerOrders}
            <tr>
                <td>{$date}</td>
                {foreach $managers as $manager}
                    {$data = $managerOrders[$manager->getId()]}
                    <td>{($data) ? $data->getOrdersCount(): 0}</td>
                    {$sum[$manager->getId()] = $sum[$manager->getId()] + (($data) ? $data->getOrdersCount() : 0)}
                {/foreach}
            </tr>
        {/foreach}
        <tr>
            <th>ИТОГО</th>
            {foreach $managers as $manager}
                <th>{$sum[$manager->getId()]}</th>
            {/foreach}
        </tr>
    </table>
{/block}