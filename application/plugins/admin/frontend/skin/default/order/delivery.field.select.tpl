{component field template='select'
name            = 'car_number'
selectedValue   = $oOrder->getCarNumber()
items           = Config::Get('car_number')
classes         = 'w120'
inputClasses    = 'ajax-save'
inputAttributes  = ['data-field' => 'car_number', 'data-order_id' => {$oOrder->getId()}]}