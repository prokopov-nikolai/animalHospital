{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'margin'}
{/block}

{block name='layout_content'}
    <h1>Наценка товары и дизайны по категориям</h1>
    <form action="" method="post">
        {foreach $aCategory as $oCategory}
            {component field template='text'
            label   = {$oCategory->getTitle()}
            name    = "category[{$oCategory->getId()}]"}
        {/foreach}
        {component button text="Обновить" mods="primary"}
    </form>
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}