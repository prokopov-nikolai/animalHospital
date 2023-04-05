{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'analytics'}
    {$sMenuSelectSub = 'analytics_manufactures'}
{/block}


{block name='scripts' append}
    <script src="/application/plugins/admin/frontend/skin/default/assets/js/chart.js"></script>
    <script src="/application/plugins/admin/frontend/skin/default/assets/js/chart.utils.js"></script>
    <script>
        const ctx = document.getElementById('chart');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: {$labels|array_reverse|json_encode},
                datasets: [
                    {foreach $makeSelected as $makeId}
                    {$make = $makes[$makeId]}
                    {
                        label: '# {$make->getTitle()}',
                        data: {$ordersCumulative[$makeId]|json_encode},
                        borderWidth: 2,
                        tension: 0.4,
                        borderColor: Utils.CHART_COLORS.{$colors[$makeId]} // {$makeId}
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

        $(function(){
            $('.ls-field.make [data-value="all"]').on('click', function(){
                $('.ls-field.make ._option').each(function(i){
                    if ($(this).data('value') != 'dall' && $(this).data('value') != 'all' && $(this).data('value') != 0) {
                        if (!$(this).hasClass('selected')) {
                            $(this).trigger('click');
                        }
                    }
                    $('.ls-field-input.make option[value="all"]')[0].selected = false;
                    $('.ls-field-input.make option[value="dall"]')[0].selected =  false;
                    $('.ls-field.make [data-value="all"]').removeClass('selected');
                    $('.ls-field.make [data-value="dall"]').removeClass('selected');
                });
                return false;
            });

            $('.ls-field.make [data-value="dall"]').on('click', function(){
                $('.ls-field.make ._option').each(function(i){
                    if ($(this).data('value') != 'dall' && $(this).data('value') != 'all' && $(this).data('value') != 0) {
                        if ($(this).hasClass('selected')) {
                            $(this).trigger('click');
                        }
                    }
                    $('.ls-field-input.make option[value="all"]')[0].selected = false;
                    $('.ls-field-input.make option[value="dall"]')[0].selected =  false;
                    $('.ls-field.make [data-value="all"]').removeClass('selected');
                    $('.ls-field.make [data-value="dall"]').removeClass('selected');
                });
                return false;
            });
        });
    </script>
{/block}

{block name='layout_content'}
    <h2>Продажи по фабрикам</h2>
    {include file="{$aTemplatePathPlugin.admin}analytics/filter.manufactures.tpl"}

    <canvas id="chart" style="max-width: 1000px;" height="100"></canvas>
    <p></p>
    <table class="table" style="max-width: 400px; white-space: nowrap;">
        <tr>
            <th>Дата</th>
            {foreach $makeSelected as $makeId}
                {$make = $makes[$makeId]}
                <th>{$make->getTitle()}</th>
            {/foreach}
        </tr>
        {$sum = []}
        {foreach $labels as $date}
            <tr>
                <td>{$date}</td>
                {foreach $makeSelected as $makeId}
                    <td>{$orders[$makeId][$date]}</td>
                    {$sum[$makeId] = $sum[$makeId] + $orders[$makeId][$date]}
                {/foreach}
            </tr>
        {/foreach}
        <tr>
            <th>ИТОГО</th>
            {foreach $makeSelected as $makeId}
                <th>{$sum[$makeId]}</th>
            {/foreach}
        </tr>
    </table>
{/block}