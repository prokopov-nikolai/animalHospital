{capture name='sTabMain'}   {include file="{$aTemplatePathPlugin.admin}forms/design/tab.main.tpl"} {/capture}
{capture name='sTabPrice'}  {include file="{$aTemplatePathPlugin.admin}forms/design/tab.price.tpl"}{/capture}
{capture name='sTabSeo'}    {include file="{$aTemplatePathPlugin.admin}forms/design/tab.seo.tpl"}  {/capture}
{capture name='sTabPhoto'}  {include file="{$aTemplatePathPlugin.admin}forms/design/tab.photo.tpl"}{/capture}
{capture name='sTabFabric'} {include file="{$aTemplatePathPlugin.admin}forms/design/tab.fabric.tpl"}{/capture}
{capture name='sTabAvito'}  {include file="{$aTemplatePathPlugin.admin}forms/design/tab.avito.tpl"}{/capture}

<div class="ls-clearfix">
    <form action="" method="post" enctype="multipart/form-data" id="form-design">
        {component 'tabs' classes='' mods='align-top' tabs=[
        [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
        [ 'text' => 'Цены',         'body' => $smarty.capture.sTabPrice],
        [ 'text' => 'Фото',         'body' => $smarty.capture.sTabPhoto],
        [ 'text' => 'Ткани',        'body' => $smarty.capture.sTabFabric],
        [ 'text' => 'Seo',          'body' => $smarty.capture.sTabSeo],
        [ 'text' => 'Avito',        'body' => $smarty.capture.sTabAvito]
        ]}
        <a href="{$oDesign->getUrlFull()}" class="ls-button" target="_blank">Просмотр дизайна</a>
        {component button text='Сохранить' mods='primary'}
        &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы
    </form>
</div>

{capture name='script'}
    <script>
        var iProductId = {$oDesign->getProductId()};
        var iDesignId = {$oDesign->getId()};
        $(function () {
            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#form-design').submit();
                    return false;
                }
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}
