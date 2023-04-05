<div class="char text dflex">
    {component field template='text'
    name    = "category_filter[chars][{$oChar->getId()}]"
    label   = "{$oChar->getTitle()} ({$oChar->getUnit()})"
    value   = $oChar->getValue()}
    <div class="ls-icon-remove"></div>
</div>