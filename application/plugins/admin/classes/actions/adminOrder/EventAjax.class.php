<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminOrder_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Обновляем данные в заказе
     */
    public function Change()
    {
        if (!LS::HasRight('2_order_change')) {
            $this->Message_AddErrorSingle('Недостаточно прав для редакитрования заказа');
            return parent::EventForbiddenAccess();
        }

        $oOrder = $this->Order_GetOrderById((int)getRequest('iOrderId'));
        if (!$oOrder) return $this->Message_AddErrorSingle('Заказ не найден');

        // товар в заказе. необязательно
        $sOrderProductDesignId = getRequestStr('sOrderProductDesignId');
        if ($sOrderProductDesignId) {
            $oOrderProduct = $oOrder->getProductByProductDesignId($sOrderProductDesignId);
            if (!$oOrderProduct) return $this->Message_AddErrorSingle('Товар в заказе не найден');
        }

        $sField = getRequestStr('sField');
        if (!$sField) return $this->Message_AddErrorSingle('Не передано поле');

        $sValue = getRequestStr('sValue');
        if (!isPost('sValue')) return $this->Message_AddErrorSingle('Не передано значение');

        $sComment = '';

        $oUserCurrent = LS::CurUsr();
        $oOrderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $oUserCurrent->getId(),
            'order_id' => $oOrder->getId(),
            'user_fio' => $oUserCurrent->getFio(),
            'date' => date('Y-m-d H:i:s'),
            'system' => 1
        ]);

        if (isset($oOrderProduct))
        {
            $oOrderComment->setOrderProductId($oOrderProduct->getId());
        }

        /**
         * Обновляем значение полей
         */
        switch ($sField) {
            /**
             * Статус
             */
            case 'status':
                if ($oOrder->getStatus() != $sValue) {
                    $sStatus = GetSelectText($sValue, 'order.status');
                    $sComment = 'Статус заказа изменён на "' . $sStatus . '"';
                    $oOrder->setStatus($sValue);
                    $oOrder->setStatusDateChange(date('Y-m-d H:i:s'));

                    /* Присвоим менеджером того кто первый изменил статус заказа*/
                    if (!$oOrder->getManagerId()) {
                        $oOrder->setManagerId($oUserCurrent->getId());
                    }
                }
                break;

            /**
             * Заказчик
             */
            case 'user_id':
                $oOrderUser = $this->User_GetById($sValue);
                if ($oOrderUser) {
                    $oOrder->setuserId($sValue);
                    $oOrder->Save();
                    $sComment = 'Заказчик изменен на "(' . $oOrderUser->getFio().') ' . $oOrderUser->getPhone(true) . '"';
                    $this->Viewer_AssignAjax('phone', $oOrderUser->getPhone());
                    $this->Viewer_AssignAjax('email', $oOrderUser->getEmail());
                    $this->Viewer_AssignAjax('fio', $oOrderUser->getFio());
                } else {
                    $this->Message_AddError('Пользователь с айди '.$sValue.' не найден');
                }
                break;

            /**
             * ФИО
             */
            case 'fio':
                $oUser = $oOrder->getUser();
                $oUser->setFio($sValue);
                $sComment = 'Имя клиента изменено на "' . $sValue . '"';
                $oUser->Save();
                break;

            /**
             * Email
             */
            case 'email':
                $oUser = $oOrder->getUser();
                $oUser->setEmail($sValue);
                $sComment = 'Email клиента изменен на "' . $sValue . '"';
                $oUser->Save();
                break;

            /**
             * Телефон
             */
            case 'phone':
                $oUser = $oOrder->getUser();
                $oUser->setPhone(NormalizePhone($sValue));
                $sComment = 'Телефон клиента изменен на "' . $sValue . '"';
                $oUser->Save();
                break;

            /**
             * Телефон доп.
             */
            case 'phone_dop':
                $oUser = $oOrder->getUser();
                $oUser->setPhoneDop(NormalizePhone($sValue));
                $sComment = 'Доп. телефон клиента изменен на "' . $sValue . '"';
                $oUser->Save();
                break;

            /**
             * Номер заказа агента
             */
            case 'agent_number':
                if ($oOrder->getAgentNumber()) {
                    $sComment = 'Номер заказа агента изменен на "' . $sValue . '"';
                } else {
                    $sComment = 'Назначен номер заказа агента "' . $sValue . '"';
                }
                $oOrder->setAgentNumber($sValue);
                break;

            /**
             * Дата добавления
             * для переноса заказа в другой месяц
             */
            case 'date_add':
                if (!LS::Adm()) {
                    return $this->Message_AddErrorSingle('Для изменения даты добавления нужны права администратора');
                }
                $sComment = 'Дата добавления изменена с ' . $oOrder->getDateAdd() . ' на ' . $sValue;

                if ($sValue) {
                    $oDate = new DateTime($sValue);
                    $oOrder->setDateAdd($oDate->format('Y-m-d H:i:s'));
                } else {
                    return $this->Message_AddErrorSingle('Дата добавления не может быть пустой');
                }
                break;

            /**
             * Дата изготовления
             */
            case 'date_manufactured':
                if ($oOrder->getDateManufactured()) {
                    $sComment = 'Дата изготовления изменена с ' . $oOrder->getDateManufactured() . ' на ' . $sValue;
                } else {
                    $sComment = 'Дата изготовления назначена на ' . $sValue;
                }
                if ($sValue) {
                    $oDate = new DateTime($sValue);
                    $oOrder->setDateManufactured($oDate->format('Y-m-d H:i:s'));
                } else {
                    $oOrder->setDateManufactured(NULL);
                    $sComment = 'Дата изготовления удалена';
                }
                break;

            /**
             * Дата отгрузки
             */
            case 'date_shipment':
                if ($oOrder->getDateShipment()) {
                    $sComment = 'Дата отгрузки изменена с ' . $oOrder->getDateShipment() . ' на ' . $sValue;
                } else {
                    $sComment = 'Дата отгрузки назначена на ' . $sValue;
                }
                if ($sValue) {
                    $oDate = new DateTime($sValue);
                    $oOrder->setDateShipment($oDate->format('Y-m-d H:i:s'));
                } else {
                    $oOrder->setDateShipment(NULL);
                    $sComment = 'Дата отгрузки удалена';
                }
                break;

            /**
             * Дата доставки
             */
            case 'date_delivery':
                if ($oOrder->getDateDelivery()) {
                    $sComment = 'Дата доставки изменена с ' . $oOrder->getDateDelivery() . ' на ' . $sValue;
                } else {
                    $sComment = 'Дата доставки назначена на ' . $sValue;
                }
                if ($sValue) {
                    $oDate = new DateTime($sValue);
                    $oOrder->setDateDelivery($oDate->format('Y-m-d H:i:s'));
                } else {
                    $oOrder->setDateDelivery(NULL);
                    $sComment = 'Дата доставки удалена';
                }
                break;

            /**
             * Самовывоз
             */
            case 'pickup':
                if ($sValue) {
                    $sComment = 'Назначен самовывоз';
                } else {
                    $sComment = 'Назначена доставка';
                }
                $oOrder->setPickUp($sValue);
                break;

            /**
             * Адрес
             */
            case 'address':
                if ($oOrder->getAddress()) {
                    $sComment = 'Адрес доставки изменен на "' . $sValue . '"';
                } else {
                    $sComment = 'Добавлен адрес доставки "' . $sValue . '"';
                }
                $oOrder->setAddress($sValue);
                $aAddressData = $this->Order_GetAddressData($sValue);
                $oOrder->setLongitude($aAddressData['longitude']);
                $oOrder->setLatitude($aAddressData['latitude']);
                break;

            /**
             * Этаж
             */
            case 'floor':
                if ($oOrder->getFloor()) {
                    $sComment = 'Этаж изменен на "' . $sValue . '"';
                } else {
                    $sComment = 'Добавлен этаж "' . $sValue . '"';
                }
                $oOrder->setFloor($sValue);
                break;

            /**
             * Лифт
             */
            case 'service_lift':
                if ($sValue) {
                    $sComment = 'Лифт изменён на грузовой';
                } else {
                    $sComment = 'Лифт изменён на пассажирский';
                }
                $oOrder->setServiceLift($sValue);
                break;

            /**
             * Ширина проёма
             */
            case 'door_width':
                if ($oOrder->getDoorWidth()) {
                    $sComment = 'Ширина проёма изменен на "' . $sValue . '"';
                } else {
                    $sComment = 'Добавлена ширина проёма "' . $sValue . '"';
                }
                $oOrder->setDoorWidth($sValue);
                break;

            /**
             * Комментарий
             */
            case 'comment':
                if ($oOrder->getComment()) {
                    $sComment = 'Комментарий заказа изменен на "' . $sValue . '"';
                } else {
                    $sComment = 'Добавлена комментарий заказа "' . $sValue . '"';
                }
                $oOrder->setComment($sValue);
                break;

            /**
             * Цена клиента
             */
            case 'price':
                $oOrderProduct->setPrice((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Цена клиента изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPrice', $oOrderProduct->getPrice());
                break;;

            /**
             * Цена фабрики
             */
            case 'price_make':
                $oOrderProduct->setPriceMake((int)$sValue);
                $oOrderProduct->Save();
                $oOrderComment->setSystem(2);
                $sComment = 'Цена фабрики изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceMake', $oOrderProduct->getPriceMake());
                break;

            /**
             * Доставка клиента
             */
            case 'price_delivery':
                $oOrderProduct->setPriceDelivery((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Доставка клиента изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmount', $oOrderProduct->getPriceServicesAmount());
                break;

            /**
             * Доставка фабрики
             */
            case 'price_delivery_make':
                $oOrderProduct->setPriceDeliveryMake((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Доставка экспедиторов изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmountMake', $oOrderProduct->getPriceServicesAmountMake());
                break;

            /**
             * Доставка МКАД(ТТК) клиента
             */
            case 'price_delivery_dop':
                $oOrderProduct->setPriceDeliveryDop((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Доставка МКАД(ТТК) клиента изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmount', $oOrderProduct->getPriceServicesAmount());
                break;

            /**
             * Доставка МКАД(ТТК) фабрики
             */
            case 'price_delivery_dop_make':
                $oOrderProduct->setPriceDeliveryDopMake((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Доставка МКАД(ТТК) экспедиторов изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmountMake', $oOrderProduct->getPriceServicesAmountMake());
                break;

            /**
             * Ст-ть заноса клиента
             */
            case 'price_zanosa':
                $oOrderProduct->setPriceZanosa((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Стоимость заноса клиента изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmount', $oOrderProduct->getPriceServicesAmount());
                break;

            /**
             * Ст-ть заноса фабрики
             */
            case 'price_zanosa_make':
                $oOrderProduct->setPriceZanosaMake((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Стоимость заноса экспедиторов изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmountMake', $oOrderProduct->getPriceServicesAmountMake());
                break;

            /**
             * Ст-ть сборки клиента
             */
            case 'price_sborki':
                $oOrderProduct->setPriceSborki((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Стоимость сборки клиента изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmount', $oOrderProduct->getPriceServicesAmount());
                break;

            /**
             * Ст-ть сборки фабрики
             */
            case 'price_sborki_make':
                $oOrderProduct->setPriceSborkiMake((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Стоимость сборки экспедиторов изменена на ' . GetPrice($sValue, true, true) . ' (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $this->Viewer_AssignAjax('iPriceServicesAmountMake', $oOrderProduct->getPriceServicesAmountMake());
                break;

            /**
             * Количество товара
             */
            case 'count':
                $oOrderProduct->setCount((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Количество изменено на ' . $sValue . ' шт. (' . $oOrderProduct->getTitle() . ')';
                $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
                $oOrderProduct->getOrder()->RecalcCounts();
                $this->Viewer_AssignAjax('iOrderMargin', $oOrderProduct->getOrder()->getMargin());
                break;

            /**
             * Ткань 1
             */
            case 'fabric1':
                $sValue = (float)str_replace(',', '.', $sValue);
                $oOrderProduct->setFabric1($sValue);
                $oOrderProduct->Save();
                $sComment = 'Метраж осн. ткани изменен на ' . $sValue . 'м. (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Ткань 2
             */
            case 'fabric2':
                $sValue = (float)str_replace(',', '.', $sValue);
                $oOrderProduct->setFabric2($sValue);
                $oOrderProduct->Save();
                $sComment = 'Метраж ткани комп. изменен на ' . $sValue . 'м. (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Ткань 3
             */
            case 'fabric3':
                $sValue = (float)str_replace(',', '.', $sValue);
                $oOrderProduct->setFabric3($sValue);
                $oOrderProduct->Save();
                $sComment = 'Метраж 3-й ткани изменен на ' . $sValue . 'м. (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Ткань 4
             */
            case 'fabric4':
                $sValue = (float)str_replace(',', '.', $sValue);
                $oOrderProduct->setFabric4($sValue);
                $oOrderProduct->Save();
                $sComment = 'Метраж 4-й ткани изменен на ' . $sValue . 'м. (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Столяры
             */
            case 'stolyary':
                $oOrderProduct->setStolyary((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Цех столяров изменен на ' . $sValue . '-й (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Столяры расценки
             */
            case 'stolyary_price':
                $oOrderProduct->setStolyaryPrice((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Расценка столяров изменена на ' . $sValue . ' (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Швеи
             */
            case 'shvei':
                $oOrderProduct->setShvei((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Цех швей изменен на ' . $sValue . '-й (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Швеи расценки
             */
            case 'shvei_price':
                $oOrderProduct->setShveiPrice((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Расценка швей изменена на ' . $sValue . ' (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Драпира
             */
            case 'drapera':
                $oOrderProduct->setDrapera((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Цех драпировки изменен на ' . $sValue . '-й (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Драпира расценки
             */
            case 'drapera_price':
                $oOrderProduct->setDraperaPrice((int)$sValue);
                $oOrderProduct->Save();
                $sComment = 'Расценка драпировки изменена на ' . $sValue . ' (' . $oOrderProduct->getTitle() . ')';
                break;

            /**
             * Агент
             */
            case 'agent_id':
                if ($oUser = $this->User_GetById((int)$sValue)) {
                    $oOrder->setAgentId($sValue);
                    $aFio = explode(' ', $oUser->getFio());
                    $sAgentNumber = '';

                    if (isset($aFio[0])) {
                        $sAgentNumber .= mb_substr($aFio[0], 0, 1);
                    }

                    if (isset($aFio[1])) {
                        $sAgentNumber .= mb_substr($aFio[1], 0, 1);
                    }

                    $oOrder->setAgentNumber($sAgentNumber.'-'.$oOrder->getId());
                    $sComment = 'Назначен агент "' . $oUser->getFio() . '"';
                }
                break;

            /**
             * Номер машины доставки
             */
            case 'car_number':
                $sComment = 'Машина изменена на "' . GetSelectText((int)$sValue, 'car_number') . '"';
                $oOrder->setCarNumber($sValue);
                break;

            /**
             * Фабрика
             */
            case 'make_id':
                $oOrderProduct = $this->Order_GetProductsById((int)getRequest('iOrderProductId'));
                $oMake = $this->Make_GetById((int)$sValue);
                $sComment = 'Фабрика изменена на "' . $oMake->getTitle() . '" для товара '. $oOrderProduct->getProductTitleFull();
                $oOrderProduct->setMakeId((int)$sValue);
                $oOrderProduct->Save();
                break;

            /**
             * Менеджер
             */
            case 'manager_id':
                $oManager = $this->User_GetById((int)$sValue);
                $sComment = 'Менеджер изменен на "' . $oManager->getFio() . '"';
                $oOrder->setManagerId((int)$sValue);
                break;

            /**
             * Цвет заказа
             */
            case 'color':
                $sComment = 'Цвет заказа изменен на "' . GetSelectText($sValue, 'colors') . '"';
                $oOrder->setColor($sValue);
                break;

            /**
             * Выплата агентских
             */
            case 'make_paid':
                if ($sValue == 1) {
                    $sComment = 'Агентские выплачены';
                    $oOrder->setMakePaid($sValue);
                } else {
                    $this->Message_AddErrorSingle('Нельзя убрать оплату');
                }
                break;

            /**
             * Выплата ЗП менеджеру
             */
            case 'manager_paid':
                if ($sValue == 1) {
                    $sComment = 'Менеджерские выплачены';
                    $oOrder->setManagerPaid($sValue);
                } else {
                    $this->Message_AddErrorSingle('Нельзя убрать оплату');
                }
                break;

            /**
             * Скидка
             */
            case 'discount':
                $oOrder->setDiscount((int)$sValue);
                $sComment = 'Скидка изменена на -'.(int)$sValue;
                break;

            /**
             * Ссылка на чат авито
             */
            case 'avito_chat_link':
                if ($oOrder->getAvitoChatLink() == '') {
                    $sComment = 'Добавлена ссылка на чат авито: '.$sValue;
                } else {
                    $sComment = 'Обновлена ссылка на чат авито: '.$sValue;
                }
                $oOrder->setAvitoChatLink($sValue);
                break;

            /**
             * Дополнительный чат
             */
            case 'dop_chat':
                if ($oOrder->getDopChat() == '') {
                    $sComment = 'Добавлен дополнительный чат: '.$sValue;
                } else {
                    $sComment = 'Обновлен дополнительный чат: '.$sValue;
                }
                $oOrder->setDopChat($sValue);
                break;

            default:
                break;

        }
        /**
         * Добавим комментарий
         */
        if ($sComment) {
            $oOrderComment->setField($sField); // поле для сортировки в истории
            $oOrderComment->setText($sComment);
            $oOrderComment->Add();
        }
        $oOrder->UpdatePrices();
        $this->Viewer_Assign('oComment', $oOrderComment);
        $this->Viewer_AssignAjax('sTabHistoryTableTr', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'forms/order/tab.history.table.tr.tpl'));
        $this->Message_AddNoticeSingle($sComment);
        $oOrder->Update();
    }

    /**
     * Меняем ткань в заказе
     */
    public function FabricChange()
    {
        $oOrder = $this->Order_GetOrderById((int)getRequest('iOrderId'));
        if (!$oOrder) return $this->Message_AddErrorSingle('Заказ не найден');

        // товар в заказе. необязательно
        $sOrderProductDesignId = getRequestStr('sOrderProductDesignId');
        if ($sOrderProductDesignId) {
            $oOrderProduct = $oOrder->getProductByProductDesignId($sOrderProductDesignId);
            if (!$oOrderProduct) return $this->Message_AddErrorSingle('Товар в заказе не найден');
        }

        $oFabric = $this->Media_GetByFilter([
            '#select' => ['t.*', 'c.supplier'],
            '#join' => ['INNER JOIN ' . Config::Get('db.table.collection') . ' c ON c.id = t.target_id'],
            '#where' => ['t.id = ?' => [(int)getRequest('iFabricId')]]
        ]);
        if (!$oFabric) return $this->Message_AddErrorSingle('Ткань не найдена');
        $iFabricNum = (int)getRequest('iNum');
        if (!in_array($iFabricNum, [1, 2, 3, 4])) return $this->Message_AddNoticeSingle('Неверно указан номер ткани');
        $sFunction = "setFabric{$iFabricNum}Id";
        $oOrderProduct->$sFunction($oFabric->getId());


        /**
         * Пересчитаю цену фабрики
         */
        $oProduct = $oOrderProduct->getProduct();
        $oProduct->setFabricArrayId($oOrderProduct->getFabricArrayId());
        $oProduct->PriceMakeRecalc();
        $oOrderProduct->setPriceMake($oProduct->getPriceMake());
        $oOrderProduct->Update();

        /**
         * Добавим комментарий
         */
        $oUserCurrent = LS::CurUsr();
        $sComment = 'Изменена ткань ' . $iFabricNum . ' на ' . $oFabric->getTitleFull();
        $oOrderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $oUserCurrent->getId(),
            'order_id' => $oOrder->getId(),
            'user_fio' => $oUserCurrent->getFio(),
            'date' => date('Y-m-d H:i:s'),
            'field' => 'fabric' . $iFabricNum . '_id',
            'text' => $sComment,
            'system' => 1
        ]);
        $oOrderComment->Add();
        $this->Viewer_Assign('oComment', $oOrderComment);
        $this->Viewer_AssignAjax('sTabHistoryTableTr', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'forms/order/tab.history.table.tr.tpl'));
        $this->Viewer_AssignAjax('iPriceMake', (int)$oOrderProduct->getPriceMake());
        $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
        $this->Message_AddNoticeSingle($sComment);
    }

    /**
     * Помечаем заказы как оплаченные
     */
    public function MarkAsMakePaid()
    {
        $orderProductIds = (array)getRequest('orderProductIds');
        $this->Order_MarkAsMakePaid($orderProductIds);
        $this->Order_ClosedByOrderProductIds($orderProductIds);
        $this->Message_AddNoticeSingle('Успешно отмечено как оплачен');
    }

    /**
     * Помечаем заказы как оплаченные
     */
    public function MarkAsManagerPaid()
    {
        $orderProductIds = (array)getRequest('orderProductIds');
        $this->Order_MarkAsManagerPaid($orderProductIds);
        $this->Order_ClosedByOrderProductIds($orderProductIds);
        $this->Message_AddNoticeSingle('Успешно отмечено как выплачено');
    }

    /**
     * Помечаем заказы как доставленные
     */
    public function MarkAsDelivered()
    {
        $orderProductIds = (array)getRequest('orderProductIds');
        $this->Order_MarkAsDelivered($orderProductIds);
        $this->Message_AddNoticeSingle('Успешно перенесено в доставленные');
    }

    /**
     * Добавление оплаты
     */
    public function PaymentAdd()
    {
        if (!LS::HasRight('18_order_payments')) {
            $this->Message_AddErrorSingle('Недостаточно прав для редакитрования оплат');
            return parent::EventForbiddenAccess();
        }
        $oOrder = $this->Order_GetOrderById((int)getRequest('iOrderId'));
        if (!$oOrder) return $this->Message_AddErrorSingle('Заказ не найден');
        $sType = getRequestStr('sPaymentType');
        if ($sType == '0') return $this->Message_AddErrorSingle('Выберите тип платежа');
        $sName = getRequestStr('sPaymentName');
        if ($sName == '0') return $this->Message_AddErrorSingle('Выберите назначение платежа');
        if (!ExistsSelectValue($sType, 'payment_name')) return $this->Message_AddErrorSingle('Неверное назначение платежа');
        $fSum = (float)getRequest('fPaymentSum');
        if (($fSum) == 0) return $this->Message_AddErrorSingle('Сумма должна быть больше нуля');
        $fSum = abs($fSum);
        if ($sType == 'agent_commission') $fSum = -$fSum;
        $oUserCurrent = LS::CurUsr();
        $oPayment = Engine::GetEntity('Order_Payments', [
            'order_id' => $oOrder->getId(),
            'type' => $sType,
            'name' => $sName,
            'sum' => $fSum,
            'comment' => getRequestStr('sPaymentComment'),
            'user_id' => $oUserCurrent->getId()
        ]);
        $oPayment->Add();
        $oPayment = $this->Order_getPaymentsById($oPayment->getId());
        $this->Viewer_Assign('oPayment', $oPayment);
        $this->Viewer_AssignAjax('sTabPaymentTableTr', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'forms/order/tab.payments.table.tr.tpl'));
        /**
         * Добавим комментарий
         */
        $oOrderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $oUserCurrent->getId(),
            'order_id' => $oOrder->getId(),
            'user_fio' => $oUserCurrent->getFio(),
            'date' => date('Y-m-d H:i:s'),
            'field' => 'payment',
            'text' => 'Добавлена оплата // ' . $oPayment->getTypeRu() . ' // ' . $oPayment->getSum(true, true),
            'system' => 1
        ]);
        $oOrderComment->Add();
        $this->Viewer_Assign('oComment', $oOrderComment);
        $this->Viewer_AssignAjax('sTabHistoryTableTr', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'forms/order/tab.history.table.tr.tpl'));
        $this->Message_AddNoticeSingle('Оплата успешно добавлена');
    }

    /**
     * Фиксируем причину отказа от заказа
     */
    public function Rejected()
    {
        $rejected = (array)getRequest('rejected');
        $orderRejected = $this->Order_GetRejectedByFilter([
            '#where' => [
                'order_id = ?d AND order_product_id = ?d AND order_status = ?' => [
                    $rejected['order_id'],
                    $rejected['order_product_id'],
                    $rejected['order_status']
                ]
            ]
        ]);
        if ($orderRejected) {
            return $this->Message_AddErrorSingle('У этого заказа (товара) уже есть причина отказа');
        }
        $orderRejected = Engine::GetEntity('Order_Rejected', $rejected);
        $orderRejected->Save();
        $userCurrent = LS::CurUsr();
        $orderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $userCurrent->getId(),
            'order_id' => $orderRejected->getOrderId(),
            'field' => 'comment',
            'date' => date('Y-m-d H:i:s'),
            'text' => $orderRejected->getRejectedCause(),
            'system' => 0
        ]);
        if ($orderRejected->getOrderProductId()) {
            $orderComment->setOrderProductId($orderRejected->getOrderProductId());
        }
        $orderComment->Save();
        $this->Message_AddNoticeSingle('Причина отказа успешно сохранена');
    }

    /**
     * Сортировка заказов
     */
    public function Sort()
    {
        $aOrder = getRequest('orders');

        if (count($aOrder)) {
            foreach ($aOrder as $iOrderId => $iSort) {
                $oOrder = $this->Order_GetById($iOrderId);

                if($oOrder instanceof ModuleOrder_EntityOrder) {
                    $oOrder->setSort($iSort);
                    $oOrder->Save();
                }
            }
            $this->Message_AddNoticeSingle('Сортировка успешно сохранена');
        }
    }

    public function CommentAdd()
    {
        $oOrder = $this->Order_GetById((int)getRequest('iOrderId'));
        if ($oOrder) {
            $sComment = getRequestStr('sComment');
            if ($sComment && $sComment != $oOrder->getLastCommentText()) {
                $oOrderComment = Engine::GetEntity('Order_Comments', [
                    'text' => getRequestStr('sComment'),
                    'field' => 'comment',
                    'system' => 0,
                    'user_id' => LS::CurUsr()->getId(),
                    'order_id' => $oOrder->getId()
                ]);
                $oOrderComment->Add();
                if ($oOrderComment->getId()) {
                    $this->Message_AddNoticeSingle('Комментарий успешно добавлен');
                } else {
                    $this->Message_AddErrorSingle('Ошибка при добавлении комментария');
                }
            }
            $date = new DateTime();
            $oOrder->setStatusDateChange($date->format('Y-m-d H:i:s'));
            $oOrder->Update();
        } else {
            $this->Message_AddErrorSingle('Заказ не найден');
        }
    }

    public function TaskAdd()
    {
        $aTask = getRequest('task');
        $oOrder = $this->Order_GetById((int)$aTask['order_id']);
        if ($oOrder) {
            $aTask['user_id'] = LS::CurUsr()->getId();
            if (!$aTask['date_time']) {
                return $this->Message_AddErrorSingle('Дата не выбрана');
            }
            $aTask['date_time'] = date('Y-m-d H:i:s', strtotime($aTask['date_time']));
            $oTask = Engine::GetEntity('Task', $aTask);
            $oTask->Add();
            if ($oTask->getId()) {
                $this->Message_AddNoticeSingle('Задача успешно добавлен');
            } else {
                $this->Message_AddErrorSingle('Ошибка при добавлении задачи');
            }
        } else {
            $this->Message_AddErrorSingle('Заказ не найден');
        }
    }

    public function TaskRemove()
    {
        $oTask = $this->Task_GetById((int)getRequest('task_id'));

        if ($oTask) {
            $oTask->delete();
            $this->Message_AddNoticeSingle('Задача удалена');
        } else {
            $this->Message_AddErrorSingle('Задача не найдена');
        }
    }

    public function TaskDone()
    {
        $oTask = $this->Task_GetById((int)getRequest('task_id'));
        $user = LS::CurUsr();
        $date = new DateTime();

        if ($oTask) {
            $oTask->setDone(1);
            $oTask->setUserIdDone($user->getId());
            $oTask->setDateTimeDone($date->format('Y-m-d H:i:s'));
            $oTask->Save();
            $this->Message_AddNoticeSingle('Задача выполнена');
        } else {
            $this->Message_AddErrorSingle('Задача не найдена');
        }
    }

    /**
     * Закрываем заказы
     */
    public function Closed()
    {
        if (!LS::HasRight('23_report')) {
            $this->Message_AddErrorSingle('Недостаточно прав для отчетов');
            return parent::EventForbiddenAccess();
        }
        if (!LS::HasRight('37_report_failure')) {
            $this->Message_AddErrorSingle('Нужны права "Отчет отказы" для закрытия заказов');
            return parent::EventForbiddenAccess();
        }

        $orderIds = getRequest('orderIds');
        $orders = $this->Order_GetItemsByArrayId($orderIds);
        if (count($orders) > 0) {
            foreach ($orders as $order) {
                $order->setClosed(1)->Update();
            }
        }
        $this->Message_AddNoticeSingle('Успешно выполнено');
    }

    public function ProductOptionsUpdate()
    {
        if (!LS::HasRight('2_order_change')) {
            $this->Message_AddErrorSingle('Недостаточно прав для редакитрования заказа');
            return parent::EventForbiddenAccess();
        }

        $oOrderProduct = $this->Order_GetProductsById((int)getRequest('iOrderProductId'));
        $aUserOptionsValues = $oOrderProduct->getUserOptionValues();
        $aUserOptionValuesEntity = $oOrderProduct->getUserOptionValuesEntity();
        $iPrice = $oOrderProduct->getPrice();
        /* Что обновляем */
        $aUserProductOptions = getRequest('aUserProductOptions');
        foreach($aUserProductOptions as $iIndex => $aOption) {
            $iOptionId = $aOption['name'];
            $iOptionValueId = $aOption['value'];
            $oOptionValue = null;
            $oUserCurrent = LS::CurUsr();
            $oOrderComment = Engine::GetEntity('Order_Comments', [
                'user_id' => $oUserCurrent->getId(),
                'order_id' => $oOrderProduct->getOrderId(),
                'user_fio' => $oUserCurrent->getFio(),
                'date' => date('Y-m-d H:i:s'),
                'field' => 'option',
                'system' => 1,
                'order_product_id' => $oOrderProduct->getId()
            ]);
            if (isset($aUserOptionValuesEntity[$iOptionId])) {
                /* Обновляем */
                $oOptionValue = $aUserOptionValuesEntity[$iOptionId];
                $iPrice -= $oOptionValue->getMargin();
                /* Получаем новое значение */
                $oOptionValue = $this->Option_GetValuesById($iOptionValueId);
                $iPrice += $oOptionValue->getMargin();
                $oOrderComment->setText('Обновлена опция "'.$oOptionValue->getOptionAlias().'" '.$oOptionValue->getTitle().' (+'.$oOptionValue->getMargin().')');
            } else {
                $oOptionValue = $this->Option_GetValuesById($iOptionValueId);
                $iPrice += $oOptionValue->getMargin();
                $oOrderComment->setText('Добавлена опция "'.$oOptionValue->getOptionAlias().'" '.$oOptionValue->getTitle().' (+'.$oOptionValue->getMargin().')');
            }
            $oOrderComment->Save();
            $aUserOptionsValues[$iOptionId] = $iOptionValueId;
        }
        $oOrderProduct->setUserOptionValues($aUserOptionsValues);
        $oOrderProduct->setPrice($iPrice);
        $oOrderProduct->Update();
        $this->Message_AddNoticeSingle('Опции успешно сохранены');
    }

    public function ProductAdd()
    {
        if (!LS::HasRight('2_order_change')) {
            $this->Message_AddErrorSingle('Недостаточно прав для редакитрования заказа');
            return parent::EventForbiddenAccess();
        }

        $order = $this->Order_GetOrderById((int)getRequest('order_id'));
        if (!$order) return $this->Message_AddErrorSingle('Заказ не найден');

        $product = $this->Product_GetById((int)getRequest('product_id'));

        if (!$product) return $this->Message_AddErrorSingle('Товар не найден не найден');

        $orderProduct = Engine::GetEntity('Order_Products',[
            'order_id' => $order->getId(),
            'product_id' => $product->getId(),
            'fabric_1' =>  $product->getFabric1(),
            'fabric_2' =>  $product->getFabric2(),
            'fabric_3' =>  $product->getFabric3(),
            'fabric_4' =>  $product->getFabric4(),
            'price' => $product->getPrice(),
            'price_make' => (int)$product->getPriceMake(),
            'price_delivery' => (int)$product->getPriceDelivery(),
            'price_delivery_make' => (int)$product->getPriceDeliveryMake(),
            'price_delivery_dop' => (int)$product->getPriceDeliveryDop(),
            'price_delivery_dop_make' => (int)$product->getPriceDeliveryDopMake(),
            'count' => 1,
            'guaranty' => $product->getGuaranty()

        ]);
        $orderProduct->setFabric1($product->getFabric1());
        $orderProduct->setFabric2($product->getFabric2());
        $orderProduct->setFabric3($product->getFabric3());
        $orderProduct->setFabric4($product->getFabric4());
        $orderProduct->Save();

        $userCurrent = LS::CurUsr();
        $oOrderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $userCurrent->getId(),
            'order_id' => $order->getId(),
            'user_fio' => $userCurrent->getFio(),
            'date' => date('Y-m-d H:i:s'),
            'field' => 'product',
            'text' => 'Добавлен товар "'.$product->getTitleFull().'"',
            'system' => 1,
            'order_product_id' => $orderProduct->getId()
        ]);
        $oOrderComment->Save();
        $this->Message_AddNoticeSingle('Товар успешно добавлен');
    }

    public function ProductOptionRemove()
    {
        if (!LS::HasRight('2_order_change')) {
            $this->Message_AddErrorSingle('Недостаточно прав для редакитрования заказа');
            return parent::EventForbiddenAccess();
        }

        $oOrder = $this->Order_GetOrderById((int)getRequest('iOrderId'));
        if (!$oOrder) return $this->Message_AddErrorSingle('Заказ не найден');

        // товар в заказе. необязательно
        $sOrderProductDesignId = getRequestStr('sOrderProductDesignId');
        if ($sOrderProductDesignId) {
            $oOrderProduct = $oOrder->getProductByProductDesignId($sOrderProductDesignId);
            if (!$oOrderProduct) return $this->Message_AddErrorSingle('Товар в заказе не найден');
        }

        if (!$oOrderProduct) {
            $oOrderProduct = $this->Order_GetProductsById((int)getRequest('iOrderProductId'));
        }

        $iOptionId = (int)getRequest('iOption');
        $oOption = $this->Option_GetById($iOptionId);

        if (!$oOption)  return $this->Message_AddErrorSingle('Опция не найдена');

        $oOptionValue = $oOrderProduct->getUserOptionValueEntityById($iOptionId);

        $oUserCurrent = LS::CurUsr();
        $oOrderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $oUserCurrent->getId(),
            'order_id' => $oOrder->getId(),
            'user_fio' => $oUserCurrent->getFio(),
            'date' => date('Y-m-d H:i:s'),
            'field' => 'option',
            'text' => 'Удалена опция "'.$oOptionValue->getAlias().'" '.$oOptionValue->getTitle().' (+'.$oOptionValue->getMargin().')',
            'system' => 1,
            'order_product_id' => $oOrderProduct->getId()
        ]);
        $oOrderComment->Save();

        $oOrderProduct->removeOption($iOptionId);
        $oOrderProduct->Update();

        $this->Viewer_AssignAjax('iAgentCommission', $oOrderProduct->getAgentCommission());
        $this->Viewer_AssignAjax('iPrice', $oOrderProduct->getPrice());
        $this->Viewer_Assign('oComment', $oOrderComment);
        $this->Viewer_AssignAjax('sTabHistoryTableTr', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'forms/order/tab.history.table.tr.tpl'));
        $this->Message_AddNoticeSingle($oOrderComment->getText());
    }

    /**
     * html код для модального окна для изменений опций
     */
    public function ProductOptionsHtml(){
        $iOrderProductId = (int)getRequest('iOrderProductId');
        $oOrderProduct = $this->Order_GetProductsById($iOrderProductId);
        if (!$oOrderProduct) return $this->Message_AddErrorSingle('Товар в заказе не найден');
        $this->Viewer_Assign('oOrderProduct', $oOrderProduct);
        $this->Viewer_Assign('sTemplatePathPluginAdmin', Plugin::GetTemplatePath($this));
        $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'product/options.tpl'));
    }

    public function ProductRepair()
    {
        $orderProductId = (int)getRequest('orderProductId');
        $orderProduct = $this->Order_GetProductsById($orderProductId);
        if (!$orderProduct) return $this->Message_AddErrorSingle('Товар в заказе не найден');

        $userCurrent = LS::CurUsr();
        $date = date('Y-m-d H:i:s');
        $message = 'Товар отмечен как ремонт ('.$orderProduct->getProduct()->getTitleFull().')';
        $orderComment = Engine::GetEntity('Order_Comments', [
                'user_id' => $userCurrent->getId(),
                'order_id' => $orderProduct->getOrderId(),
                'order_product_id' => $orderProductId,
                'user_fio' => $userCurrent->getFio(),
                'date' => $date,
                'field' => 'product',
                'text' => $message,
                'system' => 1
        ]);
        $orderComment->Save();
        $orderProduct->setRepair($date);
        $orderProduct->Update();
        $this->Message_AddNotice($message);
    }

    /**
     * Список товаров (select) в заказе
     */
    public function HtmlProductSelect()
    {
        $orderId = (int) getRequestStr('order_id');
        $order = $this->Order_GetById($orderId);
        if (!$order) return $this->Message_AddErrorSingle('Заказ не найден');
        $this->Viewer_Assign('orderProducts', $order->getProducts());
        $this->Viewer_AssignAjax('html', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__).'order/products.select.tpl'));
    }
}