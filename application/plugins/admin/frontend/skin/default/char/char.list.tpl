<table class="table">
    <tbody class="sortable">
    <tr>
        <th>id</th>
        <th>Группа</th>
        <th>Название</th>
        <th>Ед.изм.</th>
        <th>Тип</th>
        <th>Значения</th>
        <th>Сортировка</th>
        <th width="50">Действия</th>
    </tr>
    {foreach $aChar as $oChar}
    <tr class="char" data-id="{$oChar->getId()}">
        <td>{$oChar->getId()}</td>
        <td>{$oChar->getGroupTitle()}</td>
        <td>{$oChar->getTitle()}</td>
        <td>{$oChar->getUnit()}</td>
        <td>{$oChar->getTypeRu()}</td>
        <td>{$oChar->getValsText()|nl2br}</td>
        <td>{$oChar->getSort()}</td>
        <td>
            <a href="{$ADMIN_URL}char/edit/{$oChar->getId()}/" class="ls-icon-edit" title="Редактировать"></a> &nbsp;&nbsp;
            <a href="{$ADMIN_URL}char/delete/{$oChar->getId()}/" class="ls-icon-remove" title="Удалить" onclick="return confirm('Удалить? Будут удалены и значения!')"></a>
        </td>
        {/foreach}
    </tbody>
</table>

{capture name='script'}
    <script>
        $(function () {
            $('.sortable').sortable({
                stop: function () {
                    var aChar = [];
                    $('.char').each(function () {
                        aChar.push($(this).data('id'));
                    });
                    ls.ajax.load(ADMIN_URL + 'char/ajax/sort/', {
                        sort: aChar,
                    });
                }
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}