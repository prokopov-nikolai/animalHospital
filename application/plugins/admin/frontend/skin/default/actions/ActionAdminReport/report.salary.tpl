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
    {$sMenuSelectSub = 'report_salary'}
{/block}

{block name='layout_content'}
    <h1>График работы // {$aLang.plugin.admin.menu.report_salary} // {$months[$dateStart->format('n')]}</h1>
    {include file="{$aTemplatePathPlugin.admin}report/workdays.tpl"}
    {if LS::Adm()}
        {include file="{$aTemplatePathPlugin.admin}report/filter.salary.tpl"}
    {/if}
    {if ($managerId && $dateStart->format('Y-m-d') > '2023-02-28') || LS::Adm()}
        {$managerSalary = 0}
        {$managerSalaryPrognoz = 0}
        <div class="cl h20"></div>
        {include file="{$aTemplatePathPlugin.admin}report/user.salary.tpl"}
    {else}
        <p class="error">Расчет за этот месяц недоступен</p>
        <div class="cl h20"></div>
        <div class="cl h20"></div>
        <div class="cl h20"></div>
    {/if}
    <div class="cl h20"></div>
    {if LS::Adm()}
        {include file="{$aTemplatePathPlugin.admin}report/order.manager.list.tpl"}
        {$amount = LS::Get('managerAmount')}
        {if $amount}
            {component button text="Оплатить менеджеру" id="manager-paid" mods='primary' isDisabled="true"}
        {/if}
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
                    $('#manager-paid').removeClass('disabled');
                    $('#manager-paid').removeAttr('disabled');
                } else {
                    $('#manager-paid').addClass('disabled');
                    $('#manager-paid').attr('disabled', true);
                }
            });

            $('#manager-paid').on('click', function(){
                if ($(this).hasClass('disabled') || $(this).hasClass('processing')) {
                    return false;
                } else {
                    $(this).addClass('processing');
                    let orderProductIds = [];

                    $('.select-order:checked').each(function(){
                        let orderProductId = $(this).parents('tr').data('order_product_id');
                        orderProductIds.push(orderProductId);
                    });

                    ls.ajax.load(ADMIN_URL+'order/ajax/mark-as-manager-paid/', { orderProductIds:orderProductIds }, function(){
                        $('#manager-paid').addClass('disabled');
                        $('#manager-paid').removeClass('processing');
                        $('#manager-paid').attr('disabled', true);
                        orderProductIds.forEach((orderProductId) => {
                            let tr = $('[data-order_product_id="'+orderProductId+'"]'),
                                checkbox = tr.find('input[type="checkbox"]');
                            tr.removeClass('selected');
                            checkbox.before('<span class="checkbox-green"></span>');
                            checkbox.remove();
                        });
                    });
                }
            });
        });
    </script>
{/block}