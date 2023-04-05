<div class="block">
    {component field template='text'
    name    = 'product[fabric1_name]'
    value   = $oProduct->getFabric1Name()|default:(($oProduct->getFabric1()) ? 'Основная ткань' : '')
    classes = 'w250'}
    {component field template='text'
    name    = 'product[fabric1]'
    value   = $oProduct->getFabric1()
    inputAttributes = ['autocomplete' => 'off']}
</div>

<div class="block">
    {component field template='text'
    name    = 'product[fabric2_name]'
    value   = $oProduct->getFabric2Name()|default:(($oProduct->getFabric2() > 0) ? 'Ткань-компаньон' : '')
    classes = 'w250'}
    {component field template='text'
    name    = 'product[fabric2]'
    value   = $oProduct->getFabric2()
    inputAttributes = ['autocomplete' => 'off']}
</div>

<div class="block">
    {component field template='text'
    name    = 'product[fabric3_name]'
    value   = $oProduct->getFabric3Name()|default:(($oProduct->getFabric3() > 0) ? '3-я ткань' : '')
    classes = 'w250'}
    {component field template='text'
    name    = 'product[fabric3]'
    value   = $oProduct->getFabric3()
    inputAttributes = ['autocomplete' => 'off']}
</div>

<div class="block">
    {component field template='text'
    name    = 'product[fabric4_name]'
    value   = $oProduct->getFabric4Name()|default:(($oProduct->getFabric4() > 0) ? '4-я ткань' : '')
    classes = 'w250'}
    {component field template='text'
    name    = 'product[fabric4]'
    value   = $oProduct->getFabric4()
    inputAttributes = ['autocomplete' => 'off']}
</div>

<label for="">Всего {$oProduct->getFabricAmount()} м.</label>