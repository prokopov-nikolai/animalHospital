{capture name='sTabMain'}       {include file="{$aTemplatePathPlugin.admin}forms/order/tab.main.tpl"}       {/capture}
{capture name='sTabServices'}   {include file="{$aTemplatePathPlugin.admin}forms/order/tab.services.tpl"}   {/capture}
{*{capture name='sTabManufacture'}{include file="{$aTemplatePathPlugin.admin}forms/order/tab.manufacture.tpl"}{/capture}*}
{capture name='sTabDocuments'}  {include file="{$aTemplatePathPlugin.admin}forms/order/tab.documents.tpl"}  {/capture}
{capture name='sTabDelivery'}   {include file="{$aTemplatePathPlugin.admin}forms/order/tab.delivery.tpl"}   {/capture}
{capture name='sTabPayments'}   {include file="{$aTemplatePathPlugin.admin}forms/order/tab.payments.tpl"}   {/capture}
{capture name='sTabHistory'}    {include file="{$aTemplatePathPlugin.admin}forms/order/tab.history.tpl"}    {/capture}
{capture name='sTabTasks'}      {include file="{$aTemplatePathPlugin.admin}forms/order/tab.tasks.tpl"}    {/capture}
{capture name='sTabOrders'}     {include file="{$aTemplatePathPlugin.admin}forms/order/tab.orders.tpl"}    {/capture}

{include file="{$aTemplatePathPlugin.admin}modal/modal.rejected.cause.tpl"}
{include file="{$aTemplatePathPlugin.admin}modal/modal.reclamation.cause.tpl"}

<div class="ls-clearfix" id="order">
    <div class="block w1">
        <div class="dflex">
            <div class="_item date">
                {component field template='date'
                label       = 'Дата оформления'
                value       = $oOrder->getDateAdd()|date_format:'d.m.Y'
                isDisabled  = true
                inputClasses    = 'date-add ajax-save'
                inputAttributes = ['data-field' => 'date_add', 'autocomplete' => 'off']}
            </div>
            <div class="_item date">
                {component field template='date'
                label       = 'Дата производства'
                value       = $oOrder->getDateManufactured()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'date_manufactured', 'autocomplete' => 'off']}
            </div>
            <div class="_item date">
                {component field template='date'
                label       = 'Дата отгрузки'
                value       = $oOrder->getDateShipment()
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'date_shipment', 'autocomplete' => 'off']}
            </div>
            <div class="_item date">
                {component field template='date'
                label           = 'Дата доставки'
                name            = 'order[date_delivery]'
                value           = $oOrder->getDateDelivery()|date_format:'d.m.Y'
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'date_delivery', 'autocomplete' => 'off']}
            </div>
            <div class="_item">
                {component field template='select'
                label           = 'Статус заказа'
                items           = Config::Get('order.status')
                classes         = 'order-status'
                inputClasses    = 'ajax-save'
                inputAttributes = ['data-field' => 'status']
                selectedValue   = $oOrder->getStatus()}
            </div>
        </div>
    </div>

    {* ВСЕ ДАННЕ БУДЕМ ОБНОВЛЯТЬ ЧЕРЕЗ AJAX чтобы видеть кто и что изменил в заказе*}

    <form action="" method="post" enctype="multipart/form-data">
        {component 'tabs' classes='' mods='align-top' tabs=[
        [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
        [ 'text' => 'Услуги',       'body' => $smarty.capture.sTabServices],
        [ 'text' => 'Доставка',     'body' => $smarty.capture.sTabDelivery,   uid => 'delivery'],
        [ 'text' => 'Документы',    'body' => $smarty.capture.sTabDocuments],
        [ 'text' => 'Оплаты',       'body' => $smarty.capture.sTabPayments],
        [ 'text' => 'История',      'body' => $smarty.capture.sTabHistory],
        [ 'text' => 'Задачи',       'body' => $smarty.capture.sTabTasks],
        [ 'text' => 'Заказы',       'body' => $smarty.capture.sTabOrders,  uid => 'user-orders']
        ]}
{*        [ 'text' => 'Производство', 'body' => $smarty.capture.sTabManufacture],*}
        <div class="cl" style="height: 20px;"></div>
        {*{component button text='Сохранить' mods='primary'}*}
    </form>

    <div id="modal-fabric-search" class="modal-win">
        <div class="modal-close"></div>
        <div class="title">Поиск ткани</div>
        <input type="text" class="fabrics-search autocomplete-pro">
        <small class="note">Начните вбивать название ткани. Затем кликните по нужному элементу, чтобы заменить ткань
        </small>
    </div>

    <div id="modal-payment" class="modal">
        <div class="modal-close"></div>
        <div class="title">Добавить оплату</div>
        {component field template='select'
        label           = 'Тип'
        items           = Config::Get('payment_type')
        inputClasses    = 'ajax-payment-type'
        inputAttributes = ['autocomplete' => 'off']}
        {component field template='select'
        label           = 'Назначение'
        items           = Config::Get('payment_name')
        inputClasses    = 'ajax-payment-name'
        inputAttributes = ['autocomplete' => 'off']}
        {component field template='text'
        label           = 'Сумма'
        inputClasses    = 'ajax-payment-sum'
        inputAttributes = ['autocomplete' => 'off']}
        {component field template='textarea'
        label           = 'Комментарий'
        rows            = 3
        inputClasses    = 'ajax-payment-comment'
        inputAttributes = ['autocomplete' => 'off']}
        <button class="btn" id="payment-add-1">Добавить</button>
    </div>

</div>
{*&load=SuggestView*}
{capture name='script'}
    <script src="//api-maps.yandex.ru/2.1/?lang=ru_RU&apikey=a2e77dc2-db83-44ed-aeaa-0078eaa591dc"></script>
    <script>
        let oInt,
            sOrderProductDesignId = null;
        $(function () {
            /**
             * Аякс обновление данных в заказе
             */
            $('.ajax-save').on('change', function(){
                let o = this;
                oInt = window.setTimeout(function(){
                    AjaxSave.call(o);
                }, 200);
            });
            function AjaxSave(){
                let oOrderProduct = $(this).parents('.order-product');
                sOrderProductDesignId = oOrderProduct.length ? oOrderProduct.data('product-design-id') : null;
                $(this).removeClass('ls-error');
                let sField = $(this).data('field'),
                    sValue;
                if (oOrderProduct.data('order-product-id')) {
                    iOrderProductId = oOrderProduct.data('order-product-id');
                }
                if($(this).attr('type') == 'checkbox') {
                    sValue = this.checked ? 1 : 0;
                } else {
                    sValue = $(this).val().toString();
                }
                let sTextConfirm = $(this).data('confirm');
                let bReturn = false;
                if (sTextConfirm) {
                    bReturn = !confirm(sTextConfirm + ' ' + sValue);
                }
                if (!bReturn) {

                let rejectedStatuses = ['failure', 'reclamation', 'failure-ready', 'return'];
                if (sField == 'status' && sValue == 'reclamation') {
                    /* Запрашиваем причину рекламации */
                    orderStatus = sValue;
                    const modal = $('#modal-reclamation-cause');
                    /* Получим список товаров в заказе подставим в форму и покажем ее */
                    ls.ajax.load(ADMIN_URL+'order/ajax/html-products-select/', { order_id: iOrderId }, function(answer) {
                        let select = modal.find('._item.rejected-type + .ls-field.order-product-id');
                        select.remove();
                        modal.find('._item.rejected-type').after(answer.html);
                        modal.find('._item.rejected-type + .ls-field.order-product-id select').selectStylized();
                        ModalShow(modal);
                    })

                    /* Причина рекламации из модального окна*/
                    $('#modal-reclamation-cause .rejected-cause-add').off('click').on('click', function(e){
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
                        ls.ajax.load(ADMIN_URL + 'order/ajax/rejected/', {
                            rejected: rejected
                        }, function (answer) {
                            if (answer.bStateError == false) {
                                ModalHide(true, $('#modal-reclamation-cause'));
                                $('#modal-reclamation-cause .rejected-cause').val('');
                                ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
                                    iOrderId: iOrderId,
                                    sOrderProductDesignId: sOrderProductDesignId,
                                    iOrderProductId: orderProductId,
                                    sField: sField,
                                    sValue: sValue
                                }, function (answ) {
                                    OrderDataUpdate(answ);
                                });
                            }
                        });
                        return false;
                    });
                } else if (sField == 'status' && rejectedStatuses.indexOf(sValue) != -1) {
                    /* Запрашиваем причину отказа */
                    ModalShow($('#modal-rejected-cause'));
                    $('#modal-rejected-cause').css({
                      left: scrolledX + (window.innerWidth - $('#modal-rejected-cause').innerWidth()) / 2
                    });

                    $('#modal-rejected-cause .rejected-cause-add').off('click').on('click', function (e) {
                      e.stopPropagation();
                      e.preventDefault();
                      let rejected = {},
                          rejectedType = $('#modal-rejected-cause .rejected-type').val(),
                          rejectedСause = $('#modal-rejected-cause .rejected-cause').val();
                      if (rejectedСause.length < 10) {
                        ls.msg.error('Укажите причину (минимум 10 символов)');
                        return false;
                      }

                      rejected.order_id = iOrderId;
                      rejected.order_product_id = iOrderProductId;
                      rejected.order_status = sValue;
                      rejected.rejected_type = rejectedType;
                      rejected.rejected_cause = rejectedСause;
                      ls.ajax.load(ADMIN_URL + 'order/ajax/rejected/', {
                        rejected: rejected
                      }, function (answer) {
                        if (answer.bStateError == false) {
                          ModalHide(true, $('#modal-rejected-cause'));
                          $('#modal-rejected-cause .rejected-cause').val('');
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
                      });
                      return false;
                    });
                  } else {
                    ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
                      iOrderId: {$oOrder->getId()},
                      sOrderProductDesignId: sOrderProductDesignId,
                      iOrderProductId: iOrderProductId,
                      sField: sField,
                      sValue: sValue
                    }, function (answ) {
                      OrderDataUpdate(answ);
                    });
                  }
                }
            };

            $('input[type="tel"]').mask('+7 (999) 999-99-99');

            /**
             * Редактирование тканей в заказе
             */
            var iFabricNumEdit = null;
            $('table.products .fabrics .edit').on('click', function () {
                iFabricNumEdit = $(this).data('num');
                sOrderProductDesignId = $(this).parents('.order-product').data('product-design-id');
                ModalShow($('#modal-fabric-search'));
            });
            $('.fabrics-search.autocomplete-pro').autocompletePro({
                name: 'fabric',
                name_search: 'search',
                url: '/ajax/search/fabric/',
                minLength: 1,
                render: function (obj) {
                    var item =
                        '<div class="row" data-id="' + obj.id + '" data-name="' + obj.title + ' (' + obj.supplier + ')">' +
                        '<div class="img"><img src="' + obj.image + '" width="100"></div>' +
                        '<span>' + obj.title + ' <br><span>' + obj.collection_title + ' (' + obj.supplier + ')</span> ' + (obj.hide == 1 ? ' <span style="color:#d60000;">(выведена)</span> ' : '') + '</span>' +
                        '</div>';
                    return item;
                }
            }, function (obj, item) {
                ls.ajax.load(ADMIN_URL + 'order/ajax/fabric/change/', {
                    iOrderId: {$oOrder->getId()},
                    sOrderProductDesignId: sOrderProductDesignId,
                    iNum: iFabricNumEdit,
                    iFabricId: obj.id,
                }, function (answ) {
                    $('table.products .fabrics .fabric' + iFabricNumEdit).html(obj.title + ' (' + obj.supplier + ')');
                    OrderDataUpdate(answ);
                });
                ModalHide(true, $('#modal-fabric-search'));
            });
            $('#modal-fabric-search .modal-close').on('click', function () {
                ModalHide(true, $('#modal-fabric-search'));
            });

            /**
             * Поиск агента
             */
            $('.agent.autocomplete-pro').autocompletePro({
                'name': 'agent',
                'name_search': 'search',
                'url': '/ajax/search/agent/',
                'minLength': 1,
                'render': function (obj) {
                    var item =
                        '<div class="row" data-id="' + obj.id + '" data-fio="' + obj.fio + '">' +
                        '<span>' + obj.fio + ' <br><span>' + obj.phone + ' // ' + obj.email + '</span> ' +
                        '</div>';
                    return item;
                }
            }, function (obj, item) {
                if (confirm("Вы действительно хотите выбрать агентом \"" + obj.fio + "\""))
                    ls.ajax.load(ADMIN_URL + 'order/ajax/change/', {
                        iOrderId: {$oOrder->getId()},
                        sField: 'agent_id',
                        sValue: obj.id
                    }, function (answ) {
                        $('.agent.autocomplete-pro').parents('._item').html('' +
                            '<div class="_item">' +
                            '   <div class="ls-field  ls-clearfix">\n' +
                            '       <label class="ls-field-label" for="">' + obj.fio + '</label>\n' +
                            '       <div class="ls-field pt-8 phone">' + obj.phone + ' // ' + obj.email + '</div>\n' +
                            '   </div>\n' +
                            '</div>')
                        OrderDataUpdate(answ);
                    })
                ModalHide(true, $('#modal-fabric-search'));
            });



            /**
             * Оплаты
             */
            $('#payment-add').on('click', function () {
                ModalShow($('#modal-payment'));
                return false;
            });
            $('#payment-add-1').on('click', function () {
                ls.ajax.load(ADMIN_URL + 'order/ajax/payment/add/', {
                    sPaymentType: $('.ajax-payment-type').val(),
                    sPaymentName: $('.ajax-payment-name').val(),
                    fPaymentSum: $('.ajax-payment-sum').val(),
                    sPaymentComment: $('.ajax-payment-comment').val(),
                    iOrderId: {$oOrder->getId()},
                }, function (answ) {
                    $('table#payments tr:first').after(answ.sTabPaymentTableTr);
                    if (typeof answ.sTabHistoryTableTr != 'undefined') {
                        $('table.history tbody').prepend(answ.sTabHistoryTableTr);
                    }
                    ModalHide(false, $('#modal-payment'));
                    window.location.reload();
                });
                return false;
            });
            $('#address').on('keyup keydown', function (e) {
                e.stopPropagation();
                if (e.keyCode == 13) return false;
            });

            /* Удаление опций */
            $('.order-product .options .option .remove').on('click', function(){
              let oOrderProduct = $(this).parents('.order-product');
              sOrderProductDesignId = oOrderProduct.length ? oOrderProduct.data('product-design-id') : null;
              iOrderProductId = oOrderProduct.data('order-product-id');
              let oOption = $(this).parents('.option'),
                iOption = oOption.data('id');
              ls.ajax.load(ADMIN_URL+'order/ajax/product/option/remove/', {
                iOrderId: iOrderId,
                sOrderProductDesignId: sOrderProductDesignId,
                iOrderProductId: iOrderProductId,
                iOption: iOption
              }, function(answ){
                oOption.remove();
                OrderDataUpdate(answ);
              });
            });

            /* Обновление даты добавления */
            $('h1').on('dblclick', function(){
                $('input.date-add').removeAttr('disabled').focus();
                AjaxSave.bind($('input.date-add')[0]);
                AjaxSave();
            });
        });

        /**
         * Обновляем данные заказа на страницу
         * @param answ
         * @constructor
         */
        function OrderDataUpdate(answ) {
            if (typeof answ.sTabHistoryTableTr != 'undefined') {
                $('table.history tbody').prepend(answ.sTabHistoryTableTr);
            }
            if (typeof answ.iAgentCommission != 'undefined') {
                $('[data-product-design-id="' + sOrderProductDesignId + '"').find('.agent-commission span').html(answ.iAgentCommission);
                if (answ.iAgentCommission < 0) ls.msg.error('Внимание! <br>Отрицательная маржинальность!',);
            }
            if (typeof answ.iPriceServicesAmount != 'undefined') {
                $('[data-product-design-id="' + sOrderProductDesignId + '"').find('.price-services-amount span').html(GetPrice(answ.iPriceServicesAmount, true));
            }
            if (typeof answ.iPriceServicesAmountMake != 'undefined') {
                $('[data-product-design-id="' + sOrderProductDesignId + '"').find('.price-services-amount-make span').html(GetPrice(answ.iPriceServicesAmountMake, true));
            }
            if (typeof answ.iPrice != 'undefined') {
                $('[data-product-design-id="' + sOrderProductDesignId + '"').find('.price span').html(GetPrice(answ.iPrice, true));
                $('.order-product[data-product-design-id="'+sOrderProductDesignId+'"] input[data-field="price"]').val(answ.iPrice);
            }
            if (typeof answ.iPriceMake != 'undefined') {
                $('[data-product-design-id="' + sOrderProductDesignId + '"').find('.price-make span').html(GetPrice(answ.iPriceMake, true));
                $('[data-product-design-id="' + sOrderProductDesignId + '"').find('.price-make').val(answ.iPriceMake);
            }
            if (typeof answ.iOrderMargin != 'undefined') {
                log('answ.iOrderMargin-' + answ.iOrderMargin);
                $('.order-margin').html(answ.iOrderMargin);
            }
        }


        ymaps.ready(init);

        let myMap, suggestView;

        function init() {
            suggestView = new ymaps.SuggestView('address', {
                results: 5,
                offset: [20, 30]
            });

            suggestView.events.add('select', function (e) {
                let sAddress = e.get('item').value;
                $('#address').val(sAddress);
                $('#address').trigger('change');
                // чистим интервал, чтобы не задублировать обновление
                clearInterval(oInt);
                let oPoint = myMap.geoObjects.get(0);
                myMap.geoObjects.remove(oPoint);
                SetPoint(sAddress);
            });

            myMap = new ymaps.Map('map', {
                center: [55.753994, 37.622093],
                zoom: 9
            });

            SetPoint($('#address').val());
        }

        function SetPoint(sAddress) {
            // Поиск координат центра Нижнего Новгорода.
            ymaps.geocode(sAddress, {
                /**
                 * Опции запроса
                 * @see https://api.yandex.ru/maps/doc/jsapi/2.1/ref/reference/geocode.xml
                 */
                // Сортировка результатов от центра окна карты.
                // boundedBy: myMap.getBounds(),
                // strictBounds: true,
                // Вместе с опцией boundedBy будет искать строго внутри области, указанной в boundedBy.
                // Если нужен только один результат, экономим трафик пользователей.
                results: 1
            }).then(function (res) {
                // Выбираем первый результат геокодирования.
                var firstGeoObject = res.geoObjects.get(0),
                    // Координаты геообъекта.
                    coords = firstGeoObject.geometry.getCoordinates(),
                    // Область видимости геообъекта.
                    bounds = firstGeoObject.properties.get('boundedBy');

                firstGeoObject.options.set('preset', 'islands#darkBlueDotIconWithCaption');
                // Получаем строку с адресом и выводим в иконке геообъекта.
                firstGeoObject.properties.set('iconCaption', firstGeoObject.getAddressLine());

                // Добавляем первый найденный геообъект на карту.
                myMap.geoObjects.add(firstGeoObject);
                // Масштабируем карту на область видимости геообъекта.
                myMap.setBounds(bounds, {
                    // Проверяем наличие тайлов на данном масштабе.
                    checkZoomRange: true
                });
            });
        }

        function ProductRepair(orderProductId) {
            iOrderProductId = orderProductId;
            ls.ajax.load(ADMIN_URL + 'order/ajax/product/repair/', {
                orderProductId: orderProductId
            }, function (answer) {
                if (answer.bStateError == false) {
                    $('select[data-field="status"]').val('reclamation').trigger('change');
                    $('select[data-field="status"]+.select-stylized ._selected ').html('Рекламация');
                    ls.msg.error('Не забудьте изменить дату доставки');
                    $('html, body').animate({ scrollTop: 0 }, 500);
                    $('input[data-field="date_delivery"]').focus('reclamation');
                }
            });
        }

        let managerComment = $('.manager-comment');
        managerComment.on('blur', function () {
            let sComment = $(this).val();
            ls.ajax.load(ADMIN_URL + 'order/ajax/comment/add/', {
                iOrderId: iOrderId,
                sComment: sComment
            }, function () {});
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}
