{capture name='sTabMain'}  {include file="{$aTemplatePathPlugin.admin}forms/collection/tab.main.tpl"} {/capture}
{capture name='sTabPhoto'} {include file="{$aTemplatePathPlugin.admin}forms/collection/tab.photo.tpl"}{/capture}
{capture name='sTabSeo'}   {include file="{$aTemplatePathPlugin.admin}forms/collection/tab.seo.tpl"}  {/capture}

<form action="" method="post" enctype="multipart/form-data" id="collection">
    {component 'tabs' classes='' mods='align-top' tabs=[
    [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
    [ 'text' => 'Ткани',        'body' => $smarty.capture.sTabPhoto],
    [ 'text' => 'Seo',          'body' => $smarty.capture.sTabSeo]
    ]}
    {component button text='Сохранить' mods='primary'}
</form>

{capture name='script'}
    <script>
        var iCollectionId = {$oCollection->getId()};
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}