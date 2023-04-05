<div class="char number dflex">
    {component field template='text'
    name    = "category_filter[chars][{$oChar->getId()}][from]"
    label   = "{$oChar->getTitle()} ({$oChar->getUnit()}) ОТ"
    value   = $oChar->getValueFrom()}
    {component field template='text'
    name    = "category_filter[chars][{$oChar->getId()}][to]"
    label   = "{$oChar->getTitle()} ({$oChar->getUnit()}) ДО"
    value   = $oChar->getValueTo()}
    <div class="ls-icon-remove"></div>
</div>