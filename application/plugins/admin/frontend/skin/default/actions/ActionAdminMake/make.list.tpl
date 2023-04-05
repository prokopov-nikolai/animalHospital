{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'make'}
{/block}

{block name='layout_content'}
    <h1>Производители</h1>
    <div class="dflex blocks">
        <div class="block">
            <form action="{$ADMIN_URL}make/add/" method="post">
                <div class="title">Добавить нового производителя</div>
                Название &nbsp;&nbsp;<input type="text" class="product" name="make">
                {component button text="Добавить" classes='fr' attributes=['style'=>'top:5px;']}
            </form>
        </div>
        <div class="cl" style="height: 30px;"></div>
    </div>
    {include file="{$aTemplatePathPlugin.admin}make/list.tpl"}
    {component 'pagination' total=+$paging.iCountPage current=+$paging.iCurrentPage url="{$paging.sBaseUrl}/page__page__/{$paging.sGetParams}" showPager="true"}
{/block}
