{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'settings'}
    {$sMenuSelectSub = 'settings_direct'}
{/block}

{block name='layout_content'}
    <h1>Подмена номеров</h1>
    <form action="" method="post">
        {component field template='text'
        name    ='utm_source'
        label   ='utm_source'
        classes = 'w3'}
        {component field template='text'
        name    ='phone'
        label   ='телефон'
        classes = 'w3'}
        {component button text='Добавить'}
    </form>
    <div class="cl h20"></div>
    <table class="table direct">
        <tr>
            <th>utm_source</th>
            <th>телефон</th>
            <th></th>
        </tr>
        {foreach $aDirect as $sUtmSource => $sPhone}
            <tr>
                <td>{$sUtmSource}</td>
                <td>{$sPhone}</td>
                <td>
                    <a href="/?utm_source={$sUtmSource}" class="ls-icon-share" target="_blank"></a>
                    <a href="{$ADMIN_URL}settings/direct/delete/{$sUtmSource}/" class="ls-icon-remove"></a>
                </td>
            </tr>
        {/foreach}
    </table>
{/block}