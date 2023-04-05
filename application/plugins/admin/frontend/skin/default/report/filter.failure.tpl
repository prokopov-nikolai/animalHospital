<div class="cl h20"></div>
<form action="" id="report-cost-filter" class="dflex">

    {component field template='date'
    label       = 'Начало периода'
    classes     = 'date'
    name        = 'date_from'
    value       = $dateFrom->format('d.m.Y')}

    {component field template='date'
    label       = 'Окончание периода'
    classes     = 'date'
    name        = 'date_to'
    value       = $dateTo->format('d.m.Y')}

    {component field template='select'
    label       = 'Cтатус'
    classes     = '_item'
    name        = 'type[]'
    inputClasses = 'cost-type'
    items       = $statusItems
    selectedValue = $statusFailure
    isMultiple  = true
    classes     = 'w200'}

    {component field template='select'
    label       = 'Фабрика'
    classes     = 'make'
    inputClasses= 'make'
    name        = 'make_id[]'
    items       = $makeForSelect
    isMultiple  = true
    selectedValue = $aMakeSelected}

    {component field template='select'
    label       = 'Менеджер'
    classes     = '_item manager'
    name        = 'manager_id'
    items       = $managerItems}

    {component field template='text'
    label       = 'Товар'
    name        = 'product'
    classes     = 'autocomplete-pro-item'
    inputClasses = 'autocomplete-pro product'
    value = ($product->getId()) ? $product->getTitleFull() : ''}

    <input type="hidden" id="product-id" name="product_id" value="{$product->getId()}">

    <div class="w250" style="padding-top: 25px;">
        {component button text='Показать'}
    </div>
</form>

<div class="cl h20"></div>