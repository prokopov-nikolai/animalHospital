{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'report'}
    {$sMenuSelectSub = 'report_delivery'}
    {$bMenuHide = true}
{/block}

{block name='layout_head_end'} {/block}

{block name='layout_content'}
    <h2>Доставка{if $sDate}  {$sDate} {/if}{if $smarty.get.car_number} Газель {$smarty.get.car_number}{/if}</h2>
    {if !$smarty.get.print}
        <div class="cl h20"></div>
        <form action="" class="dflex not-print">

            {component field template='date'
            label           = 'Дата доставки'
            name            = 'date'
            classes         = 'w200'
            inputAttributes = ['style'=>'margin-right:15px;', 'autocomplete' => 'off']
            value           = $sDateFrom}

            {component field template='select'
            label       = 'Фабрика'
            classes     = 'make'
            inputClasses= 'make'
            name        = 'make_id[]'
            items       = $aMakeForSelect
            isMultiple  = true
            selectedValue = $aMakeSelected}

            {component field template='select'
            label           = 'Номер машины'
            name            = 'car_number'
            selectedValue   = $smarty.get.car_number
            items           = Config::Get('car_number')
            classes         = 'w200'
            inputAttributes  = ['style'=>'margin-right:15px;', 'autocomplete' => 'off']}

            {component button text="Показать" attributes=['style'=>'margin-top:25px; right: -20px;']}
            {if $smarty.get.date && !$smarty.get.print && count($aOrder)}<a href="#" class="ls-button not-print" style="margin: 22px 0 0 15px;" onclick="window.open('{$ADMIN_URL}report/delivery/map/?date={$smarty.get.date}&car_number={$smarty.get.car_number}', 'map', 'width=1500,height=1400'); return false;"><i class="ls-icon-map-marker"></i>&nbsp;Карта</a>{/if}
            {if $smarty.get.date && !$smarty.get.print && count($aOrder)}<a href="{$ADMIN_URL}report/delivery/download/?date={$smarty.get.date}" class="ls-button not-print" style="margin: 22px 0 0 15px;"><i class="ls-icon-download"></i>&nbsp;Скачать</a>{/if}
        </form>
    {/if}
    {include file="{$aTemplatePathPlugin.admin}report/delivery.tpl"}

{/block}



{block name='scripts' append}
    <script>
        $(function () {
            $('.ajax-save').on('change', function(){
                let oData = {
                    iOrderId: $(this).data('order_id'),
                    sField: $(this).data('field'),
                    sValue: $(this).val().toString()
                };
                let sTextConfirm = $(this).data('confirm');
                let bReturn = false;
                if (sTextConfirm) {
                    bReturn = !confirm(sTextConfirm + ' ' + sValue);
                }
                if (!bReturn) {
                    ls.ajax.load(ADMIN_URL + 'order/ajax/change/', oData);
                }
            });
        });
    </script>
{/block}