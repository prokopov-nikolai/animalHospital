<?php

class PluginAdmin_ActionAdminOrder extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
//        $this->Viewer_AppendStyle(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/css/order.css');
        $this->AppendBreadCrumb(10, 'Заказы', 'order');
        $this->SetDefaultEvent('list');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^list$/i', '/^(page([\d]+))?$/i', 'OrderList');
        $this->AddEventPreg('/^tasks$/i', '/^(page([\d]+))?$/i', 'OrderTasks');
        $this->AddEventPreg('/^product$/i','/^delete$/i', '/^\d+$/i', 'OrderProductDelete');
        $this->AddEventPreg('/^delete$/i', '/^\d+$/i', 'OrderDelete');
        $this->AddEventPreg('/^salary$/i', 'OrderSalary');
        $this->AddEventPreg('/^delivery$/i', '/^map$/i', 'OrderDeliveryMap');
        $this->AddEventPreg('/^delivery$/i', 'OrderDelivery');
        $this->AddEventPreg('/^\d+$/i', 'OrderEdit');
        $this->AddEventPreg('/^print$/i', '/^labels$/i', 'OrderPrintLabels');
        $this->AddEventPreg('/^print$/i', '/^guaranty$/i', 'OrderPrintQuaranty');
        $this->AddEventPreg('/^print$/i', '/^passport-check$/i', 'OrderPrintPassportCheck');

        /**
         * Для ajax регистрируем внешний обработчик
         */
        $this->RegisterEventExternal('AjaxOrder', 'PluginAdmin_ActionAdminOrder_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^change$/i', '/^$/i', 'AjaxOrder::Change');
        $this->AddEventPreg('/^ajax$/i', '/^fabric$/i', '/^change$/i', '/^$/i', 'AjaxOrder::FabricChange');
        $this->AddEventPreg('/^ajax$/i', '/^payment$/i', '/^add$/i', 'AjaxOrder::PaymentAdd');
        $this->AddEventPreg('/^ajax$/i', '/^sort$/i', '/^$/i', 'AjaxOrder::Sort');
        $this->AddEventPreg('/^ajax$/i', '/^comment$/i', '/^add$/i', 'AjaxOrder::CommentAdd');
        $this->AddEventPreg('/^ajax$/i', '/^task$/i', '/^add$/i', 'AjaxOrder::TaskAdd');
        $this->AddEventPreg('/^ajax$/i', '/^task$/i', '/^remove$/i', 'AjaxOrder::TaskRemove');
        $this->AddEventPreg('/^ajax$/i', '/^task$/i', '/^done$/i', 'AjaxOrder::TaskDone');
        $this->AddEventPreg('/^ajax$/i', '/^mark-as-make-paid$/i', '/^$/i', 'AjaxOrder::MarkAsMakePaid');
        $this->AddEventPreg('/^ajax$/i', '/^mark-as-manager-paid$/i', '/^$/i', 'AjaxOrder::MarkAsManagerPaid');
        $this->AddEventPreg('/^ajax$/i', '/^mark-as-delivered$/i', '/^$/i', 'AjaxOrder::MarkAsDelivered');
        $this->AddEventPreg('/^ajax$/i', '/^rejected$/i', '/^$/i', 'AjaxOrder::Rejected');
        $this->AddEventPreg('/^ajax$/i', '/^closed$/i', '/^$/i', 'AjaxOrder::Closed');
        $this->AddEventPreg('/^ajax$/i', '/^product$/i', '/^option$/i', '/^remove/i', '/^$/i', 'AjaxOrder::ProductOptionRemove');
        $this->AddEventPreg('/^ajax$/i', '/^product$/i', '/^options$/i',  '/^update$/i', '/^$/i', 'AjaxOrder::ProductOptionsUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^product$/i', '/^options-html$/i', '/^$/i', 'AjaxOrder::ProductOptionsHtml');
        $this->AddEventPreg('/^ajax$/i', '/^product$/i', '/^add$/i', '/^$/i', 'AjaxOrder::ProductAdd');
        $this->AddEventPreg('/^ajax$/i', '/^product$/i', '/^repair$/i', '/^$/i', 'AjaxOrder::ProductRepair');
        $this->AddEventPreg('/^ajax$/i', '/^html-products-select$/i', '/^$/i', 'AjaxOrder::HtmlProductSelect');
    }

    /**
     * Список заказов
     */
    public function OrderList()
    {
        if (!LS::HasRight('1_order')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(20, '');
        $lost = getRequest('lost');
        $aFilter = [
            '#select' => [
                't.*',
                'op.id order_product_id, op.make_id',
                'u.fio user_fio, u.phone user_phone',
                'a.fio agent_fio, a.phone agent_phone',
                'p.title_full product_title_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order_products') . ' op ON op.order_id = t.id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = op.product_id',
                'INNER JOIN ' . Config::Get('db.table.category_filter') . ' c ON c.id = p.category_id',
                'INNER JOIN ' . Config::Get('db.table.user') . ' u ON u.id = t.user_id',
                'LEFT JOIN ' . Config::Get('db.table.user') . ' a ON a.id = t.agent_id'
            ],
            '#order' => ['t.sort' => 'asc', 't.date_add' => 'desc'],
            '#group' => ['id'],
            '#cache' => false
        ];
        $aFilter['#where'] = [];
        if ($lost) {
            $aFilter['#where']['TIMESTAMPDIFF(SECOND, t.status_date_change, CURRENT_TIMESTAMP()) > ?d'] = 86400;
        }
        if (count($_GET) == 0) {
            $aFilter['#where']['t.closed = ?d'] = 0;
        }

        /**
         * Даты
         */
        $oDateWeek = new DateTime('');
        if (getRequestStr('date_from')) {
            $oDateFrom = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_from')))) ;
        } else {
            $oDateFrom = new DateTime(date('01.m.Y'));
        }
        if (getRequestStr('date_to')) {
            $oDateTo = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_to')))) ;
        } else {
            $oDateTo = new DateTime(date('d.m.Y'));
        }

        $diff = $oDateTo->diff($oDateFrom);

        /**
         * Статус заказа
         */
        if ($aStatus = getRequest('status')) {
            $aFilter['#where']['t.status IN (?a)'] = $aStatus;
        }

        /**
         * Номер заказа агента
         */
        if ($sAgentNumber = getRequestStr('order_number')) {
            $aFilter['#where']['t.agent_number LIKE ?'] = '%'.$sAgentNumber.'%';
        }

        /**
         * Телефон
         */
        if ($sPhone = NormalizePhone(getRequestStr('phone'))) {
            $aFilter['#where']['u.phone = ?'] = $sPhone;
            $oUserByPhone = $this->User_GetByPhone($sPhone);
            $this->Viewer_Assign('oUserByPhone', $oUserByPhone);
        }
        $this->Viewer_Assign('sPhone', $sPhone);

        /**
         * Фабрика
         */
        $aMakeForSelect = $this->Make_GetListForSelect();
        $aMakeForSelect[-2] = [
            'text' => 'Выделить все',
            'value' => 'all'
        ];
        $aMakeForSelect[-1] = [
            'text' => 'Снять все',
            'value' => 'dall'
        ];
        ksort($aMakeForSelect);
        $this->Viewer_Assign('aMakeForSelect', $aMakeForSelect);
        $aMakeId = getRequest('make_id', []);
        $aMakeId = array_diff($aMakeId, ['all', 'dall']);
        if (count($aMakeId)) {
            $aMake = $this->Make_GetItemsByArrayId($aMakeId);
            $this->Viewer_Assign('aMake', $aMake);
            $aFilter['#where']['op.make_id IN (?a)'] = $aMakeId;
        } else {
            $aMakeId = [1000];
        }
        $this->Viewer_Assign('aMakeSelected', $aMakeId);

        /**
         * Источник
         */
        $agentIdSelected = getRequest('agent_id', []);
        foreach ($agentIdSelected as $i => $id) {
            if ($id == 0)
            {
                unset($agentIdSelected[$i]);
            }
        }
        if (count($agentIdSelected)) {
            $aFilter['#where']['t.agent_id IN (?a)'] = $agentIdSelected;
        }
        $this->Viewer_Assign('agentIdSelected', $agentIdSelected);

        /**
         * Менеджер
         */
        $managerIdSelected = getRequest('manager_id', []);
        foreach ($managerIdSelected as $i => $id) {
        if ($id == 0)
        {
            unset($managerIdSelected[$i]);
        }
    }
        if (count($managerIdSelected)) {
            $aFilter['#where']['t.manager_id IN (?a)'] = $managerIdSelected;
        }
        $this->Viewer_Assign('managerIdSelected', $managerIdSelected);
//        prex($aFilter['#where']);


        /* Дату не учитываем если идет поиск по номеру телефона или заказа */
        $sDateType = '';
        if (
            !key_exists('u.phone = ?', $aFilter['#where']) &&
            !key_exists('t.agent_number LIKE ?', $aFilter['#where'])
        ) {


            /**
             * Тип даты
             */
            $sDateType = getRequestStr('date_type');
            if (!$sDateType) $sDateType = 'date_add';

            if ($oDateFrom) {
                $aFilter['#where']['t.' . $sDateType . ' >= ?'] = $oDateFrom->format('Y-m-d 00:00:00');
            }

            if ($oDateTo) {
                $aFilter['#where']['t.' . $sDateType . ' <= ?'] = $oDateTo->format('Y-m-d 23:59:59');
            }
        }

        /**
         * Преобразуем фильтр
         */
        $sWhere = implode(' AND ', array_keys($aFilter['#where']));
        $aWhere = array_values($aFilter['#where']);
        $aFilter['#where'] = [];
        $aFilter['#where'][$sWhere] = $aWhere;

        $aResult = $this->Order_GetOrderItemsByFilter($aFilter);
        $aOrder = [];

        foreach ($aResult as $oOrder)
        {
            $aOrder[$oOrder->getStatus()][] = $oOrder;
        }

        $iMarginPlan = (int)Config::Get('margin_plan.'.$oDateFrom->format('Y-m'));

        $this->Viewer_Assign('managerSelect', $this->User_GetManagersForSelect());
        $this->Viewer_Assign('aAgentsSelect', $this->User_GetAgentsForSelect());
        $this->Viewer_Assign('aOrder', $aOrder);
        $this->Viewer_Assign('oDateFrom', $oDateFrom);
        $this->Viewer_Assign('oDateTo', $oDateTo);
        $this->Viewer_Assign('sDateType', $sDateType);
        $this->Viewer_Assign('daysDiff', $diff->days);
        $this->Viewer_Assign('daysMonth', $oDateTo->format('t'));
        $this->Viewer_Assign('aStatus', $this->Lang_Get('order.status'));
        $this->Viewer_Assign('aMakeSelect', $this->Make_GetListForSelect());
        $this->Viewer_Assign('iMarginPlan', $iMarginPlan);
        $this->SetTemplateAction('order.list');
    }

    /**
     * Выводим данные по заказу
     */
    public function OrderEdit()
    {
        if (!LS::HasRight('2_order_change')) return parent::EventForbiddenAccess();
        /**
         * Получим заказ по айди из урла
         */
        $iOrderId = Router::GetActionEvent();
        $aFilter = array(
            '#where' => array(
                't.id = ?' => array($iOrderId)
            ),
            '#with' => array('user', 'products', 'comments'),
            '#cache' => ''
        );
        if (!($oOrder = $this->Order_GetOrderByFilter($aFilter))) {
            return parent::EventNotFound();
        }
        $this->AppendBreadCrumb(20, $oOrder->getName(), '');
        $aProduct = array();
        foreach ($oOrder->getProducts() as $oP) {
            $aProduct[$oP->getKey()] = $oP;
        }
        $oOrder->setProducts($aProduct);
        $this->Viewer_Assign('userOrders', $this->Order_GetItemsByFilter([
            '#where' => [
                't.user_id = ?d' => [$oOrder->getUserId()]
            ],
            '#order' => ['t.id' => 'desc']
        ]));
        /* Телефон для связи */
        $phoneManager =Config::Get('phones.'.$oOrder->getAgentId());
        if (!$phoneManager) {
            $phoneManager = $oOrder->getAgentId(). ' // 8 (495) 134-37-36';
        }
        $this->Viewer_Assign('phoneManager', $phoneManager);
        $this->Viewer_Assign('oOrder', $oOrder);
        $this->Viewer_Assign('aStatus', $this->Lang_Get('plugin.shop.order_status'));
        $this->Viewer_Assign('aStatusClass', $this->Lang_Get('plugin.shop.order_class'));
        $this->Viewer_Assign('aOption', $this->Option_GetItemsAll());
        $this->Viewer_Assign('aMakeSelect', $this->Make_GetListForSelect());
        $this->Viewer_Assign('aAgentsSelect', $this->User_GetAgentsForSelect());
        $this->Viewer_Assign('aManagersSelect', $this->User_GetManagersForSelect());
        $this->SetTemplateAction('order');
    }

    /**
     * Удаляем заказ
     */
    public function OrderDelete()
    {
        if (!LS::HasRight('30_order_delete')) return parent::EventForbiddenAccess();
        $iOrderId =$this->GetParamEventMatch(0, 0);
        $oOrder = $this->Order_GetById($iOrderId);
        if (!$oOrder) return parent::EventNotFound();
        if (count($oOrder->getPayments())) {
            $this->Message_AddErrorSingle('Нельзя удалить заказ, т.к. есть оплаты', false, true);
        } else {
            $this->Message_AddErrorSingle('Заказ №' . $oOrder->getId() . ' удален', false, true);
            $oOrder->Delete();
        }
        return Router::Location($_SERVER['HTTP_REFERER']);
    }

    /**
     * Печать бирок для заказов
     */
    public function OrderPrintLabels()
    {
        if (!LS::HasRight('2_order_change')) return parent::EventForbiddenAccess();
        require_once Config::Get('path.root.server') . '/application/libs/vendor/pdf/fpdf.php';
        require_once Config::Get('path.root.server') . '/application/libs/vendor/phpqrcode/qrlib.php';
        $aId = explode(',', getRequestStr('id'));
        $aOrder = $this->Order_GetItemsByArrayId($aId);
        $oPdf = new FPDF('P', 'mm', 'A4');
        $oPdf->AddFont('OpenSans', '', 'opensans.php');
        $oPdf->SetTitle('Birki');
        $oPdf->AddPage();
        $oPdf->SetAutoPageBreak(false);
        $iLabelCount = 0;
        $iCount = 0;
        foreach ($aOrder as $mKey => $oOrder) {
            $sOrderPath = Config::Get('path.root.web') . '/order/show/' . $oOrder->getGuid() . '/';
            $oUserAgent = $oOrder->getAgent();
            foreach ($oOrder->getProducts() as $oOrderProduct) {
                $oProduct = $oOrderProduct->getProduct();
                $n = $oProduct->getCharValueById(36);
                for ($i = 1; $i <= $n; $i++) {
                    $sY = $oPdf->GetY();
                    $oPdf->SetY($sY);
                    $oPdf->SetX(10);
                    /**
                     * Выводим qr-code только для диванов с шильдиков. Они должны быть качественные
                     */
                    $iDx = 0;
                    if ($oOrder->getNameplate()) {
                        $oPdf->Image($this->Fs_GetPathServerFromWeb(Config::Get('path.root.web') . GetQRCodeImagePath($sOrderPath)));
                        $iDx = 45;
                    }
                    $oPdf->SetFont('OpenSans', '', 44);
                    $oPdf->SetY($sY);
                    $oPdf->SetX(10+$iDx);
                    $oPdf->MultiCell(195 - $iDx, 15, iconv('UTF-8', 'cp1251', mb_strtoupper(($oUserAgent ? $oUserAgent->getFio() : 'FISHER-STORE.RU') .' '.($oOrder->getAgentNumber() ? $oOrder->getAgentNumber() : 'F-'.$oOrder->getId()) )));
                    $oPdf->SetX(10+$iDx);
                    $oPdf->MultiCell(195 - $iDx, 15, iconv('UTF-8', 'cp1251', mb_strtoupper((
                            ($oProduct->getCategoryId() == 2) ? 'УГОЛ ' :
                                (($oProduct->getCategoryId() == 1) ? 'ДИВАН ' : $oOrderProduct->getProductPrefix().' ')
                        ) .
                        $oOrderProduct->getProductTitle()
                    )));
                    $oPdf->SetFont('OpenSans', '', 24);
                    $oPdf->SetX(10+$iDx);
                    $oPdf->MultiCell(195 - $iDx, 15, iconv('UTF-8', 'cp1251', 'Место '.$i.' из '.$n));
                    $sFabrics = '';
                    foreach ([1, 2, 3, 4] as $iNum) {
                        if ($oOrderProduct->getFabricLength($iNum) > 0) {
                            $oFabric = $oOrderProduct->getFabric($iNum);
                            if ($iNum > 1 && $oFabric) $sFabrics .= " // ";
                            if ($oFabric) $sFabrics .= "{$oFabric->getAlt()} ({$oFabric->getSupplier()})";
                        }
                    }
                    $oPdf->SetX(10+$iDx);
                    $oPdf->MultiCell(195 - $iDx, 15, iconv('UTF-8', 'cp1251', $sFabrics));
                    $oPdf->Ln(15);
                    $iLabelCount++;
//                    if ($iLabelCount % 4 == 0 && next($aOrder)) {
                    if ($iLabelCount % 3 == 0) {
                        $oPdf->AddPage();
                    }
                }
            }
            $iCount++;
            if ($iCount != count($aOrder)) {
                $oPdf->Line(5, $oPdf->GetY(), 200, $oPdf->GetY());
                $oPdf->Ln(10);
            }
        }
        $oPdf->Output();
    }

    /**
     * Печать паспорта дивана и товарного чека
     */
    public function OrderPrintPassportCheck()
    {
        if (!LS::HasRight('2_order_change')) return parent::EventForbiddenAccess();
        require_once Config::Get('path.root.server') . '/application/libs/vendor/pdf/fpdf.php';
        require_once Config::Get('path.root.server') . '/application/libs/vendor/phpqrcode/qrlib.php';
        $iId = (int)getRequestStr('id');
        $oOrder = $this->Order_GetById($iId);
        if (!$oOrder->getDateDelivery()) return parent::EventError('Не указана дата доставки');
        $oPdf = new FPDF('L', 'mm', 'A4');
        $oPdf->AddFont('Times', '', 'times.php');
        $oPdf->AddFont('TimesBold', '', 'timesb.php');
        $oPdf->AddFont('OpenSans', '', 'opensans.php');
        $oPdf->SetTitle(ToRu('Passport '.$oOrder->getAgentNumber()));

        foreach ($oOrder->getProducts() as $oOrderProduct) {
            $oPdf->AddPage();
            $oPdf->Image(Config::Get('path.root.server') . '/application/frontend/skin/fisher/assets/images/nikolay_logo_upd.jpg', 57, 5, 30, 20);
            $oPdf->SetLeftMargin(7);
            $oPdf->setX(7);
            $oPdf->setY(12);
            $oPdf->SetFont('OpenSans', '', 10);
            $oPdf->MultiCell(135, 4, ToRu("\n\nФабрика мягкой мебели"), 0, 'C');
            $oPdf->SetFont('OpenSans', '', 9);
            $oPdf->MultiCell(135, 3, ToRu("nikolai-prokopov.ru"), 0, 'C');
            $oPdf->SetFont('TimesBold', '', 10);
            $oPdf->MultiCell(135, 5, ToRu("\nМЕБЕЛЬНОЕ ПРЕДПРИЯТИЕ «ИП Прокопов Н.И.»\nПАСПОРТ"), 0, 'C');
            $oPdf->SetFont('Times', '', 10);
            $oPdf->MultiCell(135, 10, ToRu($oOrderProduct->getProductTitleFull()), 0, 'C');
            $oPdf->SetFont('TimesBold', '', 9);
            $oPdf->MultiCell(135, 5, ToRu("Памятка по эксплуатации и уходу за мебелью."), 0, 'C');
            $oPdf->SetFont('Times', '', 8);
            $oPdf->MultiCell(135, 3, ToRu("   Сохранность мебели и ее срок службы зависит не только от качества материалов и изготовления, но также уход за мебелью при ее эксплуатации. Необходимо помнить, что изделия мебели можно эксплуатировать в сухих проветриваемых помещениях при температуре 10-28*С и относительной влажностью воздуха 50-70%. Сырость  и близкое расположение источников тепла вызывают ускоренное старение лакокрасочного покрытия и материала обивки, а также вызывает деформацию деревянных элементов мебели. Необходимо оберегать лакированные поверхности от попадания на них любых активных  жидкостей (спирта, бензина, кислот и т.д.). Лакированные поверхности мебели следует протирать сухой мягкой тканью (фланель, сукно, плюш). При выведение пятен с обивки мягких элементов рекомендуется применять бытовые средства для чистки мебели, предварительно убедившись в безопасности их применения в незаметном месте. При ослаблении узлов болтовых соединений необходимо периодически их подтягивать. "), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("    Предприятие – изготовитель гарантирует покупателю сохранение всех качественных показателей мебели, обусловленных ГОСТ 19917-2014 при условии соблюдения правил транспортировки, установки, эксплуатации."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("     Гарантийный срок эксплуатации – 18 месяцев."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("     Условия гарантии."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("1. Данным паспортом фирма – изготовитель подтверждает отсутствие каких-либо дефектов в  купленном вами изделии и обязуется обеспечить бесплатный ремонт в течении гарантийного срока."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("2. Бесплатный ремонт производится только в течении гарантийного срока."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("3. Изделие снимается с гарантии в следующих случаях, если:"), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("• Изделие имеет следы постороннего вмешательства, или была попытка самостоятельного ремонта;\n• Обнаружены несанкционированные изменения конструкции;\n• Изделие эксплуатировалось не в соответствии со своим целевым назначение, или в условиях, для которых оно не предназначено (мебель для отдыха)"), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("4. Гарантия не распространяется на следующие неисправности:"), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("• Механические повреждения;\n• Попадание на изделие едких веществ и жидкостей."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("При обнаружении дефектов следует обращаться в магазин, где приобретена мебель, с предъявлением чека, удостоверяющего дату приобретения мебели в магазине."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("При покупке мебели требуйте наличие штампа и даты продажи. Без отметки торгующей организации – гарантия не действительна."), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->Ln(2);
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("Дата продажи " . $oOrder->getDateDelivery()), 0, 'L');
            $oPdf->Ln(2);
            $oPdf->Ln(2);
            $oPdf->Ln(2);
            $oPdf->Ln(2);
            $oPdf->MultiCell(135, 3, ToRu("Штамп магазина___________________________"), 0, 'L');
            /**
             * Товарный чек
             */
            $aMonth = [
                '',
                'января',
                'февраля',
                'марта',
                'апреля',
                'мая',
                'июня',
                'июля',
                'августа',
                'сентября',
                'октября',
                'ноября',
                'декабря'
            ];
            $oPdf->SetLeftMargin(155);
            $oPdf->setX(155);
            $oPdf->setY(10);
            $oPdf->MultiCell(135, 3, ToRu("Фирма: ИП Прокопов Н.И."), 0, 'L');
            $oPdf->MultiCell(135, 3, ToRu("Дата  «{$oOrder->getDateDelivery('d')}» {$aMonth[$oOrder->getDateDelivery('n')]} {$oOrder->getDateDelivery('Y')} г."), 0, 'R');
            $oPdf->Ln(2);
            $oPdf->SetFont('TimesBold', '', 12);
            $oPdf->MultiCell(135, 10, ToRu("ТОВАРНЫЙ ЧЕК"), 0, 'C');
            $oPdf->setLineWidth(.4);
            $oPdf->Line(155, 30, 290, 30);

            // шапка
            $oPdf->setX(155);
            $oPdf->setY(30);
            $oPdf->SetFont('TimesBold', '', 8);
            $oPdf->setLineWidth(.1);
            $oPdf->MultiCell(60, 8, ToRu("Наименование товара"), 1, 'C');
            $oPdf->SetLeftMargin(215);
            $oPdf->setY(30);
            $oPdf->MultiCell(15, 8, ToRu("Кол-во"), 1, 'C');
            $oPdf->SetLeftMargin(230);
            $oPdf->setY(30);
            $oPdf->MultiCell(25, 8, ToRu("Цена"), 1, 'C');
            $oPdf->SetLeftMargin(255);
            $oPdf->setY(30);
            $oPdf->MultiCell(35, 8, ToRu("Сумма"), 1, 'C');

            // товар
            $iH = 8;
            $oPdf->setLineWidth(.4);
            $oPdf->Line(155, 30 + $iH, 290, 30 + $iH);
            $oPdf->SetLeftMargin(155);
            $oPdf->setY(30 + $iH);
            $oPdf->SetFont('Times', '', 8);
            $oPdf->setLineWidth(.1);
            $oPdf->MultiCell(60, $iH, ToRu($oOrderProduct->getProductTitleFull()), 1, 'C');
            $oPdf->SetLeftMargin(215);
            $oPdf->setY(30 + $iH);
            $oPdf->MultiCell(15, $iH, $oOrderProduct->getCount(), 1, 'C');
            $oPdf->SetLeftMargin(230);
            $oPdf->setY(30 + $iH);
            $oPdf->MultiCell(25, $iH, ToRu($oOrderProduct->getPrice(true, true)), 1, 'C');
            $oPdf->SetLeftMargin(255);
            $oPdf->setY(30 + $iH);
            $oPdf->MultiCell(35, $iH, ToRu(GetPrice($oOrderProduct->getCount() * $oOrderProduct->getPrice(), true, true)), 1, 'C');
            $oPdf->setLineWidth(.4);
            $oPdf->Line(155, 30 + $iH * 2, 290, 30 + $iH * 2);
            $oPdf->Ln(2);
            $oPdf->SetLeftMargin(155);
            $oPdf->SetX(155);
            $oPdf->MultiCell(135, $iH, ToRu("Всего: " . PriceString($oOrderProduct->getCount() * $oOrderProduct->getPrice())), 0, 'L');
            $oPdf->SetX(200);
            $oPdf->MultiCell(135, $iH, ToRu("Подпись продавца: ______________________________________________"), 0, 'L');
        }
        $oPdf->Output();
    }

    /**
     * Гарантийный талон
     */
    public function OrderPrintQuaranty()
    {
        if (!LS::HasRight('2_order_change')) return parent::EventForbiddenAccess();
        require_once Config::Get('path.root.server') . '/application/libs/vendor/pdf/fpdf.php';
        require_once Config::Get('path.root.server') . '/application/libs/vendor/phpqrcode/qrlib.php';
        $iId = (int)getRequestStr('id');
        $oOrder = $this->Order_GetById($iId);
        $oPdf = new FPDF('P', 'mm', 'A4');
        $oPdf->AddFont('Times', '', 'times.php');
        $oPdf->AddFont('TimesBold', '', 'timesb.php');
        $oPdf->AddFont('OpenSans', '', 'opensans.php');
        $oPdf->SetTitle(ToRu('Guaranty '.$oOrder->getAgentNumber()));
        $oPdf->SetAutoPageBreak(false);

//        $sOrderPath = Config::Get('path.root.web') . '/order/show/' . $oOrder->getGuid() . '/';
        $sOrderPath = Config::Get('path.root.web') . 'https://nikolai-prokopov.ru/order/show/' . $oOrder->getGuid() . '/';
//        $oUserAgent = $oOrder->getAgent();

        foreach ($oOrder->getProducts() as $oOrderProduct) {
            $oPdf->AddPage();
            $oPdf->Image(Config::Get('path.root.server') . '/application/frontend/skin/fisher/assets/images/nikolay_logo_upd.jpg', 89, 5, 30, 20);
            $oPdf->Image($this->Fs_GetPathServerFromWeb(Config::Get('path.root.web') . GetQRCodeImagePath($sOrderPath)), 170, 5, 30, 30);
            $oPdf->SetLeftMargin(7);
            $oPdf->setX(7);
            $oPdf->setY(12);
            $oPdf->SetFont('OpenSans', '', 10);
            $oPdf->MultiCell(195, 4, ToRu("\n\nФабрика мягкой мебели"), 0, 'C');
            $oPdf->SetFont('OpenSans', '', 9);
            $oPdf->MultiCell(195, 3, ToRu("nikolai-prokopov.ru"), 0, 'C');
            $oPdf->SetFont('TimesBold', '', 12);
            $oPdf->MultiCell(195, 5, ToRu("\nГарантийный талон №" . $oOrder->getId()), 0, 'C');
            $iH = 6;
            $iL = 1;

            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->SetFont('Times', '', 12);
            $oPdf->MultiCell(97, $iH, ToRu("Изделие"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu($oOrderProduct->getProductTitleFull()), 1, 'L');

            $iL = 2;
            $oPdf->SetFont('TimesBold', '', 12);
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("ЦЕНА"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu($oOrderProduct->getPrice(true, true)), 1, 'L');

            $iL = 3;
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("ВСЕГО К ОПЛАТЕ"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu($oOrderProduct->getPrice(true, true)), 1, 'L');

            $iL = 4;
            $oPdf->SetFont('Times', '', 12);
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("Целевое предназначение"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("Бытовой"), 1, 'L');

            $iL = 5;
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("Гарантиыйн срок"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("18 месяцев"), 1, 'L');

            $iL = 6;
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH * 2, ToRu("Обивочная ткань"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $sFabrics = '';
            foreach ([1, 2, 3, 4] as $iNum) {
                if ($oOrderProduct->getFabricLength($iNum) > 0) {
                    if ($iNum > 1) $sFabrics .= " // ";
                    $oFabric = $oOrderProduct->getFabric($iNum);
                    if ($oFabric) $sFabrics .= "{$oFabric->getAlt()} ({$oFabric->getSupplier()})";
                }
            }
            $oPdf->MultiCell(97, $iH * 2, ToRu($sFabrics), 1, 'L');

            $iL = 8;
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH * 2, ToRu("Адрес доставки"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH * 2, ToRu($oOrder->getAddress()), 1, 'L');

            $iL = 10;
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("ФИО"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu($oOrder->getUser()->getFio()), 1, 'L');

            $iL = 11;
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu("Телефон"), 1, 'L');
            $oPdf->SetLeftMargin(104);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(97, $iH, ToRu($oOrder->getUser()->getPhone(true)), 1, 'L');

            $iL = 12;
            $oPdf->SetFont('TimesBold', '', 10);
            $oPdf->SetLeftMargin(7);
            $oPdf->setY(33 + $iH * $iL);
            $oPdf->MultiCell(197, 6, ToRu("Условия гарантии:"), 0, 'C');
            $oPdf->SetFont('Times', '', 10);
            $oPdf->MultiCell(197, 4, ToRu("1.Срок гарантии изделия - 18 месяцев со дня изготовления. Гарантийный срок начинается с момента доставки изделия клиенту домой.
2 .Гарантийное обслуживание включает в себя проведение ремонтных работ и замену дефектных частей изделий. Срок гарантий в таком случае продлевается на  время нахождения изделия в ремонте.
3. Недостатки изделий, выявленные в течение гарантийного срока и возникшие по вине Фабрики, будут бесплатно устранены Сервисной Службой Фабрики.
4. Претензии по внешнему виду изделия, некомплекту, а также несоответствию заказа принимаются только при получении изделия. В дальнейшем такие  претензии не принимаются, все работы осуществляются только за счет покупателя.
5.  Талон подписывается продавцом и покупателем."), 0, 'L');

            $oPdf->SetFont('TimesBold', '', 10);
            $oPdf->MultiCell(197, 4, ToRu("Случаи, когда не производится гарантийное обслуживание:"), 0, 'C');
            $oPdf->SetFont('Times', '', 10);
            $oPdf->MultiCell(197, 4, ToRu("Истечение гарантийного срока.
Невыполнения условий эксплуатации, при эксплуатации мебели в сырых помещениях.
Наличие на изделии механических повреждений.
Превышения допустимых нагрузок на механизмы трансформации.
Нанесения ущерба изделию или его утери вследствие обстоятельств непреодолимой силы (стихия, пожар, наводнение, несчастный случай, использование некачественных средств по уходу за мебелью и т.д.).
Нанесения ущерба изделию в результате умышленных или ошибочных действий потребителя.
Нанесения ущерба изделию, вызванного попаданием внутрь изделия посторонних предметов, жидкостей, животных, насекомых и т.д.
Наличия следов постороннего вмешательства в изделие или ремонт изделия самостоятельно либо организациями, предприятиями или частными лицами, не уполномоченными на это Фабрикой.
Нанесения ущерба изделию в результате внесения изменений в его конструкцию.
Использования изделия в производственных целях.
На обивку и чехлы подушек, выполненных в ткани покупателя.
В этих случаях сервисное обслуживание производится за счет покупателя по Фабричным расценкам."), 0, 'L');

            $oPdf->SetFont('TimesBold', '', 10);
            $oPdf->MultiCell(197, 4, ToRu("Дефектами мебели не являются:"), 0, 'C');
            $oPdf->SetFont('Times', '', 10);
            $oPdf->MultiCell(197, 4, ToRu("Незначительные отличия  в оттенках и фактуре облицовочных тканей и кож.
Незначительные отличия  в оттенках  цвета и отличие рисунка лакокрасочного покрытия (декора).
Легкие складки на облицовочном материале мягких элементов, возникающие после снятия нагрузок и исчезающие после легкого разглаживания рукой.
Отклонение от габаритных размеров ± 2-3см. на одно изделие (согласно ГОСТ 19917-2014).
Мелкие волосяные трещины (эффект растрескивания), потертости мебельного покрытия из натуральной кожи, возникшие в процессе эксплуатации мебели.
Претензии по загрязнению изделий, возникшие в процессе эксплуатации мебели, НЕ ПРИНИМАЮТСЯ!"), 0, 'L');
            $oPdf->MultiCell(197, $iH + 2, ToRu("ТОВАР ОСМОТРЕН, ПРЕТЕНЗИЙ НЕ ИМЕЮ:"), 0, 'L');

            $aMonth = [
                '',
                'января',
                'февраля',
                'марта',
                'апреля',
                'мая',
                'июня',
                'июля',
                'августа',
                'сентября',
                'октября',
                'ноября',
                'декабря'
            ];
            $oPdf->SetLeftMargin(7);
            $iY = $oPdf->getY();
            $oPdf->MultiCell(195, $iH * 2, ToRu("Покупатель ___________    _________________________ «{$oOrder->getDateDelivery('d')}» {$aMonth[$oOrder->getDateDelivery('n')]} {$oOrder->getDateDelivery('Y')} г."), 0, 'L');
            $oPdf->MultiCell(195, $iH * 2, ToRu("Продавец     ___________    _________________________ «{$oOrder->getDateDelivery('d')}» {$aMonth[$oOrder->getDateDelivery('n')]} {$oOrder->getDateDelivery('Y')} г."), 0, 'L');
            $oPdf->setY(260);
            $oPdf->SetFont('Times', '', 6);
            $oPdf->MultiCell(125, $iH * 2, ToRu("                                            (ПОДПИСЬ)                                       (РАСШИФРОВКА)       "), 0, 'L');
        }
        $oPdf->Output();
    }

    public function OrderProductDelete()
    {
        if (!LS::HasRight('40_order_product_delete')) return parent::EventForbiddenAccess();

        $orderProductId = $this->GetParamEventMatch(1, 0);
        $orderProduct = $this->Order_GetProductsById($orderProductId);

        if (!$orderProduct) return parent::EventNotFound();

        /* Удалим все комментарии */
        $this->Order_DeleteCommentsItemsByFilter([
            '#where' => [
                'order_product_id = ?d' => [$orderProductId]
            ]
        ]);

        $orderId = $orderProduct->getOrderId();
        $product = $orderProduct->getProduct();
        $orderProduct->Delete();

        $userCurrent = LS::CurUsr();
        $oOrderComment = Engine::GetEntity('Order_Comments', [
            'user_id' => $userCurrent->getId(),
            'order_id' => $orderId,
            'user_fio' => $userCurrent->getFio(),
            'date' => date('Y-m-d H:i:s'),
            'field' => 'option',
            'text' => 'Удален товар "'.$product->getTitleFull().'"',
            'system' => 1
        ]);
        $oOrderComment->Save();
        $this->Message_AddNoticeSingle('Товар успешно удален', false, true);

        return Router::Location(ADMIN_URL.'order/'.$orderId.'/');
    }

    /**
     * Зарплата
     */
    public function OrderSalary()
    {
        if (!LS::HasRight('3_order_salary')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Зарплата');
        $aOrderProducts = [];
        if ($sDateFrom = getRequestStr('date_from')) {
            $sDateTo = getRequestStr('date_to');
            $oDateFrom = new DateTime($sDateFrom);
            $oDateTo = new DateTime($sDateTo);
            if (($sWorkType = getRequestStr('work_type')) &&
                ($iMakeBlock = (int)getRequest('make_block'))) {
                $aOrderProducts = $this->Order_GetProductsItemsByFilter([
                    '#select' => ['o.date_manufactured, o.status order_status', 'p.title', 't.*'],
                    '#join' => [
                        'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                        'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id'
                    ],
                    '#where' => [
                        'o.date_manufactured >= ? AND o.date_manufactured <= ? AND p.' . $sWorkType . ' = ?d' => [
                            $oDateFrom->format('Y-m-d 00:00:00'),
                            $oDateTo->format('Y-m-d 23:59:59'),
                            $iMakeBlock
                        ]
                    ]
                ]);
            }
            $this->Viewer_Assign('sDateFrom', $sDateFrom);
            $this->Viewer_Assign('sDateTo', $sDateTo);
            $aSalary = [];
            foreach ($aOrderProducts as $oOrderProduct) {
                $aSalary[$oOrderProduct->getDateManufactured('d.m.Y')][$oOrderProduct->getId()] = $oOrderProduct;
            }
            $iMaxCount = 0;
            foreach ($aSalary as $aD) if (count($aD) > $iMaxCount) $iMaxCount = count($aD);
            $iD = 1;
            $aDay = ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"];
            $oDateNew = new DateTime($oDateFrom->format('Y-m-d') . " +{$iD}day");

            $aDate = [
                ['date' => $oDateFrom->format('d.m.Y'), 'name' => $aDay[$oDateFrom->format('w')]],
                ['date' => $oDateNew->format('d.m.Y'), 'name' => $aDay[$oDateNew->format('w')]],
            ];
            while ($oDateNew < $oDateTo) {
                $iD++;
                $oDateNew = new DateTime($oDateFrom->format('Y-m-d') . " +{$iD}day");
                $aDate[] = ['date' => $oDateNew->format('d.m.Y'), 'name' => $aDay[$oDateNew->format('w')]];
            }
            $this->Viewer_Assign('iMaxCount', $iMaxCount);
            $this->Viewer_Assign('aSalary', $aSalary);
            $this->Viewer_Assign('aDate', $aDate);
            $this->Viewer_Assign('sFunction', "get{$sWorkType}Price");
            $this->Viewer_Assign('sCurrentPath', $_SERVER['REQUEST_URI']);
        }
        $this->SetTemplateAction('order.salary');
    }

    /**
     * Доставка КАРТА
     */
    public function OrderDeliveryMap()
    {
        if (!LS::HasRight('4_order_delivery')) return parent::EventForbiddenAccess();
        $aOrder = [];
        if ($sDate = getRequestStr('date')) {
            $oDate = new DateTime($sDate);
            $aOrder = $this->Order_GetItemsByFilter([
                '#where' => [
                    't.date_delivery = ?' => [
                        $oDate->format('Y-m-d 00:00:00')
                    ]
                ]
            ]);
        }
        $this->Viewer_Assign('sDate', $sDate);
        $this->Viewer_Assign('aOrder', $aOrder);
        $aData = [
            "type" => "FeatureCollection",
            "features" => [],
        ];
        foreach($aOrder as $oOrder) {
            $this->Viewer_Assign('oOrder', $oOrder);
            $sFieldSelect = $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__).'order/delivery.field.select.tpl');
            $aData['features'][] = [
                "type" 	=> "Feature",
                "id" 	=> $oOrder->getId(),
                "geometry" => [
                    "type" => "Point",
                    "coordinates" => [$oOrder->getLongitude(), $oOrder->getLatitude()]
                ],
                "properties" => [
                    "balloonContentHeader"	=> 'Заказ №'.$oOrder->getAgentNumber(),
                    "balloonContentBody"	=> '<div class="address">'.$oOrder->getAddress().'</div>'.$sFieldSelect,
                    "balloonContentFooter"  => "",
                    "clusterCaption"		=> 'Заказ №'.$oOrder->getAgentNumberRtl(),
                    "hintContent"			=> "",

                ]
            ];
//			"properties" => [
//				"balloonContentHeader"	=> "<font size=3><b><a target='_blank' href='https://yandex.ru'>Здесь может быть ваша ссылка</a></b></font>",
//				"balloonContentBody"	=> "<p>Ваше имя: <input name='login'></p><p><em>Телефон в формате 2xxx-xxx:</em>  <input></p><p><input type='submit' value='Отправить'></p>",
//				"balloonContentFooter"	=> "<font size=1>Информация предоставлена: </font> <strong>этим балуном</strong>",
//				"clusterCaption"		=> "<strong><s>Еще</s> одна</strong> метка",
//				"hintContent"			=> "<strong>Текст  <s>подсказки</s></strong>"
//			]
        }
        $this->Viewer_Assign('aPoint', $aData);
        $this->Viewer_Assign('sCurrentPath', $_SERVER['REQUEST_URI']);
        $this->SetTemplateAction('order.delivery.map');
    }

    /**
     * Доставка
     */
    public function OrderDelivery()
    {
        if (!LS::HasRight('4_order_delivery')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Доставка');
        $aOrder = [];
        if ($sDate = getRequestStr('date')) {
            $oDate = new DateTime($sDate);
            $aOrder = $this->Order_GetItemsByFilter([
                '#where' => [
                    't.date_delivery = ?' => [
                        $oDate->format('Y-m-d 00:00:00')
                    ]
                ]
            ]);
        }
        $this->Viewer_Assign('sDate', $sDate);
        $this->Viewer_Assign('aOrder', $aOrder);
        $this->Viewer_Assign('sCurrentPath', $_SERVER['REQUEST_URI']);
        $this->SetTemplateAction('order.delivery');
    }

    // ==================================================================
    // ==================================================================
    // ==================================================================
    // ==================================================================


    public function EventOrderPdf()
    {
        $iOrderId = $this->GetParamEventMatch(0, 0);
        $oOrder = $this->Order_getById($iOrderId);

        $oPdf = new FPDF();
        $oPdf->AddFont('OpenSans', '', 'opensans.php');

        $aProduct = $oOrder->getProducts();
        foreach ($aProduct as $oProduct) {
            $this->PdfNewPage($oPdf, $oOrder);
            $oOrderProduct = $oProduct->_getManyToManyRelationEntity();
            if ($oOrderProduct->getProductDesign()) $oProduct->setDesign($oOrderProduct->getProductDesign());
            $oProduct->setPrice($oOrderProduct->getProductPrice());
            $this->PrintProduct($oPdf, $oOrder, $oProduct);
        }
        $sName = 'Заказ №' . $oOrder->getId() . ' - ' . $oProduct->getNameFull() . '.pdf';
//		$oPdf->Output();
        $oPdf->Output('', $sName, true);
    }

    public function OrderTasks()
    {
        $this->AppendBreadCrumb(30, 'Задачи', 'tasks');
        $this->AppendBreadCrumb(40, '');

        $dateFrom = new DateTime(getRequestStr('date_from','-4days'));
        $dateTo = new DateTime(getRequestStr('date_to', '+4days'));
        $managerIdSelected = getRequest('manager_id', 0);
        $tasks = $this->Task_GetItemsByFilter([
            '#where' => [
                '(
                    (? < t.date_time  AND t.date_time < ?)  OR done = ?d 
                ) { AND user_id = ?d }' => [
                    $dateFrom->format('Y-m-d 00:00:00'),
                    $dateTo->format('Y-m-d 00:00:00'),
                    0,
                    $managerIdSelected ? $managerIdSelected : DBSIMPLE_SKIP
                ]
            ],
            '#order' => ['date_time' => 'desc']
        ]);
        $this->Viewer_Assign('dateFrom', $dateFrom);
        $this->Viewer_Assign('dateTo', $dateTo);
        $this->Viewer_Assign('tasks', $tasks);
        $this->Viewer_Assign('managerSelect', $this->User_GetManagersForSelect());

        $this->SetTemplateAction('order.tasks');
    }

    public function PrintProduct($oPdf, $oOrder, $oProduct)
    {
//prex($oProduct);

        /**
         * Заголовок
         */
        $oPdf->Ln(15);
        $oPdf->SetFontSize(18);
        $oPdf->SetTextColor(114, 178, 159);
        $oPdf->Cell(0, 0, iconv('UTF-8', 'cp1251', $oProduct->getNameFull()), 0, 0, 'C');

        /**
         * Изображение
         */
        $oPdf->Ln(5);
        $oPdf->SetX(50);
        $oPdf->Image($this->Fs_GetPathServerFromWeb($oProduct->getMainPhotoPath('400x')));

        /**
         * Ткани
         */
        $oPdf->Ln(10);
        $oPdf->SetDrawColor(180, 180, 180);
        $oPdf->Rect(10, 115, 60, 57);
        $oPdf->Rect(70, 115, 60, 57);
        $oPdf->Rect(130, 115, 70, 57);
        $oPdf->SetX(10);
        $oPdf->SetY(115);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->SetFontSize(12);
        /**
         * Основная
         */
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', 'Основная ткань:'), 0, 0, 'C');
        $oPdf->SetX(70);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', 'Ткань-компаньон:'), 0, 0, 'C');
        $oPdf->SetX(132);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', 'Габариты:'), 0, 0, 'L');
        $oPdf->SetY(130);
        $oPdf->SetX(132);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', 'Спальное место:'), 0, 0, 'L');
        $oPdf->SetY(145);
        $oPdf->SetX(132);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', 'Механизм:'), 0, 0, 'L');

        /**
         * Картинка осн. ткани
         */
        $oPdf->Ln(5);
        $oPdf->SetY(122);
        $oPdf->SetX(10);
        $oF1 = $oProduct->getFabric(1);
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', $oF1->getTitle()), 0, 0, 'C');
        $oPdf->Ln(5);
        $oPdf->SetFontSize(10);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', '(' . $oF1->getTypeTitle() . ')'), 0, 0, 'C');
        $oPdf->Ln(5);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', '(' . $oF1->getGroupTitle() . ' кат.)'), 0, 0, 'C');
        $oPdf->SetFontSize(12);
        $oPdf->Ln(9);
        $oPdf->SetX(27);
        $aM = $oF1->getMedia();
        $oFM1 = $aM[0];
        $oPdf->Image($this->Fs_GetPathServerFromWeb($oFM1->getFileWebPath('100crop')));

        /**
         * Картинка комп. ткани
         */
        $oPdf->Ln(5);
        $oPdf->SetY(122);
        $oPdf->SetX(70);
        $oF2 = $oProduct->getFabric(2);
        if (!$oF2) $oF2 = $oF1;
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', $oF2->getTitle()), 0, 0, 'C');
        $oPdf->Ln(5);
        $oPdf->SetX(70);
        $oPdf->SetFontSize(10);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', '(' . $oF2->getTypeTitle() . ')'), 0, 0, 'C');
        $oPdf->Ln(5);
        $oPdf->SetY(132);
        $oPdf->SetX(70);
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', '(' . $oF2->getGroupTitle() . ' кат)'), 0, 0, 'C');
        $oPdf->SetFontSize(12);
        $oPdf->Ln(9);
        $oPdf->SetX(87);
        $aM = $oF2->getMedia();
        $oFM2 = $aM[0];
        $oPdf->Image($this->Fs_GetPathServerFromWeb($oFM2->getFileWebPath('100crop')));

        /**
         * Габариты
         */
        $oPdf->Ln(10);
        $oPdf->SetY(121);
        $oPdf->SetX(132);
        $oChar = $oProduct->getCharByTitle('Габариты (Ширина)');
        $oChar1 = $oProduct->getCharByTitle('Габариты (Глубина)');
        $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', $oChar->getValue() . ' ' . $oChar->getUnit() . ' x ' . $oChar1->getValue() . ' ' . $oChar1->getUnit()), 0, 0, 'L');

        /**
         * Спальное место
         */
        $oPdf->Ln(10);
        $oPdf->SetY(136);
        $oPdf->SetX(132);
        $oChar = $oProduct->getCharByTitle('Спальное место (Ширина)');
        $oChar1 = $oProduct->getCharByTitle('Спальное место (Глубина)');
        if ($oChar && $oChar1)
            $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', $oChar->getValue() . ' ' . $oChar->getUnit() . ' x ' . $oChar1->getValue() . ' ' . $oChar1->getUnit()), 0, 0, 'L');

        /**
         * Механизм
         */
        $oPdf->Ln(10);
        $oPdf->SetY(150);
        $oPdf->SetX(132);
        $oChar = $oProduct->getCharByTitle('Механизм трансформации');
        if ($oChar) $oPdf->Cell(60, 10, iconv('UTF-8', 'cp1251', $oChar->getValueRus()), 0, 0, 'L');

        /**
         * Прочее
         */
        $oPdf->Ln(10);
        $oPdf->SetY(180);
        $oPdf->SetX(10);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Стоимость дивана:'), 0, 0, 'L');
        $oPdf->SetTextColor(217, 83, 79);
        $oPdf->SetFontSize(18);
        $oPdf->SetY(179);
        $oPdf->SetX(51);
        $oPdf->Cell(80, 10, iconv('UTF-8', 'cp1251', str_replace('₽', 'руб.', $oProduct->getPrice(true, true))), 0, 0, 'L');

        $oPdf->Ln(11);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->SetFontSize(12);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Дата доставки:'), 0, 0, 'L');
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', date('d.m.Y', strtotime($oOrder->getDateDelivery()))), 0, 0, 'L');

        $oPdf->Ln(11);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Заказчик:'), 0, 0, 'L');
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->SetY(206);
        $oPdf->SetX(51);
        $oU = $oOrder->getUser();
        $oPdf->Cell(0, 0, iconv('UTF-8', 'cp1251', $oU->getProfileName() . ' ' . $oU->getPhone() . ($oU->getComment() ? ', ' : '') . $oU->getComment()), 0, 0, 'L');

        $oPdf->Ln(7);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Адрес доставки:'), 0, 0, 'L');
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->Cell(0, 10, iconv('UTF-8', 'cp1251', $oOrder->getAddress()), 0, 0, 'L');

        $oPdf->Ln(11);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Лифт:'), 0, 0, 'L');
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->Cell(0, 10, iconv('UTF-8', 'cp1251', $oOrder->getLift()), 0, 0, 'L');

        $oPdf->Ln(11);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Примечание:'), 0, 0, 'L');
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->Ln(10);
        $oPdf->Cell(0, 0, iconv('UTF-8', 'cp1251', $oOrder->getComment()), 0, 0, 'L');

        $oPdf->Ln(7);
        $oPdf->SetTextColor(60, 60, 60);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', 'Ссылка на страницу модели:'), 0, 0, 'L');
        $oPdf->SetTextColor(66, 139, 202);
        $oPdf->Ln(7);
        $oPdf->Cell(41, 10, iconv('UTF-8', 'cp1251', Config::Get('path.root.web') . $oProduct->getUrlFull()), 0, 0, 'L', 0, $oProduct->getUrlFull());
    }

    private function PdfNewPage($oPdf, $oOrder)
    {

        $sFilePath = Config::Get('path.root.server') . '/application/frontend/skin/kypitdivan/assets/images/';
        $oPdf->AddPage();
        $oPdf->setY(4);
        $oPdf->Image($sFilePath . 'logo-main.jpg');
        $oPdf->setY(10);
        $oPdf->SetFont('OpenSans', '', 14);
        $oPdf->SetTextColor(217, 83, 79);
        $oPdf->Cell(0, 0, iconv('UTF-8', 'cp1251', 'Заказ №') . $oOrder->getId(), 0, 0, 'R');
        $oPdf->Ln(8);
        $oPdf->SetTextColor(0, 0, 0);
        $oPdf->Cell(0, 0, iconv('UTF-8', 'cp1251', 'от ') . date('d.m.Y', strtotime($oOrder->getDateAdd())), 0, 0, 'R');
        $oPdf->Ln(8);
        $oPdf->Line(10, 25, 200, 25);
    }

}

function ToRu($sText)
{
    return iconv('utf-8', 'windows-1251', $sText);
}

function PriceString($value)
{
    $value = explode('.', number_format($value, 2, '.', ''));

    $f = new NumberFormatter('ru', NumberFormatter::SPELLOUT);
    $str = $f->format($value[0]);

    // Первую букву в верхний регистр.
    $str = mb_strtoupper(mb_substr($str, 0, 1)) . mb_substr($str, 1, mb_strlen($str));

    // Склонение слова "рубль".
    $num = $value[0] % 100;
    if ($num > 19) {
        $num = $num % 10;
    }
    switch ($num) {
        case 1:
            $rub = 'рубль';
            break;
        case 2:
        case 3:
        case 4:
            $rub = 'рубля';
            break;
        default:
            $rub = 'рублей';
    }

    return $str . ' ' . $rub . ' ' . $value[1] . ' копеек.';
}
