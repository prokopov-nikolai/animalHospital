{capture name='sTabMain'}       {include file="{$aTemplatePathPlugin.admin}forms/category.filter/tab.main.tpl"}  {/capture}
{capture name='sTabSeo'}        {include file="{$aTemplatePathPlugin.admin}forms/category.filter/tab.seo.tpl"}   {/capture}
{capture name='sTabFilter'}     {include file="{$aTemplatePathPlugin.admin}forms/category.filter/tab.filter.tpl"}{/capture}
{capture name='sTabChars'}      {include file="{$aTemplatePathPlugin.admin}forms/category.filter/tab.chars.tpl"} {/capture}
{capture name='sTabOptions'}    {include file="{$aTemplatePathPlugin.admin}forms/category.filter/tab.options.tpl"} {/capture}

{$aTab = [
    [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
    [ 'text' => 'Seo',          'body' => $smarty.capture.sTabSeo]
]}
{if $oCategoryFilter->getBase()}
    {$aTab[] = [ 'text' => 'Хар-ки',        'body' => $smarty.capture.sTabChars]}
    {$aTab[] = [ 'text' => 'Опции',         'body' => $smarty.capture.sTabOptions]}
{/if}
{$aTab[] = [ 'text' => 'Фильтры',       'body' => $smarty.capture.sTabFilter]}

<div class="ls-clearfix">
    <form action="" method="post" enctype="multipart/form-data" id="form-category-filter">
        {component 'tabs' classes='' mods='align-top' tabs=$aTab}

        {component field template='hidden'
        name        = 'product[id]'
        value       = $oCategoryFilter->getId()}

        {component button text='Сохранить' mods='primary'}
        &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
    </form>
</div>

<script>
    $(document).bind('keydown', 'ctrl+s', function (e) {
        if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
            e.preventDefault();
            $('#form-category-filter').submit();
            return false;
        }
    });
</script>
