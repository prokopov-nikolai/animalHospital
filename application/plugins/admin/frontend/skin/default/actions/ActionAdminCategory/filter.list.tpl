{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'category'}
    {$sMenuSelectSub = 'category_filter'}
{/block}

{block name='layout_content'}
    <h2>Категории фильтры</h2>
    {component button
    mods    ='primary'
    url     = "/{Config::Get('plugin.admin.url')}/category/filter/add/"
    text    = 'Добавить'}
    <div class="cl" style="height: 20px;"></div>
    {component field template='text'
    label           = 'Поиск категории-фильтра'
    name            = 'category_filter'
    inputClasses    = 'category-filter autocomplete-pro w600'
    inputAttributes = ['autocomplete' => 'off']}
    {if $aCategoryFilterSelect|count}
        <table class="table category-filter">
            <tr>
                <th>id</th>
                <th>Название</th>
                <th>Группа</th>
                <th>Префикс</th>
                <th>UrlFull</th>
                <th>Отобр.<br> в меню</th>
                <th>Кол-во<br>товаров</th>
                <th>price_min</th>
                <th>price_max</th>
                <th width="110"></th>
            </tr>
            {foreach $aCategoryFilterSelect as $aData}
                {if $aData['value'] != 0}
                    <tr>
                        <td>{$aData['value']}</td>
                        <td class="level-{$aData['level']}"><a href="{$ADMIN_URL}category/filter/{$aData['value']}/"{if $aData['base'] == 1} style="font-weight:bold;" title="Базовая категория"{/if}>{$aData['text']}</a></td>
                        <td>{$aData['group_by']}</td>
                        <td>{$aData['product_prefix']}</td>
                        <td>{$aData['url_full']}</td>
                        <td>{($aData['in_menu']) ? 'Да' : '-'}</td>
                        <td class="count">{$aData['count']}</td>
                        <td class="price-min">{$aData['price_min']}</td>
                        <td class="price-max">{$aData['price_max']}</td>
                        <td class="nobr">
                            <a href="{$ADMIN_URL}category/filter/redirect/{$aData['value']}/" class="ls-icon-share" target="_blank" data-tooltip="Открыть в новой вкладке"></a> &nbsp;
                            <a href="#update" data-id="{$aData['value']}" class="category-filter-update  ls-icon-refresh" target="_blank" data-tooltip="Обновить информацию"></a> &nbsp;
                            <a href="{$ADMIN_URL}category/filter/{$aData['value']}/" class="ls-icon-edit" data-tooltip="Редактировать"></a> &nbsp;
                            <a href="{$ADMIN_URL}category/filter/delete/{$aData['value']}/" class="ls-icon-remove" data-tooltip="Удалить"></a>
                        </td>
                    </tr>
                {/if}
            {/foreach}
        </table>
    {/if}
    {capture name="scripts"}
        <script>
            $(function () {
                /**
                 * Поиск характеристики
                 */
                $('.category-filter.autocomplete-pro').autocompletePro({
                    name: 'category_filter',
                    url: ADMIN_URL + 'category/ajax/filter/search/',
                    url_search: ADMIN_URL + 'category/filter/',
                    name_search: 'search',
                    render: function (obj) {
                        var item =
                            '<div class="row" data-id="' + obj.id + '">' +
                            '<span>' + obj.name + '</span>' +
                            '</div>';
                        return item;
                    }
                }, function (obj) {
                    window.location.href = ADMIN_URL + 'category/filter/' + obj.id + '/';
                });
                /**
                 * Обновляем значение количества и price_min категории фильтра
                 */
                $('.category-filter-update').on('click', function(e){
                    e.preventDefault();
                    let oBut = $(this);
                    oBut.addClass('processing');
                    let oRow = $(this).parents('tr');
                    let aData = {
                        id: $(this).data('id')
                    };
                    ls.ajax.load(ADMIN_URL+'category/ajax/filter/update/', aData, function(answ) {
                        oBut.removeClass('processing');
                        oRow.find('.count').html(answ.iCount);
                        oRow.find('.price-min').html(answ.iPriceMin);
                        oRow.find('.price-max').html(answ.iPriceMax);
                    });
                    return false;
                });
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.scripts)}

{/block}}
