{$aItems = [
    ['text' => 'Чекбоксы', 'value' => 'checkbox'],
    ['text' => 'Выпадающий список', 'value' => 'select'],
    ['text' => 'Радио кнопки', 'value' => 'radio'],
    ['text' => 'Модальное окно', 'value' => 'modal']
]}
{component 'field' template='text'
label = 'Название'
name  = 'option[title]'
value = $oOption->getTitle()}

{component 'field' template='text'
label = 'Название для клиента'
name  = 'option[alias]'
value = $oOption->getAlias()}


{component 'field' template='select'
label = 'Тип'
name  = 'option[type]'
items = $aItems
selectedValue = $oOption->getType()}