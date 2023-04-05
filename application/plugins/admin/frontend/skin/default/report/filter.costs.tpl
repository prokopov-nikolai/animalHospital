<div class="cl h20"></div>
<form action="" id="report-cost-filter" class="dflex">

    {component field template='select'
    label       = 'Месяц'
    classes     = 'date'
    name        = 'date'
    items       = $monthsItems
    classes     = 'w150'}

    {component field template='select'
    label       = 'Тип'
    classes     = '_item'
    name        = 'type'
    inputClasses = 'cost-type'
    items       = $costItems
    classes     = 'w150'}

    <div class="w250" style="padding-top: 25px;">
        {component button text='Показать'}
    </div>
</form>

<div class="cl h20"></div>