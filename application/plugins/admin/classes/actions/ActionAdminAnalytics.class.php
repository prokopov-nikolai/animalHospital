<?php

class PluginAdmin_ActionAdminAnalytics extends PluginAdmin_ActionPlugin {

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.analytics'), 'analytics');
        $this->SetDefaultEvent('proceeds');
        if (!LS::HasRight('42_analytics')) return parent::EventForbiddenAccess();
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^proceeds$/i', 'AnalyticProceeds');
        $this->AddEventPreg('/^colors$/i', 'AnalyticColors');
        $this->AddEventPreg('/^top30$/i', 'AnalyticTop30');
        $this->AddEventPreg('/^manufactures$/i', 'AnalyticManufactures');
        $this->AddEventPreg('/^managers$/i', 'AnalyticManagers');
        $this->AddEventPreg('/^reclamations$/i', 'AnalyticReclamations');

    }

    /**
     * Аналитика выручки
     */
    public function AnalyticProceeds()
    {
        $this->AppendBreadCrumb(30, 'Продажи', 'proceeds');
        $this->AppendBreadCrumb(40, 'Заказы');
        $this->Viewer_SetHtmlTitle('Анатилика // Продажи');
        $oDateFrom = null;
        $oDateTo = null;
        $this->AppendDates($oDateFrom, $oDateTo);
        $daysDiff = $oDateFrom->diff($oDateTo);

        /**
         * Статус заказа
         */
        $aStatus = getRequest('status', ['make', 'feedback', 'delivered', 'reclamation']);
        $_GET['status'] = $aStatus;

        /**
         * Источник
         */
        $agentIdSelected = getRequest('agent_id', []);
        if (!$agentIdSelected) $agentIdSelected = [];
        foreach ($agentIdSelected as $i => $id) {
            if ($id == 0) {
                unset($agentIdSelected[$i]);
            }
        }

        /**
         * Товар
         */
        $productId = (int)getRequest('product_id', 0);
        if ($productId) {
            $product = $this->Product_GetById($productId);
        } else {
            $product = Engine::GetEntity('Product');
        }

        $filter = [
            '#select' => [
                't.id, DATE_FORMAT(t.date_add, "%Y-%m-%d") date,
                SUM(t.agent_commission) - SUM(t.discount) sum,
                SUM(t.product_count) products_count,
                COUNT(t.id) orders_count
       '
            ],
            '#where' => [
                '? <= t.date_add AND t.date_add <= ?
                 AND t.status IN (?a)
                 {AND t.agent_id IN (?a)} 
                 {AND op.product_id = ?d} 
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    $agentIdSelected ? $agentIdSelected : DBSIMPLE_SKIP,
                    $productId ? $productId : DBSIMPLE_SKIP
                ]
            ],
            '#group' => ['#date'],
            '#order' => ['#date' => 'desc']
        ];

        if($productId) {
            $filter['#join'][] = 'INNER JOIN '.Config::Get('db.table.order_products').' op ON t.id = op.order_id';
        }

        $data = $this->Order_GetItemsByFilter($filter);

        $dataRejected = ['reclamation' => [], 'return' => []];
        $dataR = $this->Order_GetRejectedItemsByFilter([
            '#select' => [
                'DATE_FORMAT(t.date_add, "%Y-%m-%d") date, t.order_status, COUNT(t.order_id) count'
            ],
            '#join' => [
                'INNER JOIN '.Config::Get('db.table.order_products').' op ON op.id = t.order_product_id'
            ],
            '#where' => [
                '? <= t.date_add AND t.date_add <= ?
                AND t.order_status IN (?a)
                {AND op.product_id = ?d}' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    ['reclamation', 'return'],
                    $productId ? $productId : DBSIMPLE_SKIP
                ]
            ],
            '#group' => ['#date, order_status'],
            '#order' => ['#date' => 'desc']
        ]);

        foreach ($dataR as $r) {
            $dataRejected[$r->getOrderStatus()][$r->getDate()] = $r->getCount();
        }

        /* Заполним пустыми данными */
        $orders = [];
        for ($i = 0; $i < $daysDiff->days; $i++) {
            $day = new DateTime($oDateTo->format('d.m.Y') . '-' . $i . 'days');
            $orders[$day->format('d.m.Y')] = Engine::GetEntity('Order', [
                'date' => $day->format('Y-m-d'),
                'products_count' => 0,
                'orders_count' => 0,
                'reclamations_count' => 0,
                'returns_count' => 0,
                'sum' => 0
            ]);
        }

        foreach ($data as $order) {
            $orders[$order->getDateFormat('d.m.Y')] = $order;
        }

        $this->Viewer_Assign('dataRejected', $dataRejected);
        $this->Viewer_Assign('product', $product);
        $this->Viewer_Assign('currentWeekday', $oDateFrom->format('N')+1 % 7);
        $this->Viewer_Assign('weekdays', ['вс','пн','вт','ср','чт','пт','сб']);
        $this->Viewer_Assign('agentIdSelected', $agentIdSelected);
        $this->Viewer_Assign('orders', $orders);
        $this->Viewer_Assign('aStatus', $aStatus);
        $this->Viewer_Assign('aAgentsSelect', $this->User_GetAgentsForSelect());
        $this->SetTemplateAction('analytics.proceeds');
    }

    /**
     * Аналитика лидеров продаж
     */
    public function AnalyticTop30()
    {
        $this->AppendBreadCrumb(30, 'ТОП-30', 'top30');
        $this->AppendBreadCrumb(40, '');
        $oDateFrom = null;
        $oDateTo = null;
        $this->AppendDates($oDateFrom, $oDateTo);

        $this->Viewer_Assign('oDateFrom', $oDateFrom);
        $this->Viewer_Assign('oDateTo', $oDateTo);

        /**
         * Статус заказа
         */
        $aStatus = getRequest('status', ['make', 'feedback', 'delivered', 'reclamation']);
        $_GET['status'] = $aStatus;

        /**
         * Источник
         */
        $agentIdSelected = getRequest('agent_id', []);
        if (!$agentIdSelected) $agentIdSelected = [];
        foreach ($agentIdSelected as $i => $id) {
            if ($id == 0) {
                unset($agentIdSelected[$i]);
            }
        }

        $orderProducts = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                't.product_id, o.id',
                'SUM(t.agent_commission) sum',
                'SUM(t.count) products_count',
                'p.title, p.title_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id'
            ],
            '#where' => [
                '? <= o.date_add AND o.date_add <= ?
                 AND o.status IN (?a)
                 {AND o.agent_id IN (?a)} 
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    $agentIdSelected ? $agentIdSelected : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#p.id'],
            '#order' => ['#products_count' => 'desc'],
            '#limit' => 30
        ]);
        $this->Viewer_Assign('orderProducts', $orderProducts);
        $this->Viewer_Assign('aStatus', $aStatus);
        $this->Viewer_Assign('aAgentsSelect', $this->User_GetAgentsForSelect());
        $this->SetTemplateAction('analytics.top30');
    }

    /**
     * Аналитика продаж по фабрикам
     */
    public function AnalyticManufactures()
    {
        $this->AppendBreadCrumb(30, 'Фабриками', 'manufactures');
        $this->AppendBreadCrumb(40, '');
        $oDateFrom = null;
        $oDateTo = null;
        $this->AppendDates($oDateFrom, $oDateTo);
        $daysDiff = $oDateFrom->diff($oDateTo);

        /**
         * Статус заказа
         */
        $aStatus = getRequest('status', ['make', 'feedback', 'delivered', 'reclamation']);
        $_GET['status'] = $aStatus;

        /**
         * Источник
         */
        $agentIdSelected = getRequest('agent_id', []);
        if (!$agentIdSelected) $agentIdSelected = [];
        foreach ($agentIdSelected as $i => $id) {
            if ($id == 0) {
                unset($agentIdSelected[$i]);
            }
        }

        /**
         * Фабрика
         */
        $makeForSelect = $this->Make_GetListForSelect();
        $makeForSelect[-2] = [
            'text' => 'Выделить все',
            'value' => 'all'
        ];
        $makeForSelect[-1] = [
            'text' => 'Снять все',
            'value' => 'dall'
        ];
        ksort($makeForSelect);
        $makesId = getRequest('make_id', [1, 3, 4, 6, 9, 10]);
        $makesId = array_diff($makesId, ['all', 'dall']);

        $data = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                't.product_id, t.make_id,
                o.id, DATE_FORMAT(o.date_add, "%d.%m") date',
                'SUM(t.agent_commission) sum',
                'SUM(t.count) products_count',
                'p.title, p.title_full,
                m.title make_title'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.make') . ' m ON t.make_id = m.id'
            ],
            '#where' => [
                '? <= o.date_add AND o.date_add <= ?
                 AND o.status IN (?a)
                 AND t.make_id IS NOT NULL
                 {AND o.agent_id IN (?a)} 
                 {AND t.make_id IN (?a)} 
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    $agentIdSelected ? $agentIdSelected : DBSIMPLE_SKIP,
                    count($makesId) ? $makesId : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#date, t.make_id'],
            '#order' => ['#date' => 'desc']
        ]);

        $makes = $this->Make_GetItemsByFilter([
            '#order' => ['sort' => 'asc'],
            '#index-from' => 'id'
        ]);

        /* Заполним пустыми данными */
        $orders = [];
        $ordersCumulative = [];
        $labels = [];
        $colors = [
            10 => 'red', // КиС
            6 => 'blue', // So-Co
            1 => 'green', // Leticiya
            3 => 'yellow', // +Leticiya
            9 => 'brown', // Франк
            4 => 'orange', // Акула
            7 => 'purple', // Fiesta
            8 => 'darkGreen', // DiHall
            11 => 'black', // МДВ
            5 => 'darkBlue' // Furny
        ];

        for ($i = 0; $i <= $daysDiff->days; $i++) {
            $day = new DateTime($oDateTo->format('d.m.Y') . '-' . $i . 'days');
            $date = $day->format('d.m');
            $labels[] = $date;
            foreach($makes as $makeId => $make) {
                $orders[$makeId][$date] = 0;
            }
        }

        foreach ($data as $orderProduct) {
            $makeId = $orderProduct->getMakeId();
            $date = $orderProduct->getDate();
            $orders[$makeId][$date] = $orderProduct->getProductsCount();
        }

        /* Подсчитаем нарастающим итогом */
        foreach($makes as $makeId => $make) {
            $cumulative = 0;
            foreach (array_reverse($orders[$makeId]) as $date => $productsCount) {
                $cumulative += $productsCount;
                $ordersCumulative[$makeId][] = $cumulative;
            }
        }

        $this->Viewer_Assign('makeForSelect', $makeForSelect);
        $this->Viewer_Assign('makeSelected', $makesId);
        $this->Viewer_Assign('agentIdSelected', $agentIdSelected);
        $this->Viewer_Assign('aStatus', $aStatus);
        $this->Viewer_Assign('orders', $orders);
        $this->Viewer_Assign('ordersCumulative', $ordersCumulative);
        $this->Viewer_Assign('labels', $labels);
        $this->Viewer_Assign('makes', $makes);
        $this->Viewer_Assign('colors', $colors);
        $this->SetTemplateAction('analytics.manufactures');
    }

    /**
     * Аналитика рекламаций по фабрикам
     */
    public function AnalyticReclamations()
    {
        $this->AppendBreadCrumb(30, 'Рекламации', 'reclamations');
        $this->AppendBreadCrumb(40, '');
        $oDateFrom = null;
        $oDateTo = null;
        $this->AppendDates($oDateFrom, $oDateTo);
        $daysDiff = $oDateFrom->diff($oDateTo);

        /**
         * Статус заказа
         */
        $aStatus = getRequest('status', ['make', 'feedback', 'delivered', 'reclamation', 'return', 'failure-ready']);
        $_GET['status'] = $aStatus;

        /**
         * Фабрика
         */
        $makeForSelect = $this->Make_GetListForSelect();
        $makeForSelect[-2] = [
            'text' => 'Выделить все',
            'value' => 'all'
        ];
        $makeForSelect[-1] = [
            'text' => 'Снять все',
            'value' => 'dall'
        ];
        ksort($makeForSelect);
        $makesId = getRequest('make_id', [1, 3, 4, 6, 9, 10]);
        $makesId = array_diff($makesId, ['all', 'dall']);

        $ordersCount = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                't.product_id, t.make_id,
                o.id, DATE_FORMAT(o.date_add, "%d.%m") date',
                'SUM(t.agent_commission) sum',
                'SUM(t.count) products_count',
                'p.title, p.title_full,
                m.title make_title'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.make') . ' m ON t.make_id = m.id'
            ],
            '#where' => [
                '? <= o.date_add AND o.date_add <= ?
                 AND o.status IN (?a)
                 AND t.make_id IS NOT NULL
                 {AND t.make_id IN (?a)} 
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    count($makesId) ? $makesId : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#t.make_id'],
            '#order' => ['#m.sort' => 'asc'],
            '#index-from' => 'make_id'
        ]);

        /* Рекламации */
        $ordersReclamation = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                't.product_id, t.make_id, or1.rejected_type,
                o.id, DATE_FORMAT(o.date_add, "%d.%m") date',
                'COUNT(t.id) reclamations_count, m.title make_title',
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.order_rejected') . ' or1 
                    ON or1.order_product_id = t.id AND or1.order_status IN ("reclamation", "return")',
                'LEFT JOIN ' . Config::Get('db.table.make') . ' m ON t.make_id = m.id'
            ],
            '#where' => [
                '? <= or1.date_add AND or1.date_add <= ?
                 AND or1.order_status IN (?a)
                 AND t.make_id IS NOT NULL
                 {AND t.make_id IN (?a)} 
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    count($makesId) ? $makesId : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#t.make_id, rejected_type'],
            '#order' => ['#m.sort' => 'asc']
        ]);

        $makes = $this->Make_GetItemsByFilter([
            '#order' => ['sort' => 'asc'],
            '#index-from' => 'id'
        ]);

        $reclamations = [];
        foreach ($makes as $makeId => $make) {
            $reclamations[$makeId] = [
                'client' => 0,
                'delivery' => 0,
                'shop-manager' => 0,
                'manufacture' => 0,
                'sum' => 0,
                '' => 0,
            ];
        }

        foreach ($ordersReclamation as $orderProduct) {
            $makeId = $orderProduct->getMakeId();
            $rejectedType = $orderProduct->getRejectedType();
            $reclamations[$makeId][$rejectedType] = $orderProduct->getReclamationsCount();
            $reclamations[$makeId]['sum'] += $orderProduct->getReclamationsCount();
        }
        $this->Viewer_Assign('rejectedTypes', Config::Get('rejected_types'));
        $this->Viewer_Assign('reclamations', $reclamations);
        $this->Viewer_Assign('makeForSelect', $makeForSelect);
        $this->Viewer_Assign('makeSelected', $makesId);
        $this->Viewer_Assign('makes', $makes);
        $this->Viewer_Assign('aStatus', $aStatus);
        $this->Viewer_Assign('ordersCount', $ordersCount);
        $this->Viewer_Assign('ordersReclamation', $ordersReclamation);
        $this->SetTemplateAction('analytics.reclamations');
    }

    /**
     * Аналитика продаж по фабрикам
     */
    public function AnalyticManagers()
    {
        $this->AppendBreadCrumb(30, 'Менеджеры', 'managers');
        $this->AppendBreadCrumb(40, '');
        $oDateFrom = null;
        $oDateTo = null;
        $this->AppendDates($oDateFrom, $oDateTo);
        $daysDiff = $oDateFrom->diff($oDateTo);

        /**
         * Статус заказа
         */
        $aStatus = getRequest('status', ['make', 'feedback', 'delivered', 'reclamation']);
        $_GET['status'] = $aStatus;

        /**
         * Источник
         */
        $agentIdSelected = getRequest('agent_id', []);
        if (!$agentIdSelected) $agentIdSelected = [];
        foreach ($agentIdSelected as $i => $id) {
            if ($id == 0) {
                unset($agentIdSelected[$i]);
            }
        }

        /**
         * Тип фильтра
         */
        $sFilterType = getRequestStr('filter_type', 'products_count');

        $data = $this->Order_GetItemsByFilter([
            '#select' => [
                't.id, t.manager_id, DATE_FORMAT(t.date_add, "%Y-%m-%d") date,
                SUM(t.agent_commission) - SUM(t.discount) sum,
                SUM(t.product_count) products_count,
                COUNT(t.id) orders_count',
            ],
            '#join' => [

            ],
            '#where' => [
                '? <= t.date_add AND t.date_add <= ?
                 AND t.status IN (?a)
                 {AND t.agent_id IN (?a)} 
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    $agentIdSelected ? $agentIdSelected : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#date, t.manager_id'],
            '#order' => ['date_add' => 'asc']
        ]);

        /* Заполним пустыми данными */
        $orders = [];
        $reclamations = [];
        $managersId = [19, 20, 1301];
        for ($i = 0; $i < $daysDiff->days; $i++) {
            $day = new DateTime($oDateTo->format('d.m.Y') . '-' . $i . 'days');
            foreach ($managersId as $managerId) {
                $orders[$day->format('d.m.Y')][$managerId] = Engine::GetEntity('Order', [
                    'date' => $day->format('Y-m-d'),
                    'products_count' => 0,
                    'orders_count' => 0,
                    'sum' => 0
                ]);
            }
        }

        foreach ($data as $order) {
            $orders[$order->getDateFormat('d.m.Y')][$order->getManagerId()] = $order;
        }

        $managers = $this->User_GetItemsByArrayId($managersId);

        $this->Viewer_Assign('orders', $orders);
        $this->Viewer_Assign('managers', $managers);
        $this->Viewer_Assign('aStatus', $aStatus);
        $this->Viewer_Assign('sFilterType', $sFilterType);
        $this->SetTemplateAction('analytics.managers');
    }

    /**
     * Аналитика продаж по тканям цветам
     */
    public function AnalyticColors()
    {
        $this->AppendBreadCrumb(30, 'Цвета/Ткани', 'colors');
        $this->AppendBreadCrumb(40, '');
        $oDateFrom = null;
        $oDateTo = null;
        $this->AppendDates($oDateFrom, $oDateTo);

        $this->Viewer_Assign('oDateFrom', $oDateFrom);
        $this->Viewer_Assign('oDateTo', $oDateTo);

        /**
         * Статус заказа
         */
        $aStatus = getRequest('status', ['make', 'feedback', 'delivered', 'reclamation']);
        $_GET['status'] = $aStatus;

        /**
         * Источник
         */
        $agentIdSelected = getRequest('agent_id', []);
        if (!$agentIdSelected) $agentIdSelected = [];
        foreach ($agentIdSelected as $i => $id) {
            if ($id == 0) {
                unset($agentIdSelected[$i]);
            }
        }

        $orderProducts = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                'o.id, DATE_FORMAT(o.date_add, "%Y-%m-%d") date,
                SUM(t.count) products_count',
                'm.alt, m.color, m.id fabric_id'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'LEFT JOIN ' . Config::Get('db.table.media') . ' m ON m.id = t.fabric1_id AND m.target_type = "collection"'
            ],
            '#where' => [
                '? <= o.date_add AND o.date_add <= ?
                 AND o.status IN (?a)
                 {AND o.agent_id IN (?a)}
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    $agentIdSelected ? $agentIdSelected : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#color'],
            '#order' => ['#products_count' => 'desc']
        ]);
        $this->Viewer_Assign('orderProducts', $orderProducts);

        $orderProducts1 = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                'o.id, DATE_FORMAT(o.date_add, "%Y-%m-%d") date,
                SUM(t.count) products_count',
                'm.alt fabric_name, m.color, m.id fabric_id'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'LEFT JOIN ' . Config::Get('db.table.media') . ' m ON m.id = t.fabric1_id AND m.target_type = "collection"'
            ],
            '#where' => [
                '? <= o.date_add AND o.date_add <= ?
                 AND o.status IN (?a)
                 {AND o.agent_id IN (?a)}
                 ' => [
                    $oDateFrom->format('Y-m-d 00:00:00'),
                    $oDateTo->format('Y-m-d 23:59:59'),
                    $aStatus,
                    $agentIdSelected ? $agentIdSelected : DBSIMPLE_SKIP,
                ]
            ],
            '#group' => ['#fabric_id'],
            '#order' => ['#products_count' => 'desc']
        ]);
        $this->Viewer_Assign('orderProducts1', $orderProducts1);

        $this->Viewer_Assign('aStatus', $aStatus);
        $this->Viewer_Assign('aAgentsSelect', $this->User_GetAgentsForSelect());

        $this->SetTemplateAction('analytics.colors');
    }

    private function AppendDates(&$oDateFrom, &$oDateTo)
    {
        /**
         * Даты
         */
        $oDateWeek = new DateTime('');
        if (getRequestStr('date_from')) {
            $oDateFrom = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_from'))));
        } else {
            $oDateFrom = new DateTime('-8week -' . ($oDateWeek->format('N') - 1) . 'days');
            $oDateFrom = new DateTime('01.' . $oDateWeek->format('m.Y'));
        }
        if (getRequestStr('date_to')) {
            $oDateTo = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_to'))));
        } else {
            $oDateTo = new DateTime();
        }

        $this->Viewer_Assign('oDateFrom', $oDateFrom);
        $this->Viewer_Assign('oDateTo', $oDateTo);
    }
}