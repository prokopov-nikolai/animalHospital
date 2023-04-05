<div class="cl h20"></div>
<form action="" id="report-agent-filter" class="dflex">

    {component field template='date'
    label       = 'Начало периода'
    classes     = 'date'
    name        = 'date_from'
    classes     = 'w150'
    value       = $oDateFrom->format('d.m.Y')}

    {component field template='date'
    label       = 'Окончание периода'
    classes     = 'date'
    name        = 'date_to'
    classes     = 'w150'
    value       = $oDateTo->format('d.m.Y')}

    {component field template='select'
    label       = '&nbsp;<br>Фабрика'
    classes     = 'make'
    name        = 'make_id[]'
    items       = $aMakeForSelect
    isMultiple  = true}

    {component field template='checkbox'
    label       = 'Только неоплаченные'
    classes     = 'make_paid'
    name        = 'make_paid'}

    {component button text='Показать' mods='primary'}

</form>