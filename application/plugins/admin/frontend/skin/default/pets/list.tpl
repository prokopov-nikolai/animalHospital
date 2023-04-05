<table class="table">
    <tr>
        <th>id</th>
        <th>Фото</th>
        <th>Кличка</th>
        <th>Вид</th>
        <th>Хозяин</th>
        <th>Телефон</th>
        <th></th>
    </tr>

    {foreach $aPets as $oP}
        <tr>
            <td>{$oP->getId()}</td>
            <td><a href="{$ADMIN_URL}pets/{$oP->getId()}/"><img src="{$oP->getPhotoWebPath('x50')}" alt=""></a></td>
            <td><a href="{$ADMIN_URL}pets/{$oP->getId()}/">{$oP->getNickname()}</a></td>
            <td>{$oP->getSpeciesText()}</td>
            <td>{$oP->getUserFio()}</td>
            <td>{$oP->getUserPhone()}</td>
            <td>
                {if LS::HasRight('5_pets_edit')}
                    <a href="{$ADMIN_URL}pets/{$oP->getId()}/" class="ls-icon-pencil"></a>
                    <a href="{$ADMIN_URL}pets/remove/{$oP->getId()}/" class="ls-icon-remove" onclick="return confirm('Удалить?')"></a>
                {/if}
            </td>
        </tr>
    {/foreach}
</table>