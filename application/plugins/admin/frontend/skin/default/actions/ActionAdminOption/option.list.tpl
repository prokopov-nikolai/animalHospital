{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'option'}
{/block}

{block name='layout_content'}
    <h1>Опциии</h1>
    <div class="dflex blocks">
        <div class="block">
            <form action="{$ADMIN_URL}option/add/" method="post">
                <div class="title">Добавить новую опцию</div>
                Название &nbsp;&nbsp;<input type="text" class="product" name="option">
                {component button text="Добавить" classes='fr' attributes=['style'=>'top:5px;']}
            </form>
        </div>
        <div class="cl" style="height: 30px;"></div>
    </div>
    {include file="{$aTemplatePathPlugin.admin}option/list.tpl"}
{/block}