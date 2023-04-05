<form action="{$ADMIN_URL}order/list/" id="order-filter" class="dflex">

    <div class="row1">
        <div class="dflex">
            <div class="filter-button"></div>

            {component field template='text'
            placeholder = '№ заказа'
            classes     = 'order_number'
            name        = 'order_number'
            value       = $smarty.get.order_number}

            {component field template='text'
            placeholder = 'Телефон'
            classes     = 'phone'
            inputClasses= 'phone'
            name        = 'phone'
            value       = $sPhone}

            {component field template='select'
            placeholder = 'Менеджер'
            classes     = 'manager'
            isMultiple  = true
            name        = 'manager_id[]'
            selectedValue = $managerIdSelected
            items       = $managerSelect}

            {if $smarty.get.lost}
                <span class="h2">Вы смотрите "Потеряшки"</span>
            {else}
                <div class="ls-button orders-lost">Потеряшки</div>
            {/if}
        </div>
    </div>
    <div class="row2">
        <div class="dflex">

        {component field template='date'
        label       = 'Начало периода'
        classes     = 'date'
        name        = 'date_from'
        inputAttributes = ['autocomplete' => 'off']
        value       = ($oDateFrom) ? $oDateFrom->format('d.m.Y') : ''}

        {component field template='date'
        label       = 'Окончание периода'
        classes     = 'date'
        name        = 'date_to'
        inputAttributes = ['autocomplete' => 'off']
        value       = ($oDateTo) ? $oDateTo->format('d.m.Y') : ''}

        <div class="block date-add">
            {component field template='radio'
            label       = 'Дата добавления'
            name        = 'date_type'
            checked     = ($sDateType == 'date_add') ? true : false
            value       = 'date_add'}
            {component field template='radio'
            label       = 'Дата производства'
            name        = 'date_type'
            checked     = ($sDateType == 'date_manufactured') ? true : false
            value       = 'date_manufactured'}
            {component field template='radio'
            label       = 'Дата отгрузки'
            name        = 'date_type'
            checked     = ($sDateType == 'date_shipment') ? true : false
            value       = 'date_shipment'}
            {component field template='radio'
            label       = 'Дата доставки'
            name        = 'date_type'
            checked     = ($sDateType == 'date_delivery') ? true : false
            value       = 'date_delivery'}
        </div>

        {component field template='select'
        classes     = 'status'
        label       = 'Статус заказа'
        isMultiple  = true
        name        = 'status[]'
        selected    = $smarty.get.status
        items       = Config::Get('order.status')}

        {component field template='select'
        label       = 'Фабрика'
        classes     = 'make'
        inputClasses= 'make'
        name        = 'make_id[]'
        items       = $aMakeForSelect
        isMultiple  = true
        selectedValue = $aMakeSelected}

        {component field template='select'
        label       = 'Источник'
        classes     = 'agents'
        inputClasses= 'agents'
        name        = 'agent_id[]'
        items       = $aAgentsSelect
        isMultiple  = true
        selectedValue = $agentIdSelected}


        {component button text='Показать' mods='primary'}
        </div>
    </div>
</form>