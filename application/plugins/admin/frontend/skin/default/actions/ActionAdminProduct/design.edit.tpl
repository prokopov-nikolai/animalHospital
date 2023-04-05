{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'design'}
{/block}

{block name='layout_content'}
    <h1>{if $oDesign->getTitle()}{$oDesign->getTitle()}{else}Дизайн {$oDesign->getId()}{/if}</h1>
    {include file="{$aTemplatePathPlugin.admin}forms/design.tpl"}
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $('.product.autocomplete-pro').autocompletePro({
                name: 'products',
                url: ADMIN_URL+'product/ajax/search/',
                name_search: 'search',
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>'+obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(выведена)</span> ': '')+'</span>'+
                        '</div>';
                    return item;
                }
            }, function(obj){
                log(obj);
                $('.product.autocomplete-pro').val(obj.name);
                iProductId = obj.id;
                $('#product_id').val(iProductId);
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}