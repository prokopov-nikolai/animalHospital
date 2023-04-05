{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'order'}
    {$sMenuSelectSub = 'order_list'}
    {$bMenuHide = true}
{/block}

{block name='layout_head_end'}
    <style>
		tr a {
			text-decoration: underline;
		}

		tr td {
			color: #131313;
			border: #e2e3e3 solid 1px;
			font-size: 12px;
			padding: 3px 2px !important;
		}

		tr:hover td {
			background: #505050 !important;
			color: #fff;
			cursor: pointer;
		}

		tr:hover td ._selected {
			color: #fff;
		}

		tr:hover a {
			color: #fff !important;
		}

		tr.active td {
			background: #b64e00 !important;
			color: #fff;
			cursor: pointer;
		}

		tr.active a {
			color: #fff !important;
		}

		tr a:hover {
			text-decoration: none;
		}

		tr.processing, .btn-processing, .order-status-processing,
		._options div[data-value="processing"] {
			background: rgba(221, 221, 221, .4) !important;
			text-indent: 0 !important;
		}

		tr.make, .btn-make, .order-status-make,
		._options div[data-value="make"] {
			background: #d9edf7 !important;
		}

		tr.delivery,
		._options div[data-value="delivery"] {
			background: #fce5cd !important;
		}

		tr.delivered, .btn-delivered, .order-status-delivered,
		._options div[data-value="delivered"] {
			background: rgba(92, 184, 92, 0.4) !important;
		}

		tr.ring, .btn-ring, .order-status-ring,
		._options div[data-value="ring"] {
			background: rgba(92, 184, 92, 0.4) !important;
		}

		tr.failure, .btn-failure, .order-status-failure,
		._options div[data-value="failure"] {
			background: #f4cccc !important;
		}

		tr.failure-ready, .btn-failure-ready, .order-status-failure-ready,
		._options div[data-value="failure-ready"] {
			background: rgba(240, 173, 78, .4) !important;
		}

		tr.return, .btn-return, .order-status-return,
		._options div[data-value="return"] {
			background: rgba(217, 83, 79, .4) !important;
		}

		td.order_status {
			padding: 0;
		}

		.order_status_item {
			margin: -8px 0;
		}

		.order_status .select-stylized {
		}

		.order_status .select-stylized ._selected {
			background: transparent;
			border: none !important;
			padding: 2px 3px;
		}

		.order_status .select-stylized ._selected:after {
			right: 2px;
			top: 2px;
		}

		.order_status .select-stylized ._option {
			color: #111;
			padding: 4px 8px;
			font-size: 11px;
		}

        {foreach Config::Get('colors') as $aColor}
            {if $aColor.value != '-'}
                #wrapper.admin .order-dashboard .status ._order .row-1 .color ._selected[data-value={$aColor.value}]:after {
                    background: {$aColor.color};
                }
                #wrapper.admin .order-dashboard .status ._order .row-1 .color ._option[data-value={$aColor.value}]:after {
                    background: {$aColor.color};
                }
            {/if}
        {/foreach}
    </style>
{/block}

{block name='layout_content'}
    <div class="order-list">
        <div class="panel">
            <div class="statistics">
                <div class="_title">Входящие заявки:</div>
                <div class="incoming-count"></div>
                <div class="_title" title="Заказы в статусах: Клиент подтвердил, Доставлен, Обратная связь">Заказы:</div>
                <div class="orders-count"></div>
                <div class="_title">Конверсия:</div>
                <div class="orders-conversion"></div>
                <div class="_title">План:</div>
                <div class="margin-plan" title="Процент выполнения общего плана (Прогноз на конец месяца)"></div>
                <div class="orders-average" data-days_diff="{$daysDiff+1}" data-days_month="{$daysMonth}">Ср/д: <b style="font-size: 25px;"></b></div>
                <div class="_title agent-commission{if !LS::HasRight('39_order_margin_view_in_head')} hide{/if}">Выручка:</div>
                <div class="agent-commission-sum{if !LS::HasRight('39_order_margin_view_in_head')} hide{/if}"></div>
            </div>
        </div>
        <div class="filter-wrap">
            {include file="{$aTemplatePathPlugin.admin}order/filter.tpl"}
        </div>
        {include file="{$aTemplatePathPlugin.admin}order/list.tpl"}
        <div class="cl h20"></div>
    </div>
    {*    <button class="ls-button disabled print-labels"><i class="ls-icon-print"></i> &nbsp;Напечатать бирки</button>*}
{/block}



{block name='scripts' append}
    <script>
        $(function () {
            $('#checked-all').on('click', function () {
                let checked = this.checked;
                $('.checked').each(function () {
                    this.checked = checked;
                    if (checked) $(this).parents('tr').addClass('checked');
                    else $(this).parents('tr').removeClass('checked');

                });

                if ($('.checked:checked').length) $('.print-labels').removeClass('disabled');
                else $('.print-labels').addClass('disabled');
            });

            $('.checked').on('click', function () {
                $(this).parents('tr').toggleClass('checked');
                if ($('.checked:checked').length) $('.print-labels').removeClass('disabled');
                else $('.print-labels').addClass('disabled');
            });

            $('.print-labels').on('click', function () {
                let aId = [];
                $('.checked:checked').each(function () {
                    aId.push($(this).parents('tr').data('id'));
                });
                window.open(ADMIN_URL + 'order/print/labels/?id=' + encodeURI(aId), '_blank');
            });

            /**
             * Поиск агента
             */
            $('.autocomplete-pro.agent').autocompletePro({
                    name: 'agent',
                    url: '/ajax/search/agent/',
                    data: {
                        field: 'value'
                    },
                    render: function (obj) {
                        var item =
                            '<div class="row" data-id="' + obj.id + '">' +
                            '<span>' + obj.fio + ' // ' + obj.phone + '</span>'
                        '</div>';
                        return item;
                    }
                },
                function (obj) {
                    $('#agent_id').val(obj.id);
                    $(this).val(obj.fio);
                }
            );

            $('.table.orders tr').on('click', function () {
                $('.table.orders tr.active').removeClass('active');
                $(this).addClass('active');
            });

            $('tr td').on('click', function () {
                $('tr.active').removeClass('active');
                $(this).parents('tr').addClass('active');
            });

            $('.ajax-save').on('change', function () {
                let o = this;
                oInt = window.setTimeout(function () {
                    AjaxSave.call(o);
                }, 200);
            });

            $('.filter-button').on('click', function() {
                $('.filter-wrap #order-filter .row2').slideToggle();
            });

            $('.ls-field.make [data-value="all"]').on('click', function(){
              $('.ls-field.make ._option').each(function(i){
                if ($(this).data('value') != 'dall' && $(this).data('value') != 'all' && $(this).data('value') != 0) {
                  if (!$(this).hasClass('selected')) {
                    $(this).trigger('click');
                  }
                }
                $('.ls-field-input.make option[value="all"]')[0].selected = false;
                $('.ls-field-input.make option[value="dall"]')[0].selected =  false;
                $('.ls-field.make [data-value="all"]').removeClass('selected');
                $('.ls-field.make [data-value="dall"]').removeClass('selected');
              });
              return false;
            });

            $('.ls-field.make [data-value="dall"]').on('click', function(){
              $('.ls-field.make ._option').each(function(i){
                if ($(this).data('value') != 'dall' && $(this).data('value') != 'all' && $(this).data('value') != 0) {
                  if ($(this).hasClass('selected')) {
                    $(this).trigger('click');
                  }
                }
                $('.ls-field-input.make option[value="all"]')[0].selected = false;
                $('.ls-field-input.make option[value="dall"]')[0].selected =  false;
                $('.ls-field.make [data-value="all"]').removeClass('selected');
                $('.ls-field.make [data-value="dall"]').removeClass('selected');
              });
              return false;
            });

            $('.ls-field.manager select').on('change', function(){
                $('form#order-filter').submit();
            });

            function AjaxSave() {
                let oOrderProduct = $(this).parents('.order-product'),
                    oTr = $(this).parents('tr'),
                    iOrderId = oTr.data('id'),
                    iOrderProductId = oTr.data('order_product_id');
                if(oTr.length == 0){
                    oOrder = $(this).parents('._order');
                    iOrderId = oOrder.data('id');
                }
                sOrderProductDesignId = null;
                let sField = $(this).data('field'),
                    sValue;
                if ($(this).attr('type') == 'checkbox') {
                    sValue = this.checked ? 1 : 0;
                } else {
                    sValue = $(this).val().toString();
                }
                if (sField == 'status') {
                    oTr.attr('class', sValue);
                }
                let sTextConfirm = $(this).data('confirm');
                let bReturn = false;
                if (sTextConfirm) {
                    bReturn = !confirm(sTextConfirm + ' ' + sValue);
                }
                if (!bReturn) {
                    ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
                        iOrderId: iOrderId,
                        sOrderProductDesignId: sOrderProductDesignId,
                        iOrderProductId: iOrderProductId,
                        sField: sField,
                        sValue: sValue
                    }, function (answ) {
                        OrderDataUpdate(answ);
                    });
                }
            };
        });
        let marginPlan = {$iMarginPlan};
    </script>
{/block}
