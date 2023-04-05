<div class="order-dashboard">
    <div class="column status" data-status="new">
        <div class="head">
            <div class="_title">{GetSelectText('new', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['new']) ? count($aOrder['new']) : 0}</div>
        </div>
        {foreach $aOrder['new'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="processing">
        <div class="head">
            <div class="_title">{GetSelectText('processing', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['processing']) ? count($aOrder['processing']) : 0}</div>
        </div>
        {foreach $aOrder['processing'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="failure">
        <div class="head">
            <div class="_title">{GetSelectText('failure', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['failure']) ? count($aOrder['failure']) : 0}</div>
        </div>
        {foreach $aOrder['failure'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="on_confirm">
        <div class="head">
            <div class="_title">{GetSelectText('on_confirm', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['on_confirm']) ? count($aOrder['on_confirm']) : 0}</div>
        </div>
        {foreach $aOrder['on_confirm'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="user_confirmed">
        <div class="head">
            <div class="_title">{GetSelectText('user_confirmed', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['user_confirmed']) ? count($aOrder['user_confirmed']) : 0}</div>
        </div>
        {foreach $aOrder['user_confirmed'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
	<div class="column status" data-status="make">
		<div class="head">
			<div class="_title">{GetSelectText('make', 'order.status')}</div>
			<div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
			<div class="count">{($aOrder['make']) ? count($aOrder['make']) : 0}</div>
		</div>
		{foreach $aOrder['make'] as $oOrder}
			{include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
		{/foreach}
	</div>
    <div class="column status" data-status="feedback">
        <div class="head">
            <div class="_title">{GetSelectText('feedback', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['feedback']) ? count($aOrder['feedback']) : 0}</div>
        </div>
        {foreach $aOrder['feedback'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="delivered">
        <div class="head">
            <div class="_title">{GetSelectText('delivered', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['delivered']) ? count($aOrder['delivered']) : 0}</div>
        </div>
        {foreach $aOrder['delivered'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="reclamation">
        <div class="head">
            <div class="_title">{GetSelectText('reclamation', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['reclamation']) ? count($aOrder['reclamation']) : 0}</div>
        </div>
        {foreach $aOrder['reclamation'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="failure-ready">
        <div class="head">
            <div class="_title">{GetSelectText('failure-ready', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">{($aOrder['failure-ready']) ? count($aOrder['failure-ready']) : 0}</div>
        </div>
        {foreach $aOrder['failure-ready'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
    <div class="column status" data-status="return">
        <div class="head">
            <div class="_title">{GetSelectText('return', 'order.status')}</div>
            <div class="agent-commission-sum{if !LS::HasRight('38_order_margin_view')} hide{/if}"></div>
            <div class="count">return {($aOrder['return']) ? count($aOrder['return']) : 0}</div>
        </div>
        {foreach $aOrder['return'] as $oOrder}
            {include file="{$aTemplatePathPlugin.admin}order/list.item.tpl"}
        {/foreach}
    </div>
</div>

{include file="{$aTemplatePathPlugin.admin}modal/modal.task.tpl"}
{include file="{$aTemplatePathPlugin.admin}modal/modal.rejected.cause.tpl"}
{include file="{$aTemplatePathPlugin.admin}modal/modal.reclamation.cause.tpl"}

{capture name="script"}
    <script>
		let iOrderId = false,
			orderProductId = 0,
			orderStatus = false,
			columnCurrent = false,
			orderDragging = false;

		const orders = $('.order-dashboard ._order'),
			dashboard = $('.order-dashboard'),
			dropping = $('<div class="dropping"></div>'),
			comments = $('.order-dashboard ._order .comment'),
			dropDown = $('.order-dashboard ._order .drop-down');

		let dragging = false,
			dX = 0, dY = 0,
			timeClick = 0,
			interval = false,
			column = false;

		orders.on('mousedown', function (e) {
			let object = document.elementFromPoint(e.pageX - scrolledX, e.pageY - scrolled);

			/* Убираем действие с выпадающего списка */
			if ($(object).hasClass('_selected') ||
				$(object).hasClass('_option') ||
				$(object).hasClass('comment') ||
				$(object).hasClass('bell')||
				$(object).hasClass('drop-down')
			) {
				e.preventDefault();
				e.stopPropagation();
				if ($(object).hasClass('comment')) {
					$(object).focus();
				}
				if ($(object).hasClass('bell')) {
					iOrderId = $(object).parents('._order').data('id');
					$('#modal-task .order-id').html(iOrderId);
					ModalShow($('#modal-task'));
					$('#modal-task').css({
						left: scrolledX + (window.innerWidth - $('#modal-task').innerWidth()) / 2
					});
				}
				else if ($(object).hasClass('drop-down')) {
					$(object).parents('._order').toggleClass('short');
				}
				return true;
			}

			timeClick = +new Date();
			let orderCurrent = $(this);
			interval = window.setTimeout(function () {
				orderDragging = orderCurrent;
				orderDragging.addClass('draggable');
				dashboard.addClass('draggable');
				dragging = true;
				dropping.height(orderDragging.innerHeight());
				let data = orderCurrent.offset();
				dX = e.pageX - data.left;
				dY = e.pageY - data.top;
				clearInterval(interval);
			}, 200);
		});

		comments.on('keydown', function (e) {
			if (e.keyCode == 13 && !e.shiftKey) {
				$(this).blur();
				return false;
			}
			let el = this;
			window.setTimeout(function () {
				el.style.cssText = 'height:auto; padding:0';
				el.style.cssText = 'height:' + el.scrollHeight + 'px!important';
			}, 0);
		});

		comments.on('blur', function () {
			iOrderId = $(this).parents('._order').data('id');
			let sComment = $(this).val(),
			order = $(this).parents('._order');
			ls.ajax.load(ADMIN_URL + 'order/ajax/comment/add/', {
				iOrderId: iOrderId,
				sComment: sComment
			}, function () {
				order.find('.time-left').html('1 секунда');
			});
		});

		comments.each(function () {
			let el = this;
			window.setTimeout(function () {
				el.style.cssText = 'height:auto; padding:0';
				el.style.cssText = 'height:' + el.scrollHeight + 'px!important';
			}, 0);
		});

		// dropDown.on('mousedown', function (e) {
		// 	let object = document.elementFromPoint(e.pageX - scrolledX, e.pageY - scrolled);
		//
		// 	/* Убираем действие с выпадающего списка */
		// 	if ($(object).hasClass('_selected') ||
		// 			$(object).hasClass('_option') ||
		// 			$(object).hasClass('comment') ||
		// 			$(object).hasClass('bell')
		// 	) {
		// 		e.preventDefault();
		// 		e.stopPropagation();
		// 		if ($(object).hasClass('comment')) {
		// 			$(object).focus();
		// 		}
		// 		if ($(object).hasClass('bell')) {
		// 			iOrderId = $(object).parents('._order').data('id');
		// 			$('#modal-task .order-id').html(iOrderId);
		// 			ModalShow($('#modal-task'));
		// 			$('#modal-task').css({
		// 				left: scrolledX + (window.innerWidth - $('#modal-task').innerWidth()) / 2
		// 			});
		// 		}
		// 		return true;
		// 	}
		//
		// 	timeClick = +new Date();
		// 	let orderCurrent = $(this);
		// 	interval = window.setTimeout(function () {
		// 		orderDragging = orderCurrent;
		// 		orderDragging.addClass('draggable');
		// 		dashboard.addClass('draggable');
		// 		dragging = true;
		// 		dropping.height(orderDragging.innerHeight());
		// 		let data = orderCurrent.offset();
		// 		dX = e.pageX - data.left;
		// 		dY = e.pageY - data.top;
		// 		clearInterval(interval);
		// 	}, 200);
		// });

		$('body').on('mouseup', function (e) {
			let time = +new Date();

			if (time - timeClick < 200) {
				let object = document.elementFromPoint(e.pageX - scrolledX, e.pageY - scrolled);
				/* Убираем действие с выпадающего списка */
				if ($(object).hasClass('_selected')
					|| $(object).hasClass('_option')) {
					e.preventDefault();
					e.stopPropagation();
					return true;
				} else if ($(object).hasClass('comment')) {
					$(object).focus();
				} else if (object) {
					let orderCurrent = $(object).parents('._order')

					if (orderCurrent.length) {
						clearInterval(interval);
						if (e.ctrlKey) {
							window.open( ADMIN_URL + 'order/' + orderCurrent.data('id') + '/');
							e.preventDefault();
							e.stopPropagation();
							return false;
						} else {
							window.location.href = ADMIN_URL + 'order/' + orderCurrent.data('id') + '/';
						}
					}
				}
				return true;
			}

			if (orderDragging && dragging) {
				orderDragging.removeClass('draggable');
				orderDragging.css({
					top: 'initial', left: 'initial'
				});
				dashboard.removeClass('draggable');
				dragging = false;

				let status = column.data('status');
				if (column && status) {
					let rejectedStatuses = ['failure', 'failure-ready', 'return'];
					if (status == 'reclamation') {
						/* Запрашиваем причину рекламации */
						iOrderId = orderDragging.data('id');
						orderStatus = status;
						columnCurrent = column;
						const modal = $('#modal-reclamation-cause');
						/* Получим список товаров в заказе подставим в форму и покажем ее */
						ls.ajax.load(ADMIN_URL+'order/ajax/html-products-select/', { order_id: iOrderId }, function(answer) {
							let select = modal.find('._item.rejected-type + .ls-field.order-product-id');
							select.remove();
							modal.find('._item.rejected-type').after(answer.html);
							modal.find('._item.rejected-type + .ls-field.order-product-id select').selectStylized();
							ModalShow(modal);
							modal.css({
								left: scrolledX + (window.innerWidth - modal.innerWidth()) / 2
							});
						});
					} else if (rejectedStatuses.indexOf(status) != -1) {
						/* Запрашиваем причину отказа */
						iOrderId = orderDragging.data('id');
						orderStatus = status;
						columnCurrent = column;
						ModalShow($('#modal-rejected-cause'));
						$('#modal-rejected-cause').css({
							left: scrolledX + (window.innerWidth - $('#modal-rejected-cause').innerWidth()) / 2
						});
					} else {
						/* перемещаем заказ */
						orderChangeStatus(column, status);
					}
				}
			}
		});

		$('body').on('keyup', function (e) {
			if (e.keyCode == 27) {
				orderDragging.removeClass('draggable');
				dashboard.removeClass('draggable');
				dashboard.find('.dropping').remove();
				dragging = false;
			}
		});

		dashboard.on('mousemove', function (e) {
			if (dragging == false) return false;

			let time = +new Date();

			if (time - timeClick < 200) {
				return false;
			}

			orderDragging.hide();
			let left = (window.pageXOffset || document.scrollLeft) - (document.clientLeft || 0);
			if (isNaN(left)) left = 0;
			let object = document.elementFromPoint(e.pageX - left, e.pageY - scrolled);
			orderDragging.show();

			if (object != null) {
				column = false;

				if ($(object).hasClass('status')) {
					column = $(object);
				} else {
					column = $(object).parents('.status');
				}


				if (column.length) {
					orderDragging.css({
						top: e.pageY - dY,
						left: e.pageX - dX
					})

					let droppingInColumn = column.find('.dropping');

					if (droppingInColumn.length) {
						let data = droppingInColumn.offset();

						/* Если мы не в элемента дроппинга*/
						if (Math.abs(e.pageY - data.top) > orderDragging.innerHeight()) {
							droppingInColumn.remove();
							appendDropping(column, e.pageY)
						}
					} else {
						appendDropping(column, e.pageY);
					}
				}
			}


		});

		let intervalScrolledStop = false;
		$(window).on('scroll.columns', function () {
			const columnsHeads = $('.column .head');

			if (scrolled > 100) {
				columnsHeads.addClass('fixed');
			} else {
				columnsHeads.removeClass('fixed');
			}

			columnsHeads.css({
				top: scrolled + 94
			});
		});

		let orderChangeStatus = function (column, status) {
			let droppingInColumn = column.find('.dropping');
			droppingInColumn.after(orderDragging);
			orderDragging.find('.time-left').html('1 секунда')
			ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
				iOrderId: orderDragging.data('id'),
				sField: 'status',
				sValue: status
			}, function () {
				recalcOrdersCount();
				recalcOrdersSum();
				recalcStatistics();
			});
			let orders = {};
			column.find('._order').each(function (i) {
				orders[$(this).data('id')] = i;
			});
			ls.ajax.load(ADMIN_URL + 'order/ajax/sort/', {
				orders: orders
			}, function () {
				column = false;
			});
			$('.order-dashboard').find('.dropping').remove();
		}

		let appendDropping = function (column, pageY) {
			let ordersInColumn = column.find('._order');

			for (let i = 0; i < ordersInColumn.length; i++) {
				let orderCurrent = $(ordersInColumn[i]);
				if (orderCurrent.hasClass('draggable')) {
					continue;
				}

				if (Math.abs(orderCurrent.offset().top - pageY) < orderDragging.height()) {
					orderCurrent.before(dropping);
					return false;
				}
			}

			if (ordersInColumn.length == 0) {
				column.append(dropping);
			} else {
				let orderCurrent = $(ordersInColumn[ordersInColumn.length - 1]);
				orderCurrent.after(dropping);
			}
		}

		let recalcOrdersCount = function () {
			let columns = $('.order-dashboard .column');
			columns.each(function () {
				$(this).find('.count').html($(this).find('._order').length);
			});
		}

		let recalcOrdersSum = function () {
			const columns = $('.order-dashboard .column');

			columns.each(function () {
				let agentCommission = 0,
					orders = $(this).find('._order');
				if (orders.length > 0) {

					orders.each(function () {
						agentCommission += $(this).data('agent_commission');
					});
				}

				$(this).find('.agent-commission-sum').html(GetPrice(agentCommission, true, true));
			});
		}

		let recalcStatistics = function () {
			const columns = $('.order-dashboard .column'),
				columnsOrders = ['make', 'delivered', 'feedback', 'reclamation'];

			let ordersCount = 0,
				incomingCount = $('._order').length,
				agentCommission = 0;

			columns.each(function () {
				if (columnsOrders.includes($(this).data('status'))) {
					let orders = $(this).find('._order');
					ordersCount += orders.length;
					orders.each(function () {
						agentCommission += $(this).data('agent_commission');
					});
				}
			});

			/* Количество дней с начала месяца */
			let daysDiff = parseInt($('.statistics .orders-average').data('days_diff'), 10);
			/* Количество дней в месяце */
			let daysMonth = parseInt($('.statistics .orders-average').data('days_month'), 10);
			$('.statistics .incoming-count').html(incomingCount);
			$('.statistics .orders-count').html(ordersCount);
			$('.statistics .orders-conversion').html((ordersCount ? Math.floor(ordersCount / incomingCount * 100) : 0) + '%');
			if (marginPlan) {
				/* Подсчитаем процент выполнения на текущий день */
				let percents = Math.floor((agentCommission/daysDiff)/(marginPlan/daysMonth)* 100);
				$('.statistics .margin-plan').html(Math.floor(agentCommission / marginPlan * 100) + '%' + ' <span>('+percents+'%)</span>');
				$('.statistics .margin-plan').removeClass('light-red');
				$('.statistics .margin-plan').removeClass('red');
				$('.statistics .margin-plan').removeClass('green');
				if (percents >= 100) {
					$('.statistics .margin-plan').addClass('green');
				} else if (percents >= 85) {
					$('.statistics .margin-plan').addClass('light-red');
				} else {
					$('.statistics .margin-plan').addClass('red');
				}
			} else {
				$('.statistics .margin-plan').html('---');
			}
			$('.statistics .agent-commission-sum').html(GetPrice(agentCommission, true, true));
			$('.statistics .orders-average b').html(Math.floor((ordersCount) / daysDiff * 10) / 10);
		}


		recalcOrdersCount();
		recalcOrdersSum();
		recalcStatistics();

		$('.orders-lost').on('click', function(){
			$('#order-filter').append('<input type="hidden" name="lost" value="1">').submit();
		});


		/* Причина отказа из модального окна*/
		$('#modal-rejected-cause .rejected-cause-add').on('click', function(e){
			e.stopPropagation();
			e.preventDefault();
			let rejected = {},
				rejected_type = $('#modal-rejected-cause .rejected-type').val(),
				rejected_cause = $('#modal-rejected-cause .rejected-cause').val();
			if (rejected_cause.length < 10) {
				ls.msg.error('Укажите причину (минимум 10 символов)');
				return false;
			}
			rejected.order_id = iOrderId;
			rejected.order_product_id = orderProductId;
			rejected.order_status = orderStatus;
			rejected.rejected_type = rejected_type;
			rejected.rejected_cause = rejected_cause;
			ls.ajax.load(ADMIN_URL+'order/ajax/rejected/', { rejected: rejected }, function(answer){
				if (answer.bStateError == false) {
					orderChangeStatus(columnCurrent, orderStatus);
					ModalHide(true, $('#modal-rejected-cause'));
					$('._order[data-id="'+iOrderId+'"] .comment').val(rejected_cause);
					$('#modal-rejected-cause .rejected-cause').val('');
				}
			});
			return false;
		});

		/* Причина рекламации из модального окна*/
		$('#modal-reclamation-cause .rejected-cause-add').on('click', function(e){
			e.stopPropagation();
			e.preventDefault();
			let rejected = {},
				rejected_type = $('#modal-reclamation-cause .rejected-type select').val(),
				orderProductId = $('#modal-reclamation-cause .order-product-id select').val(),
				rejected_cause = $('#modal-reclamation-cause .rejected-cause').val();
			if (rejected_cause.length < 10) {
				ls.msg.error('Укажите причину (минимум 10 символов)');
				return false;
			}
			rejected.order_id = iOrderId;
			rejected.order_product_id = orderProductId;
			rejected.order_status = orderStatus;
			rejected.rejected_type = rejected_type;
			rejected.rejected_cause = rejected_cause;
			ls.ajax.load(ADMIN_URL+'order/ajax/rejected/', { rejected: rejected }, function(answer){
				if (answer.bStateError == false) {
					orderChangeStatus(columnCurrent, orderStatus);
					ModalHide(true, $('#modal-reclamation-cause'));
					$('._order[data-id="'+iOrderId+'"] .comment').val(rejected_cause);
					$('#modal-reclamation-cause .rejected-cause').val('');
				}
			});
			return false;
		});
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}
