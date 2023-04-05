<form action="" class="dflex filter">
    {component field template='select'
    label   = 'Поставщик'
    classes = 'w250'
    items   = Config::Get('collection_supplier')
    name    = 'supplier'
    selectedValue   = $smarty.get.supplier}
    {component button text='Показать' classes='mt25'}
</form>