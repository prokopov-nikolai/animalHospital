{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'price-agent'}
{/block}

{block name='layout_content'}
    <h2 class="page-sub-header">Агент: {$oAgent->getFio()} // {$oAgent->getPhone()}</h2>
    {if $aPrice|count == 0}<p>Ничего не найдено</p>{/if}
    <form action="" class="dflex">
        <input type="text" name="search" value="{$smarty.get.search}" class="w600">
        <button class="ls-button" style="margin: 10px;">Найти</button>
    </form>
    <table class="table">
        <tr>
            <th>Позиция</th>
            <th>Гр. // Диз. айди</th>
            <th>Цена</th>
            <th>Дата создания</th>
            <th></th>
        </tr>
        {foreach $aPrice as $oPrice}
            <tr>
                {if $oPrice->getProductId()}
                    <td>
                        <a href="{$ADMIN_URL}product/{$oPrice->getProductId()}/#tab5">{$oPrice->getProductTitleFull()}
                    </td>
                    <td>{$oPrice->getMakeGroupName()}</td>
                {else}
                    <td>
                        <a href="{$ADMIN_URL}product/design/{$oPrice->getDesignId()}/#tab5">{$oPrice->getProductTitleFull()}</a>
                    </td>
                    <td>D#{$oPrice->getDesignId()}</td>
                {/if}
                <td>{$oPrice->getPriceAgent()}</td>
                <td>{$oPrice->getDate()}</td>
                <td><a href="{$ADMIN_URL}product/price-agent/delete/{$oPrice->getId()}/" class="ls-icon-remove"></a></td>
            </tr>
        {/foreach}
    </table>
{/block}