{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_head_end'}
    <style>
        @media print {
            @page {
                size: portrait;
            }
        }
    </style>
{/block}

{block name='layout_options'}
    {$sMenuSelect = 'report'}
    {$sMenuSelectSub = 'report_failure'}
{/block}

{block name='layout_content'}
    <h1>{$aLang.plugin.admin.menu.report_failure} - {$months[$dateFrom->format('n')]}</h1>
    {include file="{$aTemplatePathPlugin.admin}report/filter.failure.tpl"}
    <div class="cl h20"></div>
    {include file="{$aTemplatePathPlugin.admin}report/order.failure.list.tpl"}

    {if !$smarty.get.print}
        {component button text="Закрыть заказы" id="order-closed" mods='primary' isDisabled="true"}
    {/if}
{/block}


{block name='scripts' append}
    <script>
        $(function () {
            $('.select-all').on('click', function () {
                let checked = this.checked;
                $('.select-order').attr('checked', checked);
                $('.select-order').trigger('change');
            });

            $('.select-order').on('change', function () {
                let checked = this.checked;

                if (checked) {
                    $(this).parents('tr').addClass('selected');
                } else {
                    $(this).parents('tr').removeClass('selected');
                }

                let orderSelected = $('.select-order:checked').length;

                if (orderSelected) {
                    $('#order-closed').removeClass('disabled');
                    $('#order-closed').removeAttr('disabled');
                } else {
                    $('#order-closed').addClass('disabled');
                    $('#order-closed').attr('disabled', true);
                }
            });

            $('#order-closed').on('click', function () {
                if ($(this).hasClass('disabled') || $(this).hasClass('processing')) {
                    return false;
                } else {
                    $(this).addClass('processing');
                    let orderIds = {};

                    $('.select-order:checked').each(function () {
                        let orderId = $(this).parents('tr').data('order_id');
                        orderIds[orderId] = orderId;
                    });
                    console.log(orderIds);

                    ls.ajax.load(ADMIN_URL + 'order/ajax/closed/', {
                        orderIds: orderIds
                    }, function () {
                        $('#order-closed').addClass('disabled');
                        $('#order-closed').removeClass('processing');
                        $('#order-closed').attr('disabled', true);
                        for (let orderId in orderIds) {
                            let tr = $('[data-order_id="' + orderId + '"]'),
                                checkbox = tr.find('input[type="checkbox"]');
                            tr.removeClass('selected');
                            checkbox.before('<span class="checkbox-red"></span>');
                            checkbox.remove();
                        }
                        ;
                    });
                }
            });
            /**
             * Поиск товара
             */
            $('.autocomplete-pro.product').autocompletePro({
                name: 'products',
                name_search: 'search',
                url: ADMIN_URL+'product/ajax/search/',
                data: {},
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>'+obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ': '')+'</span>'+
                        '</div>';
                    return item;
                }
            }, function(obj){
                $('#product-id').val(obj.id);
                $(this).val(obj.name);
            });
        });
    </script>
{/block}
