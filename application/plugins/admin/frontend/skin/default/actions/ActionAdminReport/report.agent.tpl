{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_head_end'}
    <style>
        @media print {
            @page {
                size:landscape;
            }
        }
    </style>
{/block}

{block name='layout_options'}
    {$sMenuSelect = 'report'}
    {$sMenuSelectSub = 'report_agent'}
{/block}

{block name='layout_content'}
    <h1>Агентские{if $smarty.get.date_from} c {$oDateFrom->format('d.m.Y')} по {$oDateTo->format('d.m.Y')}{/if}
        {if $makes}
            {foreach $makes as $make}
                // {$make->getTitle()}
            {/foreach}
        {/if}
        {if $smarty.get.print} <span>сформировано {$smarty.now|date_format:'d.m.Y в H:i:s'}</span>{/if}</h1>
    {if !$smarty.get.print}{include file="{$aTemplatePathPlugin.admin}report/filter.agent.tpl"}{/if}
    {include file="{$aTemplatePathPlugin.admin}report/order.agent.list.tpl"}
    {if !$smarty.get.print}
        {component button text="Доставлено" id="delivered" mods='primary' isDisabled="true"}
        {component button text="Получено от фабрики" id="make-paid" mods='primary' isDisabled="true"}
        <div class="cl h20"></div>
        <a href="{$sCurrentPath}&print=1" target="_blank" class="ls-button  print-report"><i class="ls-icon-print"></i> &nbsp;Напечатать </a>
    {/if}
{/block}

{block name='scripts' append}
    <script>
        $(function () {
            $('.select-all').on('click', function(){
                let checked = this.checked;
                $('.select-order').attr('checked', checked);
                $('.select-order').trigger('change');
            });

            $('.select-order').on('change', function(){
                let checked = this.checked;

                if (checked) {
                    $(this).parents('tr').addClass('selected');
                } else {
                    $(this).parents('tr').removeClass('selected');
                }

                let agentCommission = 0;
                $('.select-order:checked').each(function(){
                    agentCommission += parseInt($(this).parents('tr').data('agent_commission'), 10);
                });

                $('th.agent-commision').html(GetPrice(agentCommission, true, true));

                if (agentCommission) {
                    $('#delivered, #make-paid').removeClass('disabled');
                    $('#delivered, #make-paid').removeAttr('disabled');
                } else {
                    $('#delivered, #make-paid').addClass('disabled');
                    $('#delivered, #make-paid').attr('disabled', true);
                }
            });

            $('#make-paid').on('click', function(){
                if ($(this).hasClass('disabled') || $(this).hasClass('processing')) {
                    return false;
                } else {
                    $(this).addClass('processing');
                    let orderProductIds = [];

                    $('.select-order:checked').each(function(){
                        let orderProductId = $(this).parents('tr').data('order_product_id');
                        orderProductIds.push(orderProductId);
                    });

                    ls.ajax.load(ADMIN_URL+'order/ajax/mark-as-make-paid/', { orderProductIds:orderProductIds }, function(){
                        $('#make-paid').addClass('disabled');
                        $('#make-paid').removeClass('processing');
                        $('#make-paid').attr('disabled', true);
                        orderProductIds.forEach((orderProductId) => {
                            let tr = $('[data-order_product_id="'+orderProductId+'"]'),
                                checkbox = tr.find('input[type="checkbox"]');
                            tr.removeClass('selected');
                            checkbox.before('<span class="checkbox-blue"></span>');
                            checkbox.remove();
                        });
                    });
                }
            });

            $('#delivered').on('click', function(){
                if ($(this).hasClass('disabled') || $(this).hasClass('processing')) {
                    return false;
                } else {
                    $(this).addClass('processing');
                    let orderProductIds = [];

                    $('.select-order:checked').each(function(){
                        let orderProductId = $(this).parents('tr').data('order_product_id');
                        orderProductIds.push(orderProductId);
                    });

                    ls.ajax.load(ADMIN_URL+'order/ajax/mark-as-delivered/', { orderProductIds:orderProductIds }, function(){
                        $('#delivered').addClass('disabled');
                        $('#delivered').removeClass('processing');
                        $('#delivered').attr('disabled', true);
                        orderProductIds.forEach((orderProductId) => {
                            let tr = $('[data-order_product_id="'+orderProductId+'"]'),
                                checkbox = tr.find('input[type="checkbox"]');
                            tr.removeClass('selected');
                            checkbox.remove();
                        });
                    });
                }
            });
        });
    </script>
{/block}