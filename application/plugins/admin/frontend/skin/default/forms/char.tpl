<form action="" method="post" enctype="multipart/form-data" id="form-char-{$bAction}" class="w600">

    {* Группа *}
    {component field template='select'
        items           = [
            ['text' => 'Размеры', 'value' => 'Размеры'],
            ['text' => 'Наполнение и материалы', 'value' => 'Наполнение и материалы'],
            ['text' => 'Внешний вид', 'value' => 'Внешний вид'],
            ['text' => 'Доставка', 'value' => 'Доставка'],
            ['text' => 'Прочее', 'value' => 'Прочее'],
            ['text' => '---', 'value' => '']
        ]
        label           = 'Группа характеристик'
        name            = 'char[group_title]'
        selectedValue   = {($oChar) ? $oChar->getGroupTitle() : ''}
    }

    {* Название *}
    {component field template='text'
    name        = 'char[title]'
    label       = 'Название'
    value       = {($oChar) ? $oChar->getTitle() : ''}}

    {* url *}
    {component field template='text'
    name        = 'char[url]'
    label       = 'Урл'
    value       = {($oChar) ? $oChar->getUrl() : ''}}

    {* Тип *}
    {$aItems = ['1' =>'1']}
    {component field template='select'
    name        = 'char[type]'
    label       = 'Тип'
    items       = Config::Get('char_type')
    selectedValue = {($oChar) ? $oChar->getType() : ''}}

    {* Еденица измерения *}
    {component field template='text'
    name        = 'char[unit]'
    label       = 'Еденица измерения'
    value       = {($oChar) ? $oChar->getUnit() : ''}}

    {* Сортировка *}
    {component field template='text'
    name        = 'char[sort]'
    label       = 'Сортировка'
    value       = {($oChar) ? $oChar->getSort() : 100}}

    {* Значения *}
    {component field template='textarea'
    name        = 'char[vals]'
    label       = 'Значения'
    iRows        = 10
    value       = {($oChar) ? $oChar->getValsText() : ''}}

    {component button text='Сохранить'}
</form>
