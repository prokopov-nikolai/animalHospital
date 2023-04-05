{*<div class="block">*}
{*    <h2>Оплата</h2>*}
{*    <div class="dflex payments">*}
{*        <div class="_item">*}
{*            <div class="cash">Наличными</div>*}
{*        </div>*}
{*    </div>*}
{*</div>*}
<button class="btn" id="payment-add">Добавить</button>
{component field template='checkbox'
name        = 'make_paid'
checked     = $oOrder->getMakePaid()
label       = 'Агентские выплачены'
inputClasses    = 'ajax-save'
isDisabled    = $oOrder->getMakePaid()
inputAttributes = ['data-field' => 'make_paid']}

{component field template='checkbox'
name        = 'manager_paid'
checked     = $oOrder->getManagerPaid()
label       = 'ЗП менеджеру выплачена'
inputClasses    = 'ajax-save'
isDisabled    = $oOrder->getManagerPaid()
inputAttributes = ['data-field' => 'manager_paid']}

<div class="cl h20"></div>
<table class="table" id="payments">
    <tbody>
    <tr>
        <th>Дата</th>
        <th>Тип</th>
        <th>Назначение</th>
        <th>Сумма</th>
        <th>Комментарий</th>
    </tr>
    {$iPayed = 0}
    {foreach $oOrder->getPayments() as $oPayment}
        {include file="{$aTemplatePathPlugin.admin}forms/order/tab.payments.table.tr.tpl"}
        {$iPayed = $iPayed + $oPayment->getSum()}
    {/foreach}
    </tbody>
</table>

<div class="cl" style="height: 20px;"></div>
Оплачено {GetPrice($iPayed, true, true)} //  Требуется доплатить {GetPrice($oOrder->getPrice()-$iPayed, true, true)}

