<div class="cl h20"></div>
<form action="{$ADMIN_URL}analytics/manufactures/" id="analytics-filter" class="dflex">

    {component field template='date'
    label       = 'Начало периода'
    classes     = 'date'
    name        = 'date_from'
    value       = $oDateFrom->format('d.m.Y')}

    {component field template='date'
    label       = 'Окончание периода'
    classes     = 'date'
    name        = 'date_to'
    value       = $oDateTo->format('d.m.Y')}

    {component field template='select'
    classes     = 'status'
    label       = 'Статус<br>заказа'
    isMultiple  = true
    name        = 'status[]'
    selectedValue = $aStatus
    items       = Config::Get('order.status')}

    {component field template='select'
    label       = 'Фабрика<br>&nbsp;'
    classes     = 'make'
    inputClasses= 'make'
    name        = 'make_id[]'
    items       = $makeForSelect
    isMultiple  = true
    selectedValue = $makeSelected}

    {component button text='Показать' mods='primary'}
</form>