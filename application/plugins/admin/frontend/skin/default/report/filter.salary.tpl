<div class="cl h20"></div>
<form action="" id="report-salary-filter" class="dflex">

    {component field template='select'
    label       = 'Месяц'
    classes     = 'date'
    name        = 'date'
    items       = $monthItems
    classes     = 'w200'}

    {component field template='select'
    label       = 'Менеджер'
    classes     = 'manager_id'
    name        = 'manager_id'
    items       = $managerItems
    classes     = 'w200'}

    <div class="w250" style="padding-top: 27px;">
        {component button text='Показать'}
    </div>
</form>

<div class="cl h20"></div>