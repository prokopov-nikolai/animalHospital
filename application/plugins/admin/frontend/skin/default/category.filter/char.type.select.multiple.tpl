<div class="char select dflex">
    {component field template='select'
    name    = "category_filter[chars][{$oChar->getId()}][]"
    items   = $oChar->getSelectValues()
    selectedValue = $oChar->getValue()
    id      = "char{$oChar->getId()}"
    isMultiple = true
    label   = "{$oChar->getTitle()}"}
    <div class="ls-icon-remove"></div>
</div>