{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'analytics'}
    {$sMenuSelectSub = 'analytics_top30'}
{/block}


{block name='scripts' append}{/block}

{block name='layout_content'}
    <h2>ТОП 30</h2>
    {include file="{$aTemplatePathPlugin.admin}analytics/filter.top30.tpl"}
    <p>В отчете не учитывается скидка, которая была сделана по заказу</p>
    <table class="table" style="max-width: 800px;">
        <tr>
            <th width="120">№</th>
            <th>Наименование</th>
            <th>Выручка</th>
            <th>Кол-во, шт.</th>
        </tr>
        {$s = 0}
        {$c = 0}
        {foreach $orderProducts as $i => $op}
            <tr>
                <td>{$i+1}</td>
                <td>{$op->getTitleFull()}</td>
                <td>{$op->getSum()|number_format:0:',':' '}</td>
                <td>{$op->getProductsCount()}</td>
            </tr>
            {$s = $s + $op->getSum()}
            {$c = $c + $op->getProductsCount()}
        {/foreach}
        <tr>
            <th colspan="2">ИТОГО</th>
            <th>{$s|number_format:0:',':' '}</th>
            <th>{$c|number_format:0:',':' '}</th>
        </tr>
    </table>
{/block}