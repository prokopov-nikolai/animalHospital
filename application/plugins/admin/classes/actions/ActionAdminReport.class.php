<?php

class PluginAdmin_ActionAdminReport extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.report'), 'report');
        $this->SetDefaultEvent('list');
        if (!LS::HasRight('23_report')) return parent::EventForbiddenAccess();
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^list$/', 'ReportList');
        $this->AddEventPreg('/^agent$/', 'ReportAgent');
        $this->AddEventPreg('/^costs$/', 'ReportCosts');
        $this->AddEventPreg('/^salary$/', 'ReportSalary');
        $this->AddEventPreg('/^failure$/', 'ReportFailure');
        $this->AddEventPreg('/^summary$/', 'ReportSummary');

        $this->AddEventPreg('/^delivery$/i', '/^download$/i', 'ReportDeliveryDownload');
        $this->AddEventPreg('/^delivery$/i', '/^map$/i', 'ReportDeliveryMap');
        $this->AddEventPreg('/^delivery$/i', 'ReportDelivery');
    }

    /**
     * Отчет агента
     */
    public function ReportList()
    {

        $this->Viewer_SetHtmlTitle('Отчеты');
        $this->SetTemplateAction('report.list');
    }

    /**
     * Отчет агента
     */
    public function ReportAgent()
    {
        if (!LS::HasRight('25_report_agent')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Агентские');
        $oDateWeek = new DateTime('');
        if (getRequestStr('date_from')) {
            $oDateFrom = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_from')))) ;
        } else {
            $oDateFrom = new DateTime('-1week -'.($oDateWeek->format('N')-1).'days');
        }
        if (getRequestStr('date_to')) {
            $oDateTo = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_to')))) ;
        } else {
            $oDateTo = new DateTime('-'.($oDateWeek->format('N')).'days');
        }
        /**
         * Агент
         */
        $makes = [];
        $aOrderProduct = [];
        if ($makeIds = (array)getRequest('make_id')) {
            $makes = $this->Make_GetItemsByArrayId($makeIds);
            if ($makes) {
                $aOrderProduct = $this->Order_GetProductsItemsByFilter([
                    '#select' => [
                        't.*',
                        'o.agent_number, o.status order_status, t.make_paid',
                        'd.title_full design_title_full',
                        'p.title_full product_title_full'
                    ],
                    '#join' => [
                        'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                        'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                        'LEFT JOIN ' . Config::Get('db.table.design') . ' d ON d.id = t.design_id',
                    ],
                    '#where' => [
                        '(
                            (o.date_delivery >= ? AND o.date_delivery <= ?) OR
                            (o.date_shipment >= ? AND o.date_shipment <= ?)
                         ) AND o.status IN (?a) AND t.make_id IN (?a)' => [
                            $oDateFrom->format('Y-m-d'), $oDateTo->format('Y-m-d'),
                            $oDateFrom->format('Y-m-d'), $oDateTo->format('Y-m-d'),
                            ['make', 'feedback', 'delivered', 'reclamation'],
                            $makeIds
                        ]
                    ],
                    '#cache' => false
                ]);
            }
        }
        $this->Viewer_Assign('makes', $makes);
        $this->Viewer_Assign('aOrderProduct', $aOrderProduct);
        $this->Viewer_Assign('oDateFrom', $oDateFrom);
        $this->Viewer_Assign('oDateTo', $oDateTo);
        $this->Viewer_Assign('aMakeForSelect', $this->Make_GetListForSelect());
        $this->Viewer_Assign('sCurrentPath', $_SERVER['REQUEST_URI']);
        $title =   "Агентские c {$oDateFrom->format('d.m.Y')} по {$oDateTo->format('d.m.Y')}";
        if (count($makes) > 0) {
            foreach($makes as $make) {
                $title .= "// {$make->getTitle()}";
            }
        }
        $this->Viewer_SetHtmlTitle($title);
        $this->SetTemplateAction('report.agent');
    }

    /**
     * Отчет по зарплате
     */
    public function ReportSalary()
    {
        if (!LS::HasRight('3_report_salary')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Зарплата');

        $managerId = (int)getRequest('manager_id');

        if (!LS::ADM()) {
            $managerId = LS::CurUsr()->getId();
        }

        if ($date = getRequestStr('date')) {
            $dateStart = new DateTime($date);
            $dateEnd = new DateTime($date.'+1month');
        } else {
            $dateStart = new DateTime(date('Y-m-01'));
            $dateEnd = new DateTime(date('Y-m-01').'+1month');
        }

        $dateNow = new DateTime();

        $months = Config::Get('months');
        $monthItems = [];
        for($i = 0; $i < 12; $i++)
        {
            $date1 = new DateTime(getRequestStr('date').'-'.$i.'months');
            $monthItems[] = [
                'text' => $months[$date1->format('n')].' '.$date1->format('y'),
                'value' => $date1->format('Y-m-01')
            ];
        }

        $title =  $this->Lang_Get('plugin.admin.menu.report_salary'). " " . $months[$dateStart->format('n')] ;
        $this->Viewer_SetHtmlTitle($title);
        $this->SetTemplateAction('report.salary');

        /* Общие продажи */
        $orderProducts = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                't.*',
                'o.agent_number, o.status order_status',
                'd.title_full design_title_full',
                'p.title_full product_title_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.design') . ' d ON d.id = t.design_id',
            ],
            '#where' => [
                '(
                            (o.date_add >= ? AND o.date_add < ?) 
                         ) AND o.status IN (?a)' => [
                    $dateStart->format('Y-m-d'), $dateEnd->format('Y-m-d'),
                    ['make', 'feedback', 'delivered'],
                ]
            ],
            '#cache' => false
        ]);

        $marginCommon = 0;
        foreach ($orderProducts as $orderProduct) {
            $marginCommon += $orderProduct->getAgentCommission();
        }

        /* Продажи конкретного менеджера */
        $orderProducts = $this->Order_GetProductsItemsByFilter([
            '#select' => [
                't.*',
                'o.agent_number, o.status order_status',
                'd.title_full design_title_full',
                'p.title_full product_title_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.design') . ' d ON d.id = t.design_id',
            ],
            '#where' => [
                '(
                            (o.date_add >= ? AND o.date_add < ?) 
                         ) AND o.status IN (?a) AND o.manager_id = ?d' => [
                    $dateStart->format('Y-m-d'), $dateEnd->format('Y-m-d'),
                    ['make', 'feedback', 'delivered'],
                    $managerId
                ]
            ],
            '#cache' => false
        ]);

        $marginManager = 0;
        foreach ($orderProducts as $orderProduct) {
            $marginManager += $orderProduct->getAgentCommission();
        }

        $marginPlan = (int)Config::Get('margin_plan.'.$dateStart->format('Y-m'));
        $marginPlanManager = $marginPlan / 3;

        $userWorkdays = [];
        $userWorkdaysCount = [
            19 => ['morning' => 0, 'evening' => 0, 'day-off' => 0],
            20 => ['morning' => 0, 'evening' => 0, 'day-off' => 0],
            1301 => ['morning' => 0, 'evening' => 0, 'day-off' => 0]
        ];
        foreach($this->User_GetWorkdaysItemsByFilter([
            '#where' => [
                'date >= ? AND date < ?' => [
                    $dateStart->format('Y-m-d'),
                    $dateEnd->format('Y-m-d'),
                ]
            ]
        ]) as $workDay){
            $userWorkdays[$workDay->getUserId()][(int)substr($workDay->getDate(), 8)] = $workDay->getType();
            $userWorkdaysCount[$workDay->getUserId()][$workDay->getType()]++;
        }

        $premiumMonth = Config::Get('manager.salary.premium.'.$dateStart->format('Y-m'));
        $managerPremium = $managerId ? $premiumMonth[$managerId] : [];

        $this->Viewer_Assign('currentWeekday', $dateStart->format('N') % 7);
        $this->Viewer_Assign('weekdays', ['вс','пн','вт','ср','чт','пт','сб']);
        $this->Viewer_Assign('managerId', $managerId);
        $this->Viewer_Assign('marginCommon', $marginCommon);
        $this->Viewer_Assign('marginManager', $marginManager);
        $this->Viewer_Assign('marginPlanManager', $marginPlanManager);
        $this->Viewer_Assign('marginPlan', $marginPlan);
        $this->Viewer_Assign('months', $months);
        $this->Viewer_Assign('monthItems', $monthItems);
        $this->Viewer_Assign('dateStart', $dateStart);
        $this->Viewer_Assign('dateEnd', $dateEnd);
        $this->Viewer_Assign('daysMonth', $dateStart->format('t'));
        $this->Viewer_Assign('dayCurrent', (int)$dateNow->format('d'));
        $this->Viewer_Assign('viewCurrentMonth', $dateNow->format('m') == $dateStart->format('m'));
        $this->Viewer_Assign('managerItems', $this->User_GetManagersForSelect());
        $this->Viewer_Assign('orderProducts', $orderProducts);
        $this->Viewer_Assign('userWorkdays', $userWorkdays);
        $this->Viewer_Assign('userWorkdaysCount', $userWorkdaysCount);
        $this->Viewer_Assign('managerPremium', $managerPremium);
    }

    /**
     * Расходы
     */
    public function ReportCosts()
    {
        if (!LS::HasRight('24_report_costs')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, $this->Lang_Get('plugin.admin.menu.report_costs'));

        if ($date = getRequestStr('date')) {
            $dateStart = new DateTime($date);
            $dateEnd = new DateTime($date.'+1month');
        } else {
            $dateStart = new DateTime(date('Y-m-01'));
            $dateEnd = new DateTime(date('Y-m-01').'+1month');
        }

        $type = getRequestStr('type');
        $costs = $this->Cost_GetItemsByFilter([
            '#where' => [
                '? <= t.date AND t.date < ?{ AND t.type = ?}' => [
                    $dateStart->format('Y-m-d'), $dateEnd->format('Y-m-d'),
                    $type ? $type : DBSIMPLE_SKIP
                ]
            ]
        ]);

        $pivotCosts = $this->Cost_GetItemsByFilter([
            '#select' => ['SUM(t.sum) sum, t.type'],
            '#where' => [
                '? <= t.date AND t.date < ?' => [
                    $dateStart->format('Y-m-d'), $dateEnd->format('Y-m-d')
                ]
            ],
            '#group' => ['type']
        ]);

        $months = Config::Get('months');
        $monthsItems = [];

        /* доступные месяца для фильтрации */
        $costMonths = $this->Cost_GetItemsByFilter([
            '#select' => ["DISTINCT DATE_FORMAT(date, '%Y-%m-01') date"],
            '#order' => ['date' => 'desc']
        ]);

        if (count($costMonths) > 0) {
            foreach ($costMonths as $costMonth) {

                $date = new DateTime($costMonth->getDate());
                $monthsItems[] = [
                    'text' => $months[$date->format('n')] . ' ' . $date->format('y'),
                    'value' => $date->format('Y-m-01')
                ];
            }
        }

        if (count($monthsItems) == 0) {
            $monthsItems[] = [
                'text' => $months[$dateStart->format('n')] . ' ' . $dateStart->format('y'),
                'value' => $dateStart->format('Y-m-01')
            ];
        }

        $this->Viewer_Assign('months', $months);
        $this->Viewer_Assign('monthsItems', $monthsItems);
        $this->Viewer_Assign('dateStart', $dateStart);
        $this->Viewer_Assign('costItems', Config::Get('costs_items'));
        $this->Viewer_Assign('costs', $costs);
        $this->Viewer_Assign('pivotCosts', $pivotCosts);
        $this->Viewer_SetHtmlTitle('Отчеты // Расходы');
        $this->SetTemplateAction('report.costs');
    }

    public function ReportFailure()
    {
        if (!LS::HasRight('37_report_failure')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, $this->Lang_Get('plugin.admin.menu.report_failure'));

        $managerId = (int)getRequest('manager_id');

        $oDateWeek = new DateTime('');
        if (getRequestStr('date_from')) {
            $dateFrom = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_from'))));
        } else {
            $dateFrom = new DateTime('-8week -' . ($oDateWeek->format('N') - 1) . 'days');
            $dateFrom = new DateTime('01.' . $oDateWeek->format('m.Y'));
        }
        if (getRequestStr('date_to')) {
            $dateTo = new DateTime(date('d.m.Y', strtotime(getRequestStr('date_to'))));
        } else {
            $dateTo = new DateTime();
        }

        $months = Config::Get('months');
        $statusItems = Config::Get('order.status');
        $statusFailure = ['failure', 'reclamation', 'failure-ready', 'return'];

        foreach($statusItems as $index => $item) {
            if (!in_array($item['value'], $statusFailure)) {
                unset($statusItems[$index]);
            }
        }

        $statusFailureCurrent = getRequest('type');
        if ($statusFailureCurrent) {
            $statusFailure = $statusFailureCurrent;
        }


        $makeIds = getRequest('make_id');

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
                't.*',
                'o.agent_number, o.status order_status, o.date_add, o.status, o.closed',
                'd.title_full design_title_full',
                'p.title_full product_title_full',
                'm.title make_title',
                'orj.rejected_type, orj.rejected_cause'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.order') . ' o ON o.id = t.order_id',
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'INNER JOIN ' . Config::Get('db.table.make') . ' m ON t.make_id = m.id',
                'LEFT JOIN ' . Config::Get('db.table.design') . ' d ON d.id = t.design_id',
                'LEFT JOIN ' . Config::Get('db.table.order_rejected') . ' orj ON orj.order_id = o.id',
            ],
            '#where' => [
                '(orj.date_add >= ? AND orj.date_add <= ?) 
                 AND orj.order_status IN (?a) 
                {AND o.manager_id = ?d} 
                {AND t.make_id IN (?a)}
                {AND t.product_id = ?d}' => [
                    $dateFrom->format('Y-m-d'), $dateTo->format('Y-m-d'),
                    $statusFailure,
                    $managerId ? $managerId : DBSIMPLE_SKIP,
                    $makeIds ? $makeIds : DBSIMPLE_SKIP,
                    $productId ? $productId : DBSIMPLE_SKIP
                ]
            ],
            '#order' => ['o.date_add'],
            '#cache' => false
        ];

        $orderProducts = $this->Order_GetProductsItemsByFilter($filter);

        $users = $this->User_GetItemsByIsManager(1);
        $managerItems = [[
            'text' => '---',
            'value' => ''
        ]];
        foreach ($users as $user) {
            $managerItems[] = [
                'text' => $user->getFio(),
                'value' => $user->getId()
            ];
        }

        /**
         * Фабрика
         */
        $makeForSelect = $this->Make_GetListForSelect();
        ksort($makeForSelect);

        $this->Viewer_Assign('product', $product);
        $this->Viewer_Assign('statusFailure', $statusFailure);
        $this->Viewer_Assign('rejectedTypes', Config::Get('rejected_types'));
        $this->Viewer_Assign('makeForSelect', $makeForSelect);
        $this->Viewer_Assign('months', $months);
        $this->Viewer_Assign('dateFrom', $dateFrom);
        $this->Viewer_Assign('dateTo', $dateTo);
        $this->Viewer_Assign('statusItems', $statusItems);
        $this->Viewer_Assign('managerItems', $managerItems);
        $this->Viewer_Assign('orderProducts', $orderProducts);
        $this->Viewer_SetHtmlTitle('Отчеты // Отказы');
        $this->SetTemplateAction('report.failure');
    }

    /**
     * Доставка КАРТА
     */
    public function ReportDeliveryMap()
    {
        if (!LS::HasRight('4_report_delivery')) return parent::EventForbiddenAccess();
        $aOrder = [];
        $iCarNumber = (int)getRequest('car_number', 0);
        if ($sDate = getRequestStr('date')) {
            $oDate = new DateTime($sDate);
            $aOrder = $this->Order_GetItemsByFilter([
                '#where' => [
                    't.date_delivery = ? {AND t.car_number = ?}' => [
                        $oDate->format('Y-m-d 00:00:00'),
                        $iCarNumber ? $iCarNumber : DBSIMPLE_SKIP
                    ]
                ],
                '#order' => ['car_number']
            ]);
        }
        $this->Viewer_Assign('iCarNumber', $iCarNumber);
        $this->Viewer_Assign('sDate', $sDate);
        $this->Viewer_Assign('aOrder', $aOrder);
        $aData = [
            "type" => "FeatureCollection",
            "features" => [],
        ];
        foreach ($aOrder as $iKey => $oOrder) {
            $this->Viewer_Assign('oOrder', $oOrder);
            $sFieldSelect = $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__) . 'report/delivery.field.select.tpl');
            $aData['features'][] = [
                "type" => "Feature",
                "id" => $oOrder->getId(),
                "geometry" => [
                    "type" => "Point",
                    "coordinates" => [$oOrder->getLongitude(), $oOrder->getLatitude()]
                ],
                "properties" => [
                    "balloonContentHeader" => 'Заказ №' . $oOrder->getAgentNumber(),
                    "balloonContentBody" => '<div class="address">' . $oOrder->getAddress() . '</div>' . $sFieldSelect,
                    "balloonContentFooter" => "",
                    "clusterCaption" => 'Заказ №' . $oOrder->getAgentNumberRtl(),
                    "hintContent" => "",
                ],
                "options" => [
                    'iconLayout' => 'default#image',
                    'iconImageHref' => 'https://fisher-store.ru/application/frontend/skin/fisher/assets/images/map/icon'.(count($aOrder) < 20 ? '-'.($iKey+1) : '').'.png'
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
        $this->SetTemplateAction('report.delivery.map');
    }

    /**
     * Доставка
     */
    public function ReportDelivery()
    {
        if (!LS::HasRight('4_report_delivery')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Доставка');
        $aOrder = [];
        $filter = [];
        $filter['#where']['t.status IN (?a)'] = ['make', 'reclamation']; /* рекламация - ремонты */
        if ($sDate = getRequestStr('date')) {
            $iCarNumber = getRequest('car_number');
            $oDate = new DateTime($sDate);
            $filter['#where']['t.date_delivery = ?'] = $oDate->format('Y-m-d 00:00:00');
            if ($iCarNumber) {
                $filter['#where']['t.car_number = ?d'] = $iCarNumber;
            }
        }

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
        $aMakeId = getRequest('make_id', [10, 6]);
        $aMakeId = array_diff($aMakeId, ['all', 'dall']);
        if (count($aMakeId)) {
            $aMake = $this->Make_GetItemsByArrayId($aMakeId);
            $this->Viewer_Assign('aMake', $aMake);
            $filter['#join'] = [
                'LEFT JOIN '.Config::Get('db.table.order_products').' op ON op.order_id = t.id'
            ];
            $filter['#where']['op.make_id IN (?a)'] = $aMakeId;
        } else {
            $aMakeId = [1000];
        }
        $this->Viewer_Assign('aMakeSelected', $aMakeId);

        /*
         * Преобразуем фильтр
         */
        $sWhere = implode(' AND ', array_keys($filter['#where']));
        $aWhere = array_values($filter['#where']);
        $filter['#where'] = [];
        $filter['#where'][$sWhere] = $aWhere;
//        prex($filter);
        $aOrder = $this->Order_GetItemsByFilter($filter);

        $this->Viewer_Assign('sDate', $sDate);
        $this->Viewer_Assign('aOrder', $aOrder);
        $this->Viewer_Assign('sCurrentPath', $_SERVER['REQUEST_URI']);
        $this->Viewer_SetHtmlTitle('Отчеты // Доставка');
        $this->SetTemplateAction('report.delivery');
    }

    /**
     * Скачиваем отчет по доставке по всем машинам
     */
    public function ReportDeliveryDownload()
    {
        if (!LS::HasRight('4_report_delivery')) return parent::EventForbiddenAccess();
        $aOrder = [];
        if ($sDate = getRequestStr('date')) {
            $iCarNumber = getRequest('car_number');
            $oDate = new DateTime($sDate);
            $aOrder = $this->Order_GetItemsByFilter([
                '#where' => [
                    't.date_delivery = ? { AND t.car_number = ?d}' => [
                        $oDate->format('Y-m-d 00:00:00'),
                        ($iCarNumber) ? $iCarNumber : DBSIMPLE_SKIP,
                    ]
                ]
            ]);
            if (count($aOrder) == 0) return parent::EventError('Заказы не найдены');

            require_once Config::Get('path.application.server') . '/libs/vendor/PHPExcel-1.8/Classes/PHPExcel.php';
            require_once Config::Get('path.application.server') . '/libs/vendor/PHPExcel-1.8/Classes/PHPExcel/Writer/Excel5.php';

            // Создаем объект класса PHPExcel
            $xls = new PHPExcel();
            // Устанавливаем индекс активного листа
            $xls->setActiveSheetIndex(0);
            // Получаем активный лист
            $sheet = $xls->getActiveSheet();
            // Подписываем лист
            $sheet->setTitle('Доставка от ' . $oDate->format('d.m.Y'));

            // шапка
            $sheet->setCellValueByColumnAndRow(0, 1, 'Машина');
            $sheet->setCellValueByColumnAndRow(1, 1, '№ Фабрики');
            $sheet->getColumnDimension('B')->setWidth(16);
            $sheet->setCellValueByColumnAndRow(2, 1, 'Агент');
            $sheet->getColumnDimension('C')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(3, 1, '№ Агента');
            $sheet->getColumnDimension('D')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(4, 1, 'Товар');
            $sheet->getColumnDimension('E')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(5, 1, "Сумма\nтовара");
            $sheet->getColumnDimension('F')->setAutoSize(true);
            $sheet->getStyle("F1")->getAlignment()->setWrapText(true);
            $sheet->setCellValueByColumnAndRow(6, 1, "Доставка");
            $sheet->getColumnDimension('G')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(7, 1, "МКАД,\nТТК,\nЦентр");
            $sheet->getColumnDimension('H')->setAutoSize(true);
            $sheet->getStyle("H1")->getAlignment()->setWrapText(true);
            $sheet->setCellValueByColumnAndRow(8, 1, "Занос");
            $sheet->getColumnDimension('I')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(9, 1, "Сборка");
            $sheet->getColumnDimension('J')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(10, 1, "Предоплата");
            $sheet->getColumnDimension('K')->setAutoSize(true);
            $sheet->setCellValueByColumnAndRow(11, 1, "Итого");
            $sheet->getColumnDimension('L')->setAutoSize(true);
            $sheet->getStyle("A1:L1")->getFont()->setBold(true);
            $sheet->getStyle("A1:L1")->getAlignment()
                ->setVertical(PHPExcel_Style_Alignment::HORIZONTAL_CENTER)
                ->setHorizontal(PHPExcel_Style_Alignment::HORIZONTAL_CENTER);

            $iRow = 2;
            foreach ($aOrder as $oOrder) {
                $sheet->setCellValue("A" . $iRow, $oOrder->getCarNumber());
                $sheet->setCellValue("B" . $iRow, $oOrder->getId());
                $sheet->getCell('B' . $iRow)->getHyperlink()->setUrl('https://sergey-utin.ru/jarvis/order/' . $oOrder->getId() . '/');
                $sheet->setCellValue("C" . $iRow, $oOrder->getAgent()->getFio());
                $sheet->setCellValue("D" . $iRow, $oOrder->getAgentNumber());
                $sProduct = '';
                foreach ($oOrder->getProducts() as $oOrderProduct) {
                    $sFabrics = '';
                    foreach ([1, 2, 3, 4] as $iNum) {
                        if ($oOrderProduct->getFabricLength($iNum) > 0) {
                            if ($iNum > 1) $sFabrics = "{$sFabrics} // ";
                            $oFabric = $oOrderProduct->getFabric($iNum);
                            if ($oFabric) $sFabrics = "{$sFabrics} {$oFabric->getAlt()} ({$oFabric->getSupplier()})";
                        }
                    }
                    $sProduct = "{$oOrderProduct->getProductTitleFull(false)}\n - {$sFabrics}";
                }
                $sheet->setCellValue("E" . $iRow, $sProduct);
                $sheet->getStyle("E" . $iRow)->getAlignment()->setWrapText(true);
                $sheet->setCellValue("F" . $iRow, $oOrderProduct->getPrice());
                $sheet->setCellValue("G" . $iRow, $oOrderProduct->getPriceDelivery());
                $sheet->setCellValue("H" . $iRow, $oOrderProduct->getPriceDeliveryDop());
                $sheet->setCellValue("I" . $iRow, $oOrderProduct->getPriceZanosa());
                $sheet->setCellValue("J" . $iRow, $oOrderProduct->getPriceSborki());
                $sheet->setCellValue("K" . $iRow, $oOrder->getPrepayment() == 0 ? 0 : -($oOrder->getPrepayment()));
                $sheet->setCellValue("L" . $iRow, "=F{$iRow}+G{$iRow}+H{$iRow}+I{$iRow}+J{$iRow}+K{$iRow}");
                ++$iRow;
            }
            $sheet->setCellValue("K" . $iRow, "ИТОГО");
            $i = $iRow - 1;
            $sheet->setCellValue("L" . $iRow, "=SUM(L2:L{$i})");
            $sheet->getStyle("A1:L{$iRow}")->applyFromArray(
                array(
                    'borders' => array(
                        'allborders' => array(
                            'style' => PHPExcel_Style_Border::BORDER_THIN,
                            'color' => array('rgb' => '000000')
                        )
                    )
                )
            );

            // Выводим HTTP-заголовки
            header("Expires: Mon, 1 Apr 1974 05:00:00 GMT");
            header("Last-Modified: " . gmdate("D,d M YH:i:s") . " GMT");
            header("Cache-Control: no-cache, must-revalidate");
            header("Pragma: no-cache");
            header("Content-type: application/vnd.ms-excel");
            header("Content-Disposition: attachment; filename=Доставка от " . $oDate->format('d.m.Y') . '.xls');

            // Выводим содержимое файла
            $objWriter = new PHPExcel_Writer_Excel5($xls);
            $objWriter->save('php://output');
        }
    }

    public function ReportSummary()
    {
        $orders = $this->Order_GetItemsByFilter([
            '#select' => [
                "DATE_FORMAT(t.date_add, '%Y-%m-01') date_month_year,
                   SUM((SELECT
                       SUM(op.agent_commission) m
                       FROM ".Config::Get('db.table.order')." o1
                       INNER JOIN ".Config::Get('db.table.order_products')." op ON op.order_id = o1.id
                       WHERE op.order_id = t.id) - t.discount) margin,
                   SUM(discount) discount_sum,
                   COUNT(t.id) orders_count,
                   DAY(LAST_DAY(t.date_add)) last_day"
            ],
            '#where' => [
                't.status IN (?a)' => [
                    ['make', 'feedback', 'delivered', 'reclamation']
                ]
            ],
            '#group' => '#date_month_year',
            '#order' => ['#date_month_year' => 'desc']
        ]);

        $costs = $this->Cost_GetItemsByFilter([
            '#select' => [
                "SUM(sum) sum,
                DATE_FORMAT(t.date, '%m.%Y') date_month_year"
            ],
            '#group' => '#date_month_year',
            '#index-from' => 'date_month_year'
        ]);
        $dateCurrent = new DateTime();
        $this->Viewer_Assign('dateCurrent', $dateCurrent);
        $this->Viewer_Assign('orders', $orders);
        $this->Viewer_Assign('costs', $costs);
        $this->Viewer_SetHtmlTitle('Отчеты // Сводный отчет');
        $this->SetTemplateAction('report.summary');
    }
}
