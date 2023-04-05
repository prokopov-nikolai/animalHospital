<div class="tasks-filter">
    <form action="">
        {component field template='date'
        label       = 'Начало периода'
        classes     = 'date'
        name        = 'date_from'
        inputAttributes = ['autocomplete' => 'off']
        value       = ($dateFrom) ? $dateFrom->format('d.m.Y') : ''}

        {component field template='date'
        label       = 'Окончание периода'
        classes     = 'date'
        name        = 'date_to'
        inputAttributes = ['autocomplete' => 'off']
        value       = ($dateTo) ? $dateTo->format('d.m.Y') : ''}

        {component field template='select'
        label = 'Постановщик'
        classes     = 'manager'
        name        = 'manager_id'
        selectedValue = $managerIdSelected
        items       = $managerSelect}

        {component button text='Показать' mods='primary'}
    </form>
</div>