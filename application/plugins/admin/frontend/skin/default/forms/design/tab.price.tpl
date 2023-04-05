<table class="table prices">
    <tr>
        <th style="width: 200px;">Цена фабрики</th>
        <td colspan="3">{$oDesign->_getDataOne('price_make')}</td>
    </tr>
    <tr>
        <th>Наценка</th>
        <td colspan="3">
            {component field template='text'
            label   = ''
            name    = 'design[margin]'
            value   = ($oDesign) ? $oDesign->getMargin() : ''}
        </td>
    </tr>
    <tr>
        <th>Цена</th>
        <td colspan="3">{if $oDesign->getPriceOld()}{$oDesign->getPriceOld(true, true)}{else}{$oDesign->getPrice()}{/if}</td>
    </tr>
    <tr>
        <th>Скидка</th>
        <td>
            {component field template='text'
            label   = ''
            name    = 'design[discount_date]'
            note    = "Составляет: {$oDesign->getDiscount(true, true)}"
            value   = ($oDesign) ? $oDesign->_getDataOne('discount_date') : ''}</td>
        <td>
            {component field template='date'
            label       = ''
            classes     = 'date'
            name        = 'design[discount_date_from]'
            note        = 'Начало'
            inputAttributes  = ['autocomplete' => 'off']
            value       = $oDesign->getDiscountDateFrom('d.m.Y')}
        </td>
        <td>
            {component field template='date'
            label       = ''
            classes     = 'date'
            name        = 'design[discount_date_to]'
            note        = 'Окончание'
            inputAttributes  = ['autocomplete' => 'off']
            value       = $oDesign->getDiscountDateTo('d.m.Y')}
        </td>
    </tr>
    <tr>
        <th>Марж-ть</th>
        <td colspan="3">{GetPrice($oDesign->getPrice()-$oDesign->_getDataOne('price_make'), 1)}</td>
    </tr>
</table>