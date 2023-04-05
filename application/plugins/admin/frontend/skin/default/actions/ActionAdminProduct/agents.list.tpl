{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'price-agent'}
{/block}

{block name='layout_content'}
    <h1>Скидки агентов</h1>
    <p><b>Добавить скидку на </b> <a href="{$ADMIN_URL}product/price-agent/add-by-category/" class="ls-button">Категорию</a> // <a href="{$ADMIN_URL}product/price-agent/add-by-design/" class="ls-button">Дизайн</a></p>
    <h2 class="page-sub-header">Выберите агента</h2>
    <table class="table">
        {foreach $aAgent as $oUser}
            <tr>
                <td><a href="{$ADMIN_URL}product/price-agent/{$oUser->getId()}/">{$oUser->getFio()}</a></td>
                <td>{$oUser->getPhone()}</td>
            </tr>
        {/foreach}
    </table>
{/block}