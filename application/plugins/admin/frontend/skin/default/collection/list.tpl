<table class="table collections rtable">
    <tr>
        <th>id</th>
        <th>Название</th>
        <th width="150">Тип ткани</th>
        <th width="150">Поставщик</th>
        <th width="150">Страна</th>
        <th width="150">Плотность</th>
        <th width="150">Циклы</th>
        <th width="150">Состав</th>
        <th width="150">Тип дизайна</th>
        <th width="50">Действия</th>
    </tr>
    {foreach $aCollection as $oCollection}
        <tr>
            <td>{$oCollection->getId()}</td>
            <td><a href="{$ADMIN_URL}collection/edit/{$oCollection->getId()}/">{$oCollection->getTitle()}</a></td>
            <td>{$oCollection->getTypeRu()}</td>
            <td>{$oCollection->getSupplierRu()}</td>
            <td>{$oCollection->getCountryRu()}</td>
            <td>{$oCollection->getDensity()}</td>
            <td>{$oCollection->getMartindeil()}</td>
            <td>{$oCollection->getComposition()}</td>
            <td>{$oCollection->getDesignType()}</td>
            <td>
                <a class="ls-icon-edit" href="{$ADMIN_URL}collection/edit/{$oCollection->getId()}/"></a>&nbsp;&nbsp;&nbsp;&nbsp;
                {if LS::HasRight('10_collection_delete')}<a class="ls-icon-remove" href="{$ADMIN_URL}collection/delete/{$oCollection->getId()}/" onclick='return confirm("Удалить? Уверены? \nРекомендуем скрыть коллекцию!");'></a>{/if}
            </td>
        </tr>
    {/foreach}
    {if !$aCollection|count}
        <tr>
            <td colspan="5">Пусто</td>
        </tr>
    {/if}
</table>