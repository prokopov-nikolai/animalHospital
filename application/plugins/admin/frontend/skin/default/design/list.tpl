{$iProductId = 0}
{if $bShowPlitka}
    <div class="dflex">
        {foreach $aDesign as $oDesign}
            {if $iProductId != $oDesign->getProductId()}
                {$iProductId = $oDesign->getProductId()}
                <div class="product-title">{$oDesign->getProductTitle()}</div>
            {/if}
            <a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/" class="design">
                <img src="{$oDesign->getMainPhotoUrl('300x')}" alt="">
                <span class="category">{$oDesign->getProductPrefix()}</span>
                <span class="title">{$oDesign->getTitle()}</span>
                <span class="price">{$oDesign->getPrice(true, true)}</span>
            </a>
        {/foreach}
    </div>
{else}
    <div class="cl" style="height: 20px;"></div>
    <table class="table">
        <tbody>
        <tr>
            <th>Изображение</th>
            <th>Название</th>
            <th>Наценка</th>
            <th>Цена</th>
            <th>Скрыт</th>
            <th></th>
        </tr>
        {foreach $aDesign as $oDesign}
            {if $iProductId != $oDesign->getProductId()}
                {$iProductId = $oDesign->getProductId()}
                <tr><td colspan="6"><h3>{$oDesign->getProductTitle()}</h3></td></tr>
            {/if}
            <tr>
                <td><a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/"><img src="{$oDesign->getMainPhotoUrl('300x')}" alt="" width="100"></a></td>
                <td><a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/">{$oDesign->getProductPrefix()} {$oDesign->getTitle()}</a></td>
                <td>{($oDesign->getPrice()-$oDesign->getPriceMake())|GetPrice:true:true}</td>
                <td>{$oDesign->getPrice(true, true)}</td>
                <td>{($oDesign->getHide()) ? 'скрыт' : '-'}</td>
                <td>
                    <a href="{$ADMIN_URL}product/design/copy/{$oDesign->getId()}/" target="_blank" class="ls-icon-copy" title="Копировать дизайн"></a> &nbsp;&nbsp;&nbsp;
                    <a href="{$oDesign->getUrlFull()}" target="_blank" class="ls-icon-share"></a>
                    <a href="{$ADMIN_URL}product/design/{$oDesign->getId()}/" class="ls-icon-edit"></a>
                    {if LS::HasRight('29_product_design_delete')}<a href="{$ADMIN_URL}product/design/delete/{$oDesign->getId()}/" class="ls-icon-remove" onclick="return confirm('Удалить дизайн?')"></a>{/if}
                </td>
            </tr>
        {/foreach}
        </tbody>
    </table>
{/if}
{component pagination paging=$aPaging}
