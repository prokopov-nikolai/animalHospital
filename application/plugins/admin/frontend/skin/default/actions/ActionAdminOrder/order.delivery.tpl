{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'order'}
    {$sMenuSelectSub = 'order_delivery'}
{/block}

{block name='layout_head_end'} {/block}

{block name='layout_content'}
    <h2>Доставка{if $sDate}  {$sDate} {/if}</h2>
    {if !$smarty.get.print}
        <div class="cl h20"></div>
        <form action="" class="dflex">

            {component field template='date'
            label           = 'Дата доставки'
            name            = 'date'
            classes         = 'w200'
            inputAttributes = ['style'=>'margin-right:15px;', 'autocomplete' => 'off']
            value           = $sDateFrom}

            {component button text="Показать" attributes=['style'=>'margin-top:25px; right: -20px;']}
        </form>
    {/if}
    {include file="{$aTemplatePathPlugin.admin}order/delivery.tpl"}

    {if $smarty.get.date && !$smarty.get.print && count($aOrder)}
        <div class="cl h20"></div>
        <a href="{$sCurrentPath}&print=1" target="_blank" class="ls-button print-labels"><i class="ls-icon-print"></i>&nbsp;Печать</a>
        <a href="#" class="ls-button print-labels" onclick="window.open('{$ADMIN_URL}order/delivery/map/?date={$smarty.get.date}', 'map', 'width=650,height=720'); return false;"><i class="ls-icon-map-marker"></i>&nbsp;Карта</a>
    {/if}

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