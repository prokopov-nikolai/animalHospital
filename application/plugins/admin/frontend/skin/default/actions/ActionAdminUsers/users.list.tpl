{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'users'}
{/block}

{block name='layout_content'}
    {* TODO: Языковик *}
    <h1>Пользователи</h1>
    <div class="dflex blocks">
        <div class="block">
            <div class="title">Поиск</div>
            ФИО, Телефон, Email,&nbsp;&nbsp; <input type="text" class="user autocomplete-pro" value="{$smarty.get.search|escape}">
            <small class="note">Начните вбивать данные. Затем кликните по нужному элементу, чтобы перейти в <b>редактирование</b></small>
            <div class="cl" style="height: 20px;"></div>
        </div>
        <div class="block">
            {component button text="Добавить" url="{$ADMIN_URL}users/add/"}
        </div>
    </div>
    {include file="{$aTemplatePathPlugin.admin}users/list.tpl"}
    {component 'pagination' total=+$paging.iCountPage current=+$paging.iCurrentPage url="{$paging.sBaseUrl}/page__page__/{$paging.sGetParams}" showPager="true"}
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.user.autocomplete-pro').autocompletePro({
                name: 'users',
				name_search: 'search',
                url: ADMIN_URL+'users/ajax/search/',
                url_search: ADMIN_URL+'user/',
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>' + obj.fio + ' // ' + obj.phone + ' // ' + obj.email + ' // ' + (obj.is_agent ? 'Агент' : '' ) + '</span>'
                        '</div>';
                    return item;
                }
            }, function(obj){
                window.location.href = ADMIN_URL+'users/'+obj.id+'/';
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}