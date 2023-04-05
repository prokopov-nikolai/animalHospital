<table class="table w600">
    {foreach $aCategoryTree as $oCategory}
        <tr>
            <td>
                {if $bProductList}
                    <a href="/{Config::Get('plugin.admin.url')}/product/category/{$oCategory->getId()}/">{$oCategory->getTitle()}</a>
                {else}
                    <a href="/{Config::Get('plugin.admin.url')}/category/{$oCategory->getId()}/">{$oCategory->getTitle()}</a>
                {/if}
            </td>
            <td width="110">
                {if !$bProductList}
                    <a href="{$ADMIN_URL}category/{$oCategory->getId()}/" class="ls-icon-edit"></a> &nbsp;&nbsp;
                    <a href="{$oCategory->getUrlFull()}" target="_blank" class="ls-icon-share"></a> &nbsp;&nbsp;
                    {if LS::HasRight('34_category_delete')}
                        <a href="{$ADMIN_URL}category/delete/{$oCategory->getId()}/" class="ls-icon-remove"></a> &nbsp;&nbsp;
                    {/if}
                {/if}
            </td>
        </tr>
    {/foreach}
</table>
