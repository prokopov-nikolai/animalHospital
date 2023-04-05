{component field template='text'
label   = 'Название коллекции'
name    = 'collection[title]'
value   = $oCollection->getTitle()}

{component field template='text'
label   = 'Url'
name    = 'collection[url]'
value   = $oCollection->getUrl()}

{component field template='select'
label   = 'Дизайн'
items   = Config::Get('design_type')
name    = 'collection[design_type][]'
isMultiple = true
selectedValue   = $oCollection->getDesignTypeArray()}
{*selectedValue   = ['Вензеля', 'Город']}*}

{component field template='text'
label   = 'Цена руб./м2'
name    = 'collection[price]'
value   = $oCollection->getPrice()}

{component field template='select'
label   = 'Поставщик'
items   = Config::Get('collection_supplier')
name    = 'collection[supplier]'
selectedValue   = $oCollection->getSupplier()}

{component field template='select'
label   = 'Тип ткани'
items   = Config::Get('collection_type')
name    = 'collection[type]'
selectedValue   = $oCollection->getType()}

{component field template='select'
label   = 'Страна производства'
items   = Config::Get('collection_country')
name    = 'collection[country]'
selectedValue   = $oCollection->getCountry()}

{component field template='text'
label   = 'Плотность ткани, г/1м2'
name    = 'collection[density]'
value   = $oCollection->getDensity()}

{component field template='text'
label   = 'Количество циклов по Мартиндейлу'
name    = 'collection[martindeil]'
value   = $oCollection->getMartindeil()}

{component field template='text'
label   = 'Состав'
name    = 'collection[composition]'
value   = $oCollection->getComposition()}