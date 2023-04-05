<div class="cl h20"></div>
<form action="{$ADMIN_URL}analytics/agents/" id="analytics-filter" class="dflex">

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
    label       = 'Статус заказа'
    isMultiple  = true
    name        = 'status[]'
    selectedValue = $aStatus
    items       = Config::Get('order.status')}

    <div class="block date-add">
        &nbsp;<br>
        {component field template='radio'
        label       = 'Количество'
        name        = 'filter_type'
        checked     = ($sFilterType == 'count') ? true : false
        value       = 'count'}
        {component field template='radio'
        label       = 'Выручка'
        name        = 'filter_type'
        checked     = ($sFilterType == 'sum') ? true : false
        value       = 'sum'}
    </div>

    {component button text='Показать' mods='primary'}
</form>