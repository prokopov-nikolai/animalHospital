<tr class="{$oPayment->getName()}">
    <td>{$oPayment->getDate()|date_format:'d.m.Y'}</td>
    <td>{$oPayment->getTypeRu()}</td>
    <td>{$oPayment->getNameRu()}</td>
    <td>{$oPayment->getSum(true, true)}</td>
    <td>{$oPayment->getComment()}</td>
</tr>