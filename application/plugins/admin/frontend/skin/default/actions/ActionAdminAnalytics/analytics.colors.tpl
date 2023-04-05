{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'analytics'}
    {$sMenuSelectSub = 'analytics_colors'}
{/block}


{block name='scripts' append} {/block}

{block name='layout_content'}
    {include file="{$aTemplatePathPlugin.admin}analytics/filter.colors.tpl"}

    <div class="dflex">
        <div class="block">
            <h2>Цвета</h2>
            <table class="table" style="max-width: 800px;">
            <tr>
                <th width="120">№</th>
                <th>Наименование</th>
                <th>Кол-во, шт.</th>
            </tr>
            {$c = 0}
            {foreach $orderProducts as $i => $op}
                <tr>
                    <td>{$i+1}</td>
                    <td>{$op->getColor()} ({$op->getFabricId()})</td>
                    <td>{$op->getProductsCount()}</td>
                </tr>
                {$c= $c + $op->getProductsCount()}
            {/foreach}
            <tr>
                <th colspan="2">ИТОГО</th>
                <th>{$c|number_format:0:',':' '}</th>
            </tr>
        </table>
        </div>
        <div class="block">
            <h2>Ткани</h2>
            <table class="table" style="max-width: 800px;">
            <tr>
                <th width="120">№</th>
                <th>Наименование</th>
                <th>Кол-во, шт.</th>
            </tr>
            {$c = 0}
            {foreach $orderProducts1 as $i => $op}
                <tr>
                    {*                {$op->getTitle()|prex}*}
                    <td>{$i+1}</td>
                    <td>{$op->getFabricName()} ({$op->getFabricId()})</td>
                    <td>{$op->getProductsCount()}</td>
                </tr>
                {$c= $c + $op->getProductsCount()}
            {/foreach}
            <tr>
                <th colspan="2">ИТОГО</th>
                <th>{$c|number_format:0:',':' '}</th>
            </tr>
        </table>
        </div>
    </div>
{/block}