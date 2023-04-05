<tr class="{($oComment->getSystem()) ? 'system' : ''}{if $oComment->getSystem() == 2 && !LS::HasRight('38_order_margin_view')} hide{/if}">
    <td>{$oComment->getDate('d.m.Y в H:i')}</td>
    <td>{$oComment->getUserFio()}</td>
    <td>{$oComment->getText()}</td>
</tr>