<div class="dflex">
    <div class="block">
        {component field template='checkbox'
        name        = 'pickup'
        checked     = $oOrder->getPickup()
        label       = 'Самовывоз'
        inputClasses    = 'ajax-save'
        inputAttributes = ['data-field' => 'pickup', 'autocomplete' => 'off']}
        <div class="dflex">
            <div class="_item w1">
                {component field template='text'
                label           = 'Адрес'
                name            = 'order[address]'
                value           = $oOrder->getAddress()
                inputClasses    = 'ajax-save'
                id              = 'address'
                inputAttributes = ['data-field' => 'address', 'autocomplete' => 'off']}
            </div>
            <div class="_item w3">
                {component field template='text'
                label           = 'Этаж'
                name            = 'order[floor]'
                value           = $oOrder->getFloor()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'floor', 'autocomplete' => 'off']}
            </div>
            <div class="_item w3">
                {component field template='select'
                label           = 'Лифт'
                classes         = 'lift'
                items           = Config::Get('lift')
                name            = 'order[service_lift]'
                selectedValue   = $oOrder->getServiceLift()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'service_lift', 'autocomplete' => 'off']}
            </div>
            <div class="_item w3">
                {component field template='text'
                label           = '<nobr>Мин. шир. проема</nobr>'
                name            = 'order[door_width]'
                classes         = 'door_width'
                value           = $oOrder->getDoorWidth()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'door_width', 'autocomplete' => 'off']}
            </div>
            <div class="_item w3">
                {component field template='select'
                label           = 'Машина'
                name            = 'car_number'
                selectedValue   = $oOrder->getCarNumber()
                items           = Config::Get('car_number')
                inputClasses    = 'ajax-save'
                inputAttributes  = ['data-field' => 'car_number']}
            </div>
        </div>
    </div>
    <div class="block" id="map"></div>
    {$oUser = $oOrder->getUser()}
{*    <p>Анатолий, добрый день!</p>*}
{*    <p>Примите пожалуйста заказ на доставку.</p>*}
{*    <table class="table" width="600" style="color:#000; border: #000 solid 0px; border-collapse: collapse;" cellpadding="0" cellspacing="0">*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Дата доставки</td>*}
{*            <td style="border: #000 solid 1px;">{$oOrder->getDateDelivery()|date_format:'d.m.Y'}</td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Имя</td>*}
{*            <td style="border: #000 solid 1px;">{$oUser->getFio()}</td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Телефон</td>*}
{*            <td style="border: #000 solid 1px;">{$oUser->getPhone()}</td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Адрес доставки</td>*}
{*            <td style="border: #000 solid 1px;">{$oOrder->getAddress()}</td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Номер заказа</td>*}
{*            <td style="border: #000 solid 1px;"><b>{$oOrder->getAgentNumber()}</b></td>*}
{*        </tr>*}
{*        {foreach $oOrder->getProducts() as $oOrderProduct}*}
{*            <tr>*}
{*                <td style="border: #000 solid 1px;">*}
{*                    <a href="{$oOrderProduct->getMainPhotoUrl('1200x')}" target="_blank">Посмотреть фото</a><br>*}
{*                    {$oProduct = $oOrderProduct->getProduct()}*}
{*                    <b>{$oOrderProduct->getTitleFull()}</b>*}
{*                    <div style="display: flex; align-items: center;font-size: 13px; padding-top: 7px;">*}

{*                        {$oOVSize = $aUserOptionValues[3]}*}
{*                        {$iD = 0}*}
{*                        {if $oOVSize}{$iD = $oOVSize->getTitle()|replace:'см':''|intval}{/if}*}
{*                        <div class="length"><span>Длина: </span>{$oProduct->getCharValueById(1)+$iD}&nbsp;см, &nbsp;</div>*}
{*                        <div class="depth"><span>Глубина: </span>{$oProduct->getCharValueById(2)}&nbsp;см, &nbsp;</div>*}
{*                        {if $iCharHeight = $oProduct->getCharValueById(14)}*}
{*                            <div class="height"><span>Высота: </span>{$iCharHeight}&nbsp;см</div>*}
{*                        {/if}*}
{*                    </div>*}
{*                </td>*}
{*                <td style="border: #000 solid 1px;">*}
{*                    Стоимость клиента: {$oOrderProduct->getPrice(true)}<br>*}
{*                    Стоимость фабрики: {$oOrderProduct->getPriceMake(true)}<br>*}
{*                    {$iSum = $iSum + $oOrderProduct->getPrice()}*}
{*                </td>*}
{*            </tr>*}
{*        {/foreach}*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Доставка</td>*}
{*            <td style="border: #000 solid 1px;">*}
{*                {foreach $oOrder->getProducts() as $oOrderProduct}*}
{*                    {$oOrderProduct->getPriceDelivery(true)}*}
{*                    {if $oOrderProduct->getPriceDeliveryDop()}*}
{*                        + {$oOrderProduct->getPriceDeliveryDop(true)}*}
{*                    {/if}*}
{*                    {$iSum = $iSum + $oOrderProduct->getPriceDelivery() + $oOrderProduct->getPriceDeliveryDop(true)}*}
{*                {/foreach}*}
{*            </td style="border: #000 solid 1px;">*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Занос</td>*}
{*            <td style="border: #000 solid 1px;">*}
{*                {foreach $oOrder->getProducts() as $oOrderProduct}*}
{*                    {$oOrderProduct->getPriceZanosa(true)}*}
{*                    {$iSum = $iSum + $oOrderProduct->getPriceZanosa()}*}
{*                {/foreach}*}
{*            </td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Сборка</td>*}
{*            <td style="border: #000 solid 1px;">*}
{*                {foreach $oOrder->getProducts() as $oOrderProduct}*}
{*                    {$oOrderProduct->getPriceSborki()}*}
{*                    {$iSum = $iSum + $oOrderProduct->getPriceSborki()}*}
{*                {/foreach}*}
{*            </td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;">Предоплата</td>*}
{*            <td style="border: #000 solid 1px;">*}
{*                {$iPayed = 0}*}
{*                {foreach $oOrder->getPayments() as $oPayment}*}
{*                    {$iPayed = $iPayed + $oPayment->getSum()}*}
{*                {/foreach}*}
{*                {$iPayed|getPrice:true}*}
{*                {$iSum = $iSum - $iPayed}*}
{*            </td>*}
{*        </tr>*}
{*        <tr>*}
{*            <td style="border: #000 solid 1px;"><b>ИТОГО С КЛИЕНТА</b></td>*}
{*            <td style="border: #000 solid 1px;"><b>{$iSum|getPrice:true}</b></td>*}
{*        </tr>*}
{*    </table>*}
</div>