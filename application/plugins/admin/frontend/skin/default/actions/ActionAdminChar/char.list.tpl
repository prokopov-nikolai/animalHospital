{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'char'}
{/block}

{block name='layout_content'}
    <h1>Характеристики</h1>
    <div class="dflex blocks">
        <div class="block">
            <form action="{$ADMIN_URL}char/add/" method="post">
                <div class="title">Добавить новую характеристику</div>
                Название хар-ки&nbsp;&nbsp;<div class="autocomplete-wrap" style="display: inline-block;"><input
                            type="text" class="char" name="char_name"></div>
                {component button text="Добавить" classes='fr' attributes=['style'=>'top:10px; right: 40px;']}
            </form>
        </div>
        <div class="block">
        </div>
        <div class="cl" style="height: 30px;"></div>
        {if $oCategory}
            {component field template='hidden' name='category_id' value=$oCategory->getId()}
        {/if}
    </div>
    {include file="{$aTemplatePathPlugin.admin}char/char.list.tpl"}
{/block}