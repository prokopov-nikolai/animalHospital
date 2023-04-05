{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'product'}
{/block}

{block name='layout_content'}
    <h2>Импорт данных товаров</h2>
    <p class="notice" style="color: #d60000;">Пока обновляются только цены</p>
    <p>ОБЯЗАТЕЛЬНО ОБНОВИТЬ price_make в <a href="/pricelist/">Прайслисте</a></p>
    <table class="table">
        <tr>
            <th>№</th>
            <th>id</th>
            <th>Название</th>
            <th>Дата обновления (Источник)</th>
            <th>Дата обновления (База)</th>
            <th></th>
        </tr>
        {$i = 1}
        {foreach $aImportData as $iId => $aD}
{*            {$aD|prex}*}
            {$oProduct = $aProduct[$iId]}
            <tr>
                <td>{$i}</td>
                <td>{$iId}</td>
                <td>
                    {if $oProduct}
                        <a target="_blank" href="{$ADMIN_URL}product/{($oProduct) ? $oProduct->getId() : ''}">{($oProduct) ? $oProduct->getTitleFull() : ''}</a>
                    {else}
                        {$aD['title_full']}
                    {/if}
                </td>
                <td class="nobr">{$oDataUpdate = $aD['date_update']}{$oDataUpdate->format('d.m.Y H:i')}</td>
                <td class="date-update nobr">{($oProduct) ? $oProduct->getExternalDateUpdate('d.m.Y H:i') : ''}</td>
                <td>
                    {if $oProduct && $oDataUpdate->format('d.m.Y H:i') != $oProduct->getExternalDateUpdate('d.m.Y H:i')}
                        <div class="ls-button import-data" data-external-id="{$iId}" data-url="{$aD['url']}">Обновить</div>
                    {elseif !$oProduct}
                        <div class="ls-button add-product" data-external-id="{$iId}" data-url="{$aD['url']}">Добавить</div>
                    {/if}</td>
            </tr>
            {$i = $i + 1}
        {/foreach}
    </table>
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.import-data').on('click', function(){
                let oBut = $(this);
                oBut.addClass('processing');
                ls.ajax.load(ADMIN_URL+'product/import-data/', oBut.data(), function(answ){
                    oBut.after(answ.sHtml);
                    oBut.parents('tr').find('.date-update').html(answ.dateUpdate);
                    oBut.remove();
                });
            });
            $('.add-product').on('click', function(){
                let oBut = $(this);
                oBut.addClass('processing');
                ls.ajax.load(ADMIN_URL+'product/import-data/add-product/', oBut.data(), function(answ){
                    oBut.after(answ.sHtml);
                    oBut.parents('tr').find('.date-update').html(answ.dateUpdate);
                    oBut.remove();
                });
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}