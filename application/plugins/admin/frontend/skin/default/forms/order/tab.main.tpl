<div class="dflex">
    <div class="block pb-0">
        <h2>Контактная информация</h2>
        {$oUser = $oOrder->getUser()}
        <div class="dflex">
            <div class="_item w253 pr-0 h77">
                {if $oUser->getPhone()}
                    {component field template='text'
                        name            = "user[phone]"
                        label           = 'Телефон'
                        value           = $oUser->getPhone()
                        classes         = 'user-phone-auto'
                        inputClasses    = 'phone autocomplete-pro'
                        inputAttributes = [
                        'data-field' => 'phone',
                        'data-confirm' => 'Подтвердить изменение?',
                        'autocomplete' => 'off'
                        ]
                        type            = 'tel'}
                <div class="ls-field  ls-clearfix user-phone">
                    <a href="https://t.me/+7{$oUser->getPhone()}" class="telegram" target="_blank"></a>
                    <a href="https://wa.me/7{$oUser->getPhone()}?text={$oUser->getFio()}, добрый день!" class="whatsapp" target="_blank"></a>
                </div>
                {else}
                    {component field template='text'
                    name            = "user[phone]"
                    label           = 'Телефон'
                    value           = $oUser->getPhone()
                    inputClasses    = 'ajax-save'
                    inputAttributes = [
                    'data-field' => 'phone',
                    'data-confirm' => 'Подтвердить изменение?',
                    'autocomplete' => 'off'
                    ]
                    type            = 'tel'}
                {/if}
            </div>
            <div class="_item pr-0 h77">
                {component field template='text'
                name            = "user[phone_dop]"
                label           = 'Доп. телефон'
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'phone_dop']
                value           = $oUser->getPhoneDop()}
            </div>
            <div class="_item pr-0 h77">
                {component field template='text'
                name            = "user[fio]"
                label           = 'Имя'
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'fio']
                value           = $oUser->getFio()}
            </div>
            <div class="_item pr-0 h77">
                {component field template='text'
                name            = "user[email]"
                label           = 'Email'
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'email']
                value           = $oUser->getEmail()
                type            = 'email'}
            </div>
            {if is_array($userOrders) &&  count($userOrders) > 1}
                <div class="_item order-notice bg-red red"><a href="{$ADMIN_URL}order/{$oOrder->getId()}/#tab7" onclick="$($('.ls-tab-list .ls-tab')[7]).trigger('click'); return false;">Предыдущие заказы ({count($userOrders)-1})</a></div>
            {/if}
            <div class="_item w1 pt-20">
                {component field template="textarea"
                rows            = 2
                inputClasses    = 'manager-comment'
                placeholder     = 'Комментарий для менеджера'
                value           = $oOrder->getLastCommentText()}
            </div>
        </div>
    </div>
    <div class="block pb-0">
        <div class="dflex block-agent-manager">
            <div class="_item w2">
                <h3>Источник</h3>
                {$oUserAgent = $oOrder->getAgent()}
                {component field template='select'
                label       = ''
                name        = 'agent_id'
                selectedValue = $oOrder->getAgentId()
                items       = $aAgentsSelect
                inputClasses    = "ajax-save {(!$oOrder->getAgentId() || !in_array($oOrder->getAgentId(), array_keys($aAgentsSelect))) ? 'ls-error' : ''}"
                classes = 'agent-id'
                inputAttributes = ['data-field' => 'agent_id']}
            </div>
            <div class="_item w2">
                <h3>Менеджер</h3>
                {$oUserAgent = $oOrder->getAgent()}
                {component field template='select'
                label       = ''
                name        = 'manager_id'
                selectedValue = $oOrder->getManagerId()
                items       = $aManagersSelect
                inputClasses    = "ajax-save {(!$oOrder->getManagerId() || !in_array($oOrder->getManagerId(), array_keys($aManagersSelect))) ? 'ls-error' : ''}"
                classes = 'agent-id'
                inputAttributes = ['data-field' => 'manager_id']}
            </div>
        </div>
        <div class="dflex">
            <div class="_item w1 avito-chat-link">
                {component field template = 'text'
                label       = 'Ссылка на чат '
                name        = 'avito_chat_link'
                value = $oOrder->getAvitoChatLink()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'avito_chat_link']}
                <a href="{$oOrder->getAvitoChatLink()}" target="_blank" class="link-blank"></a>

            </div>
            <div class="_item w1">
                {component field template = 'text'
                label       = 'Дополнительный чат '
                name        = 'dop_chat'
                value = $oOrder->getDopChat()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'dop_chat']}
            </div>
        </div>
    </div>
    <div class="block w1 block-products">
        <h2>Товары</h2>
        <table class="table products rtable">
            <tr>
                <th width="20" rowspan="2">#</th>
                <th rowspan="2">Наименование</th>
                <th rowspan="2">Фабрика<br>производитель</th>
                <th {if LS::HasRight('38_order_margin_view')} colspan="2"{/if}>ТОВАР</th>
                <th colspan="2">Услуги</th>
                <th rowspan="2">Кол-во</th>
                <th rowspan="2" class="{if !LS::HasRight('38_order_margin_view')} hide{/if}">Агентские</th>
                {if LS::HasRight('40_order_product_delete')}<th rowspan="2"></th>{/if}
            <tr>
                <th>Цена<br>клиента</th>
                <th class="{if !LS::HasRight('38_order_margin_view')} hide{/if}">Цена<br>фабрики</th>
                <th>Сумма<br>клиента</th>
                <th>Сумма<br>Эксп-в</th>
            </tr>
            {foreach from=$oOrder->getProducts() item='oOrderProduct' name="products"}
                {$bIsDisabled = false}
                {* Дисейблим заказа если доставлен *}
                {if $oOrder->getStatus() == 'delivered'}{$bIsDisabled = true}{/if}
                <tr class="order-product"
                    data-product-design-id="{$oOrderProduct->getProductDesignId()}"
                    data-order-product-id="{$oOrderProduct->getId()}"
                    data-product-id="{$oOrderProduct->getProductId()}"
                >
                    <td class="number">{$smarty.foreach.products.index+1}</td>
                    <td class="title">
                        {$oOrderProduct->getTitleFull()}
                        <div class="fabrics">
                            {foreach [1,2,3,4] as $iNum}
                                {if $oOrderProduct->getFabricLength($iNum) > 0}
                                    {if $iNum > 1} // {/if}
                                    <div class="fabric fabric{$iNum}">{if $oFabric = $oOrderProduct->getFabric($iNum)}{$oFabric->getAlt()} ({$oFabric->getSupplier()}){/if}</div>
                                    <div class="edit ls-icon-pencil" data-num="{$iNum}"></div>
                                {/if}
                            {/foreach}
                        </div>
                        <div class="options">
                            {$aUserOptionValues = $oOrderProduct->getUserOptionValuesEntity()}
                            {if $orderProduct = $oOrderProduct->getProduct()}
                                {foreach $orderProduct->getOptions() as $oOption}
                                    {if $oOV = $aUserOptionValues[$oOption->getId()]}
                                        <div class="option dflex" data-id="{$oOption->getId()}">
                                            <div class="_title">{$oOV->getAlias()}:</div>
                                            {$oOVM = $oOV->getImage()}
                                            {if $oOVM}<img src="{$oOVM->getFileWebPath('126x126crop')}" alt="">{/if}
                                            <div class="_name">{$oOV->getTitle()} (+{if $oOV->getMargin() != 0 && $oOV->getMargin() < 100}{(int)$oOV->getMargin()}{else}{GetPrice($oOV->getMargin(), true, true)}{/if})</div>
                                            <div class="ls-icon-remove remove"></div>
                                        </div>
                                    {/if}
                                {/foreach}
                            {/if}
                        </div>
                        <div class="ls-button options-edit">Редактировать опции</div>
                        {if $oOrderProduct->getMakePaid()}
                            <span class="make-paid checkbox-blue" title="Агентские получены"></span>
                        {/if}
                        {if $oOrderProduct->getManagerPaid()}
                            <span class="manager-paid checkbox-green" title="Менеджерские выплачены"></span>
                        {/if}
                    </td>
                    <td class="make_id">
                        {if $oOrderProduct->getMakeId()}
                            {$classes = 'ajax-save'}
                        {else}
                            {$classes = 'ajax-save _error'}
                        {/if}
                        {component field template='select'
                        label       = ''
                        name        = 'make_id'
                        selectedValue = $oOrderProduct->getMakeId()
                        items       = $aMakeSelect
                        inputClasses    = $classes
                        inputAttributes = ['data-field' => 'make_id']}
                    </td>
                    <td class="data nobr no-border-right">
                        ({if $bIsDisabled}
                            {$oOrderProduct->getPrice()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price]"
                            inputClasses    = 'ajax-save'
                            inputAttributes = ['data-field' => 'price']
                            value           = $oOrderProduct->getPrice()}
                        {/if}
                    </td>
                    <td class="data nobr no-border-left no-border-right{if !LS::HasRight('38_order_margin_view')} hide{/if}">
                        - &nbsp;{if $bIsDisabled}
                            {$oOrderProduct->getPriceMake()}
                        {else}
                            {component field template='text'
                            name            = "order_products[{$oOrderProduct->getProductId()}][price_make]"
                            inputClasses    = 'ajax-save price-make'
                            inputAttributes = ['data-field' => 'price_make']
                            value           = $oOrderProduct->getPriceMake()}
                        {/if}
                    </td>
                    <td class="data nobr price-services-amount no-border-left no-border-right">
                        + &nbsp;<span>{$oOrderProduct->getPriceServicesAmount()}</span>
                    </td>
                    <td class="data nobr price-services-amount-make no-border-left">
                        - &nbsp;<span>{$oOrderProduct->getPriceServicesAmountMake()}</span> &nbsp;)
                    </td>
                    <td class="data nobr">
                        &nbsp;x &nbsp;{component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}][count]"
                        classes    = 'count'
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'count']
                        value           = $oOrderProduct->getCount()}
                    </td>
                    <td class="data nobr agent-commission{if !LS::HasRight('38_order_margin_view')} hide{/if}">
                        = &nbsp;<span>{$oOrderProduct->getAgentCommission()|default:'-'}</span>
                    </td>
                        <td>
                            {if $oOrderProduct->getRepair()}
                                Ремонт от {$oOrderProduct->getDateRepairFormat()}<br>&nbsp;
                            {else}
                                <div class="ls-button" onclick="if (confirm('Пометить товар \'{$oOrderProduct->getTitleFull()}\' как ремонтируемый?')) ProductRepair({$oOrderProduct->getId()}); return false;">В ремонт</div>
                            {/if}

                            {if LS::HasRight('40_order_product_delete')}
                                <br><a href="{$ADMIN_URL}order/product/delete/{$oOrderProduct->getId()}/" class="ls-button" onclick="return confirm('Удалить товар \'{$oOrderProduct->getTitleFull()}\'?')">Удалить</a>
                            {/if}
                        </td>
                </tr>
            {/foreach}
            <tr>
                <th colspan="{if !LS::HasRight('38_order_margin_view')}6{else}8{/if}">Скидка</th>
                <th>{component field template='text'
                    name            = "order[discount]"
                    inputClasses    = 'ajax-save'
                    inputAttributes = ['data-field' => 'discount']
                    value           = $oOrder->getDiscount()}</th>
                {if LS::HasRight('40_order_product_delete')}<th rowspan="2"></th>{/if}
            </tr>{$margin = $oOrder->getMargin()}
            <tr class="{if $margin < 2000}red bg-red{/if}{if !LS::HasRight('38_order_margin_view')} hide{/if}">
                <th colspan="8">Маржинальность</th>
                <th class="order-margin">{$margin}</th>
            </tr>
        </table>
        <span class="ls-button" id="product-add">Добавить товар</span>
    </div>
    <div class="block w1">
        <h2>Комментарий к заказу</h2>
        {component field template="textarea"
        name            = 'order[comment]'
        rows            = 7
        inputClasses    = 'ajax-save'
        inputAttributes = ['data-field' => 'comment']
        value           = $oOrder->getComment()}
    </div>

    {$discountItem = floor($oOrder->getDiscount()/$oOrder->getProductCount())}
    {if LS::HasRight('38_order_margin_view')}
    <table class="table" style="font-family: Arial; color: #000; border: #000 solid 1px;">
        {foreach from=$oOrder->getProducts() item='oOrderProduct' name="products"}
            <tr>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrder->getAgentNumber()}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrder->getDateAdd('d.m.Y')}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrder->getDateDelivery('d.m.Y')}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrder->getDateDelivery('m')}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrder->getDateDelivery('Y')}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrderProduct->getProductTitleFull()}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrderProduct->getMakeTitle()}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{($oOrderProduct->getPrice()-$discountItem)*$oOrderProduct->getCount()}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrderProduct->getPriceMake()*$oOrderProduct->getCount()}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrder->getStatusRu()}</td>
                <td style="font-size: 10pt!important; border: #000 solid 1px;">{if $agent = $oOrder->getAgent()}{$agent->getFio()}{/if}</td>
                <td class="{if !LS::HasRight('38_order_margin_view')} hide{/if}" style="font-size: 10pt!important; border: #000 solid 1px;">{$oOrderProduct->getAgentCommission()-$discountItem*$oOrderProduct->getCount()}</td>
            </tr>
        {/foreach}
    </table>
    {/if}
    <div class="cl h50" style="border-bottom: #000 solid 1px;"></div>
    <div class="letter">
        {foreach $oOrder->getProducts() as $oOrderProduct}
            {$amount = ($oOrderProduct->getPrice()-$discountItem)*$oOrderProduct->getCount()}
            {$aUserOptionValues = $oOrderProduct->getUserOptionValuesEntity()}
            {$oProduct = $oOrderProduct->getProduct()}
            {if $oProduct}
                {$discountItem = floor($oOrder->getDiscount()/$oOrder->getProductCount())}
                <p>Добрый день.</p>
                <p>Заказ №{$oOrder->getAgentNumber()} {$oOrderProduct->getProductTitleFull()}</p>
                <p>
                    <b>Количество:</b> {$oOrderProduct->getCount()}шт.<br>
                    <b>Ткань:</b> {foreach [1,2,3,4] as $iNum}
                    {if $oOrderProduct->getFabricLength($iNum) > 0}
                        {if $iNum > 1} // {/if}
                        {if $oFabric = $oOrderProduct->getFabric($iNum)}{$oFabric->getAlt()} ({$oFabric->getSupplier()}){/if}
                    {/if}
                    {/foreach}
                    <br>
                    {$oOVSize = $aUserOptionValues[3]}
                    {$iD = 0}
                    {if $oOVSize}{$iD = $oOVSize->getTitle()|replace:'см':''|intval}{/if}
                    <b>Габариты (ШхГ):</b> {$oProduct->getCharValueById(1)+$iD} x {$oProduct->getCharValueById(2)} см<br>
                    {$sMehanizm = $oProduct->getCharValueById(5)}
                    {if in_array($sMehanizm, ['akkordeon-evro', 'akkordeon', 'karavan', 'francuzskaya-raskladushka', 'belgiyskaya-raskladushka'])}
                        {$iCharSlDepth = $oProduct->getCharValueById(3)|intval+$iD}
                        {$iCharSlWidth = $oProduct->getCharValueById(4)}
                    {elseif in_array($sMehanizm, ['delfin', 'evroknizhka', 'knizhka', 'tik-tak'])}
                        {$iCharSlDepth = $oProduct->getCharValueById(3)}
                        {$iCharSlWidth = $oProduct->getCharValueById(4)|intval+$iD}
                    {else}
                        {$iCharSlDepth = $oProduct->getCharValueById(3)}
                        {$iCharSlWidth = $oProduct->getCharValueById(4)}
                        {if $iCharSlDepth || $iCharSlWidth}
                            <p>Проверьте габариты и ширину спального места. В данном случае изменение размера учтено неверно.</p>
                        {/if}
                    {/if}
                    {if $iCharSlDepth && $iCharSlWidth}
                        <b>Спальное место (ШхД):</b> {$iCharSlDepth} x {$iCharSlWidth} см <br>
                    {/if}
                    {if $aUserOptionValues|count}
                        <b>Опции</b>:<br>
                        {foreach $aUserOptionValues as $option}
                            <span style="font-size: 14px;">{$option->getAlias()} {$option->getTitle()}</span><br>
                        {/foreach}
                        <br>
                    {/if}
                    <b>Стоимость:</b>  <span style="font-size: 20px; font-weight: bold;">{(($oOrderProduct->getPrice()-$discountItem)*$oOrderProduct->getCount())|GetPrice:1:1}</span> {if LS::HasRight('38_order_margin_view')}({($oOrderProduct->getPriceMake()*$oOrderProduct->getCount())|GetPrice:1:1}){/if}<br>
                    <b>Имя клиента:</b> {$oOrder->getUser()->getFio()}<br>
                    <b>Телефон клиента:</b> {$oOrder->getUser()->getPhone(true)}<br>
                    {if $oOrder->getUser()->getPhoneDop()}
                        <b>Доп. телефон клиента:</b> {$oOrder->getUser()->getPhoneDop(true)}<br>
                    {/if}
                </p>
                <p>
                    <b>Адрес доставки:</b> {$oOrder->getAddress()}<br>
                    <b>Дата доставки:</b> {$oOrder->getDateDelivery('d.m.Y')}<br>
                    <b>Доставка по Москве:</b> {($oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount())|GetPrice:true:true}<br>
                    {$amount = $amount + $oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount()}
                    <b>Доставка за МКАД:</b> {($oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount())|GetPrice:true:true}<br>
                    {$amount = $amount + $oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount()}
                    <b>Стоимость заноса:</b> {($oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount())|GetPrice:true:true}<br>
                    {$amount = $amount + $oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount()}
                    <b>Стоимость сборки:</b> {($oOrderProduct->getPriceSborki()*$oOrderProduct->getCount())|GetPrice:true:true}<br>
                    {$amount = $amount + $oOrderProduct->getPriceSborki()*$oOrderProduct->getCount()}
                </p>

                <p style="font-size: 20px;">Итого: <b>{$amount|GetPrice:true:true}</b></p>
                <p class="{if !LS::HasRight('38_order_margin_view')} hide{/if}">
                    <b>Агентcкие:</b> {($oOrderProduct->getAgentCommission()-$discountItem*$oOrderProduct->getCount())|GetPrice:1:1}<br>
                </p>
            {/if}
            <div class="cl h20" style="border-bottom: #000 solid 1px;"></div>
        {/foreach}
    </div>

    <div class="cl h50" style="border-bottom: #000 solid 1px;"></div>
    <div class="letter">
        <p>{$oOrder->getUser()->getFio()}, добрый день!</p>
        {$amount = 0}
        {foreach $oOrder->getProducts() as $oOrderProduct}
            <p>Стоимость<span style="font-size: 13px; font-weight: bold;">[1]</span> товар{if $oOrderProduct->getCount()}а{else}ов{/if} «{$oOrderProduct->getProductTitleFull()}» составит <b>{(($oOrderProduct->getPrice()-$discountItem))|GetPrice:1:1}</b><br>
            Количество товара: <b>{$oOrderProduct->getCount()}шт.</b><br>
            {$amount = $amount + ($oOrderProduct->getPrice()-$discountItem)*$oOrderProduct->getCount()}
            Плановая дата доставки<span style="font-size: 13px; font-weight: bold;">[2]</span>: <b>{$oOrder->getDateDelivery()|date_format:'d.m.Y'}</b><br>
            Гарантия производителя: {$oOrderProduct->getMakeGuaranty()} месяцев с даты покупки.</p>

            <p><u>Дополнительные услуги, оплачиваемые отдельно:</u><br>
            Доставка по Москве:<b> {($oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount())|GetPrice:true:true}</b><br>
            {$amount = $amount + $oOrderProduct->getPriceDelivery()*$oOrderProduct->getCount()}
            Доставка за МКАД:<b> {($oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount())|GetPrice:true:true}</b><br>
            {$amount = $amount + $oOrderProduct->getPriceDeliveryDop()*$oOrderProduct->getCount()}
            Занос в квартиру:<b> {($oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount())|GetPrice:true:true}</b><br>
            {$amount = $amount + $oOrderProduct->getPriceZanosa()*$oOrderProduct->getCount()}
            Стоимость сборки:<b> {($oOrderProduct->getPriceSborki()*$oOrderProduct->getCount())|GetPrice:true:true}</b><br>
            {$amount = $amount + $oOrderProduct->getPriceSborki()*$oOrderProduct->getCount()}
        {/foreach}

        <p>Оплата наличными при получении.</p>

        <p style="font-size: 20px;"><b>Итого к оплате:  {$amount|GetPrice:1:1}.</b></p>
        <p style="font-size: 20px; font-weight: bold;">Телефон для связи с нами: <b>{$phoneManager}</b></p>
        <h3 style="text-decoration: underline;">Дополнительные условия и примечания</h3>
        <p>Пожалуйста прочитайте внимательно и задайте вопросы в случае их появления.</p>
        <p>[1] <i>Стоимость товара</i> - стоимость товара является предварительной и может быть изменена после передачи заказа на фабрику. В случае изменения стоимости товара она будет дополнительно согласована с заказчиком.</p>
        <p>[2] <i>Плановая дата доставки</i> - дата доставки является плановой и не является окончательной. Дата доставки может быть изменена по согласованию с клиентов и не может быть назначена позже чем на три недели от первоначально согласованной.</p>
        <p>&nbsp;</p>
        <ul style="list-style: disc; padding-left: 15px;">
            <li>Обращаем ваше внимание, что реальный оттенок ткани, может отличаться от представленных на фото, из за цветопередачи экрана.</li>
            <li>При получении мебели необходимо обязательно <u>до момента заноса в квартиру (дом)</u> проверить комплектность товара, отсутствие видимых механических повреждений, цвет изделия.</li>
            <li>Отличие оттенков от представленных на фото, не является заводским браком.</li>
            <li>Товар изготовленный в ткани на заказ ткани или с индивидуальным размером, является нестандартным, обмену и возврату без наличия заводских дефектов не подлежит.</li>
            <li>Возврат не понравившегося изделия составляет 6000 рублей + стоимость доставки за МКАД</li>
            <li>Доставка до подъезда считается доставка до места возможного проезда автомобиля.</li>
            <li>В случае невозможного проезда автомобиля к подъезду или запрета на проход через подъезд к лифту (паркинг или пешеходная зона), пронос до лифта оплачивается отдельно по договоренности с экспедиторами.</li>
            <li>Возврат дивана, без наличия заводского дефекта, возможен в течении 7 дней.</li>
        </ul>
    </div>

</div>

{include file="{$aTemplatePathPlugin.admin}modal/modal.product.search.tpl"}

{capture name="scripts"}
    <script>
        $('select[name="make_id"]').on('change', function(){
            $(this).parents('.ls-field-holder').find('.select-stylized ._selected').removeClass('_error');
        });
        $('.avito-chat-link .ajax-save').on('change', function(){
          $(this).parents('.avito-chat-link').find('a').html($(this).val()).attr('href', $(this).val());
        });
        let iOrderProductId = 0;
        $('.options-edit').on('click', function(){
          iOrderProductId = parseInt($(this).parents('.order-product').data('order-product-id'));
          ls.ajax.load(ADMIN_URL+'order/ajax/product/options-html/',{
            iOrderProductId: iOrderProductId
          }, function(answ){
            $('#modal-options .modal-content').html(answ.sHtml);
            $('#modal-options select').selectStylized();
            ModalShow($('#modal-options'));
            $('#modal-options .save').on('click', function(){
              let aUserProductOptions = $('#modal-options .modal-content form').serializeArray();
              ls.ajax.load(ADMIN_URL+'order/ajax/product/options/update/',{
                iOrderProductId: iOrderProductId,
                aUserProductOptions: aUserProductOptions
              }, function(answ){
                window.location.reload();
              });
            });
            $('#modal-options .option ._remove').on('click', function() {
              $(this).parents('.option').remove();
            });
          });

        })

        $('#product-add').on('click', function(){
          ModalShow($('#modal-product-search'));
        });
        $('input[name="user[phone_dop]"]').mask('+7 (999) 999-99-99');

        /**
         * Поиск клиента
         */
        $('.phone.autocomplete-pro').autocompletePro({
            name: 'users',
            name_search: 'search',
            url: ADMIN_URL+'user/ajax/search/',
            minLength: 1,
            render: function (obj) {
                let item =
                    '<div class="row" data-id="' + obj.id + '" data-fio="' + obj.fio + '">' +
                    '<span>' + obj.fio + ' <br><span>' + obj.phone + ' // ' + obj.email + '</span> ' +
                    '</div>';
                return item;
            }
        }, function (obj, item)
        {
            if (obj.id == 'add') {
                if (confirm('Вы действительно хотите добавить нового пользователя с телефоном '+obj.phone+'?')) {
                    ls.ajax.load(ADMIN_URL + 'user/ajax/add/', {
                        sPhone: obj.phone,
                    }, function (answ) {
                        ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
                            iOrderId: {$oOrder->getId()},
                            sOrderProductDesignId: null,
                            sField: 'user_id',
                            sValue: answ.iUserId
                        }, function (answ) {
                            OrderDataUpdate(answ);
                            $('.phone.autocomplete-pro').val(answ.phone);
                            $('input[name="user[fio]"]').val(answ.fio);
                            $('input[name="user[email]"]').val(answ.email);
                            window.location.reload();
                        });
                    });
                }
            } else {
                ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
                    iOrderId: {$oOrder->getId()},
                    sOrderProductDesignId: null,
                    sField: 'user_id',
                    sValue: obj.id
                }, function (answ) {
                    OrderDataUpdate(answ);
                    $('.phone.autocomplete-pro').val(answ.phone);
                    $('input[name="user[fio]"]').val(answ.fio);
                    $('input[name="user[email]"]').val(answ.email);
                    window.location.reload();
                });
            }
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}