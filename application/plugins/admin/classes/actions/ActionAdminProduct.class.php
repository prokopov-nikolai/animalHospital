<?php

class PluginAdmin_ActionAdminProduct extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Товары', 'product');
        $this->Viewer_AppendScript(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/js/init.js');
        $this->Viewer_AppendScript(Plugin::GetTemplateWebPath(__CLASS__) . 'assets/js/product.js');
        $this->SetDefaultEvent('category');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {

        $this->AddEventPreg('/^import-data$/i', '/^add-product$/i', 'ProductImportDataAddProduct');
        $this->AddEventPreg('/^import-data$/i', '/^add-design$/i', 'ProductImportDataAddDesign');
        $this->AddEventPreg('/^import-data$/i', '/^$/i', 'ProductImportData');
        $this->AddEventPreg('/^design$/i', '/^import-data$/i', '/^$/i', 'DesignImportData');
        $this->AddEventPreg('/^design$/i', '/^copy$/i', '/^[0-9]+$/i', 'ProductDesignCopy');
        $this->AddEventPreg('/^design$/i', '/^delete$/i', '/^[0-9]+$/i', 'ProductDesignDelete');
        $this->AddEventPreg('/^design$/i', '/^[0-9]+$/i', 'ProductDesignEdit');
        $this->AddEventPreg('/^design$/i', '/^(page(\d+))?$/i', 'ProductDesignList');
        $this->AddEventPreg('/^design$/i', '/^main-photo-update$/i', 'ProductDesignMainPhotoUpdate');
        $this->AddEventPreg('/^main-photo-update$/i', 'ProductMainPhotoUpdate');
        $this->AddEventPreg('/^category$/i', '/^([0-9]+)$/i', '/^(page(\d+))?$/i', 'ProductList');
        $this->AddEventPreg('/^category$/i', 'CategoryList');
        $this->AddEventPreg('/^([0-9]+)$/i', 'ProductEdit');
//        $this->AddEventPreg('/^margin$/i', 'ProductMargin');
        $this->AddEventPreg('/^add$/i', 'ProductAdd');
        $this->AddEventPreg('/^delete$/i', '/^([0-9]+)?$/i', 'ProductDelete');
        $this->AddEventPreg('/^redirect$/', '/^([0-9]+)$/i', 'ProductRedirect');
        $this->AddEventPreg('/^copy$/', '/^([0-9]+)$/i', 'ProductCopy');
        $this->AddEventPreg('/^discount$/', 'ProductDiscount');

        $this->AddEventPreg('/^import-kypit-divan$/', 'ProductImportKypitDivan');

        /**
         * Для ajax регистрируем внешний обработчик
         */
        $this->RegisterEventExternal('AjaxProduct', 'PluginAdmin_ActionAdminProduct_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^design$/i', '/^add$/i', 'AjaxProduct::DesignAdd');
        $this->AddEventPreg('/^ajax$/i', '/^media$/i', '/^update$/i', 'AjaxProduct::MediaUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^media$/i', '/^sort$/i', 'AjaxProduct::MediaSort');
        $this->AddEventPreg('/^ajax$/i', '/^media$/i', '/^remove$/i', 'AjaxProduct::MediaRemove');

        $this->AddEventPreg('/^ajax$/i', '/^search$/i', 'AjaxProduct::Search');
        $this->AddEventPreg('/^ajax$/i', '/^design$/i', '/^search$/i', 'AjaxProduct::DesignSearch');

        $this->AddEventPreg('/^ajax$/i', '/^upload-from-site$/i', 'AjaxProduct::UploadImagesFromSite');
        $this->AddEventPreg('/^ajax$/i', '/^upload-images$/i', 'AjaxProduct::UploadImagesByUrl');

        $this->AddEventPreg('/^ajax$/i', '/^group$/i', '/^add-item$/i', 'AjaxProduct::ProductGroupAdd');
        $this->AddEventPreg('/^ajax$/i', '/^group$/i', '/^update-item$/i', 'AjaxProduct::ProductGroupUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^group$/i', '/^remove-item$/i', 'AjaxProduct::ProductGroupRemove');


        // ==================================================================
        // ==================================================================
        // ==================================================================
        // ==================================================================

        /**
         * ajax
         */
        $this->AddEventPreg('/^ajax$/i', '/^price_update/i', 'AjaxProduct::ProductPriceUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^similar_delete/i', 'AjaxProduct::SimilarDelete');
        $this->AddEventPreg('/^ajax$/i', '/^similar_add/i', 'AjaxProduct::SimilarAdd');
        $this->AddEventPreg('/^ajax$/i', '/^similar_update/i', 'AjaxProduct::SimilarUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^design_delete/i', 'AjaxProduct::DesignDelete');
        $this->AddEventPreg('/^ajax$/i', '/^design_price_update$/i', 'AjaxProduct::DesignPriceUpdate');

    }

    /**
     * Список дизайнов
     */
    public function ProductDesignList()
    {
        if (!LS::HasRight('7_product_design_edit')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Дизайны', 'design');

        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $iPerPage = isset($_GET['avito']) ? 500 : 50;
        $iPage = $this->GetParamEventMatch(0, 2);
        if (!$iPage) $iPage = 1;
        $aDesign = $this->Design_GetItemsByFilter([
            '#select' => [
                'DISTINCT t.*',
                'CONCAT(c.url,"/",p.url,"-",t.url,"-", IF(t.id < 1000, LPAD(t.id,4,"0"), t.id)) url_full',
                'p.title product_title',
                'pp.price price_make, pp.margin, pp.discount',
                'c.product_prefix',
                'm.file_path'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.product_prices') . '  pp ON pp.product_id = t.product_id AND pp.make_group = t.make_group',
                'INNER JOIN ' . Config::Get('db.table.category_filter') . ' c ON c.id = p.category_id',
                'LEFT JOIN  ' . Config::Get('db.table.media') . ' m ON m.target_id = t.id AND m.main = 1 AND m.target_type = "design"'
            ],
            '#where' => [
                '1=1 ' . (isset($_GET['avito']) ? ' AND (t.avito_date_begin IS NOT NULL OR t.avito_date_end IS NOT NULL)' : '') . '
                        {AND (t.title_full LIKE ?} 
                            { OR t.title_full LIKE ?}
                            { OR t.title_full LIKE ?}
                            { OR t.title_full LIKE ?
                           )}
                           ' => [
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP
                ]
            ],
            '#order' => [(isset($_GET['avito']) ? 't.avito_date_begin' : 'p.title') => 'desc', 't.title'],
            '#page' => [$iPage, $iPerPage]
        ]);
//        prex($aDesign['collection']);
        if ($iPage > 1 && count($aDesign['collection']) == 0) return parent::EventNotFound();
        $this->Viewer_Assign('aDesign', $aDesign['collection']);
        $aPaging = $this->Viewer_MakePaging($aDesign['count'], $iPage, $iPerPage, Config::Get('pagination.pages.count'), ADMIN_URL . 'product/design/', $_GET);
        $this->Viewer_Assign('aPaging', $aPaging);
        $this->SetTemplateAction('design.list');
    }

    /**
     * Редактируем дизайн
     * @return string
     */
    public function ProductDesignEdit()
    {
        if (!LS::HasRight('7_product_design_edit')) return parent::EventForbiddenAccess();
        $iDesignId = $this->GetParamEventMatch(0, 0);
        $oDesign = $this->Design_GetDesignByFilter([
            '#select' => [
                't.*',
                'CONCAT(c.product_prefix, " ", p.title) product_title',
                'CONCAT(c.url,"/",p.url,"-",t.url,"-", IF(t.id < 1000, LPAD(t.id,4,"0"), t.id)) url_full',
                'CONCAT(p.url,"-",t.url,"-", IF(t.id < 1000, LPAD(t.id,4,"0"), t.id)) url_short',
                't.price_make product_price_make',
                't.discount',
//                'pp.price product_price_make',
                'p.price_delivery product_price_delivery',
                'p.price_delivery_make product_price_delivery_make',
                'c.id category_id',
                'c.title category_title',
                'c.product_prefix',
                'make.title make_title'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.product'), ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.product_prices') . '  pp ON pp.product_id = t.product_id AND pp.make_group = t.make_group',
                'INNER JOIN ' . Config::Get('db.table.category_filter'), ' c ON c.id = p.category_id',
                'INNER JOIN ' . Config::Get('db.table.make'). ' make ON make.id = p.make_id'
            ],
            '#where' => ['t.id = ?d' => [$iDesignId]]
        ]);
        if (!$oDesign) return parent::EventNotFound();

        $this->AppendBreadCrumb(30, 'Дизайны', 'design');
        $this->AppendBreadCrumb(40, $oDesign->getId());
        $oProduct = $oDesign->getProduct();
        if (isPost()) {
            $aDesign = getRequest('design');
//            prex($aDesign);
            $aFabricId = [];
            if (!isset($aDesign['not_produced'])) $aDesign['not_produced'] = 0;
            if (!isset($aDesign['hide'])) $aDesign['hide'] = 0;
            if (!isset($aDesign['market'])) $aDesign['market'] = 0;
            if ($aDesign['fabric1_id']) $aFabricId[] = $aDesign['fabric1_id'];
            if ($aDesign['fabric2_id']) $aFabricId[] = $aDesign['fabric2_id'];
            if ($aDesign['fabric3_id']) $aFabricId[] = $aDesign['fabric3_id'];
            if ($aDesign['fabric4_id']) $aFabricId[] = $aDesign['fabric4_id'];
            if ($aDesign['discount_date_from']) {
                $oDateTo = new DateTime($aDesign['discount_date_from']) ;
                $aDesign['discount_date_from'] = $oDateTo->format('Y-m-d H:i:s');
            }
            if ($aDesign['discount_date_to']) {
                $oDateTo = new DateTime($aDesign['discount_date_to']) ;
                $aDesign['discount_date_to'] = $oDateTo->format('Y-m-d H:i:s');
            }
            $oDesign->_setData($aDesign);
            if ($oDesign->_Validate()) {
                $oDate = new DateTime();
                $oDesign->setDateUpdate($oDate->format('Y-m-d H:i:s'));
                // Полное наименование // надо два раза сохранять
                $oDesign->setTitleFull($oDesign->getTitle());
                if (count($aFabricId) > 0) {
                    /**
                     * Eсли метраж указан, то расчитываем цену согласно метражу
                     */
                    if ($oProduct->getFabric1()) {
                        /**
                         * Получим цены на ткани
                         */
                        $aMedia = $this->Media_GetMediaItemsByFilter([
                            '#select' => ['t.id, mc.make_group, pp.price'],
                            '#join' => [
                                'INNER JOIN ' . Config::Get('db.table.collection') . ' c ON c.id = t.target_id AND t.target_type = "collection"',
                                'INNER JOIN ' . Config::Get('db.table.make_collections') . ' mc ON mc.collection_id = c.id AND mc.make_id = ' . $oProduct->getMakeId(),
                                'INNER JOIN ' . Config::Get('db.table.product_prices') . ' pp ON pp.make_group = mc.make_group AND pp.product_id = ' . $oProduct->getId()
                            ],
                            '#where' => ['t.id IN (?a)' => [$aFabricId]],
                            '#index-from' => 'id'
                        ]);
                        $aMakeGroup = [];
                        $iPriceMake = 0;
                        /**
                         * Проверим, чтобы выбранных тканей было не меньше чем указано в метражах товара
                         */
                        if ($oProduct->getFabric2() > 0 && !$aDesign['fabric2_id']) $oDesign->setFabric2Id($aDesign['fabric1_id']);
                        if ($oProduct->getFabric3() > 0 && !$aDesign['fabric3_id']) $oDesign->setFabric3Id($aDesign['fabric1_id']);
                        if ($oProduct->getFabric4() > 0 && !$aDesign['fabric4_id']) $oDesign->setFabric4Id($aDesign['fabric1_id']);
                        foreach ([1, 2, 3, 4] as $iNum) {
                            $oProduct->getFabricPartAmount($iNum);
                            $sFunction = "getFabric{$iNum}Id";
                            if ($iFabricId = $oDesign->$sFunction()) {
                                if (!isset($aMedia[$iFabricId])) {
                                    $oMedia = $this->Media_GetByFilter([
                                        '#select' => ['t.*', 'c.supplier'],
                                        '#join' => ['INNER JOIN ' . Config::Get('db.table.collection') . ' c ON c.id = t.target_id'],
                                        '#where' => ['t.id = ?' => [$iFabricId]]
                                    ]);
                                    if ($oMedia) {
                                        $this->Message_AddErrorSingle('Цена не расчитана, т.к. для ткани "' . $oMedia->getTitleFull() . '" не указана группа производителя');
                                    } else {
                                        $this->Message_AddErrorSingle('Не найдена ткань с айди ' . $iFabricId);
                                    }
                                    break;
                                }
                                $oFabric = $aMedia[$iFabricId];
                                $aMakeGroup[] = $oFabric->getMakeGroup();
                                $iPriceMake += $oProduct->getFabricPartAmount($iNum) * $oFabric->getPrice();
                            }
                        }
                        if (count($aMakeGroup)) $oDesign->setMakeGroup(max($aMakeGroup));
                        $oDesign->setPriceMake($iPriceMake);
                    } else {
                        /**
                         * Определим максимальную группу производителя
                         */
                        $oMedia = $this->Media_GetByFilter([
                            '#select' => ['MAX(mc.make_group) make_group'],
                            '#join' => [
                                'INNER JOIN ' . Config::Get('db.table.collection') . ' c ON c.id = t.target_id AND t.target_type = "collection"',
                                'INNER JOIN ' . Config::Get('db.table.make_collections') . ' mc ON mc.collection_id = c.id AND mc.make_id = ' . $oDesign->getMakeId()
                            ],
                            '#where' => ['t.id IN (?a)' => [$aFabricId]]
                        ]);
                        $oDesign->setMakeGroup($oMedia->getMakeGroup());
                    }
                }
                if (isset($_FILES['photo']) && count($_FILES['photo'])) {
                    foreach ($_FILES['photo']['error'] as $iK => $iError) {
                        if ($iError == 0) {
                            $mMedia = $this->Media_UploadUrl($_FILES['photo']['tmp_name'][$iK], 'design', $oDesign->getId());
                            if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                                $this->Message_AddError($mMedia . ' : ' . $iK, '');
                            }
                        }
                    }
                }
                $oDateNow = new DateTime();
                if ($oDesign->getDiscountDateFrom('Y-m-d') <= $oDateNow->format('Y-m-d') &&
                    $oDateNow->format('Y-m-d') <= $oDesign->getDiscountDateTo('Y-m-d')) {
                    $oDesign->setDiscount($oDesign->getDiscountDate());
                } else {
                    $oDesign->setDiscount(0);
                }
                $oDesign->Update();
                $this->Message_AddNoticeSingle('Успешно сохранено');
            } else {
                $this->Message_AddError($oDesign->_getValidateError(), 'Ошибка');
            }
        }

        $this->Viewer_Assign('oDesign', $oDesign);
        $this->Viewer_Assign('oProduct', $oProduct);
        $this->SetTemplateAction('design.edit');
    }


    /**
     * Копируем дизайн
     */
    public function ProductDesignCopy()
    {
        $oDesign = $this->Design_GetById($this->GetParamEventMatch(1, 0));

        if (!$oDesign) return Router::ActionError('', 'Дизайн не найден');
        $iDesignIdNew = $this->Design_Copy($oDesign);
        /**
         * Копируем изображения
         */
        foreach($oDesign->getPhotos() as $oMedia) {
            $oM = $this->Media_UploadUrl($oMedia->getFileServerPath(), 'design', $iDesignIdNew);
            $oM->setAlt($oMedia->getAlt());
            $oM->setMain($oMedia->getMain());
            $oM->Update();
        }
        $this->Message_AddNoticeSingle('Дизайн успешно скопирован', '', true);
        return Router::Location(ADMIN_URL.'product/design/'.$iDesignIdNew.'/');

    }
    /**
     * Удаление дизайна
     */
    public function ProductDesignDelete()
    {
        if (!LS::HasRight('29_product_design_delete')) return parent::EventForbiddenAccess();
        $iDesignId = $this->GetParamEventMatch(1, 0);
        $oDesign = $this->Design_GetByFilter([
            '#select' => [
                't.*',
                'CONCAT(c.product_prefix, " ", p.title, " ", t.title) title_full',
                'p.title product_title',
                'p.make_id',
                'c.product_prefix'],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'LEFT JOIN ' . Config::Get('db.table.product_prices') . ' pp ON pp.product_id = t.product_id AND pp.make_group = 1',
                'INNER JOIN ' . Config::Get('db.table.category_filter') . ' c ON c.id = p.category_id'
            ],
            '#where' => ['t.id = ?d' => [$iDesignId]]
        ]);
        if (!$oDesign) return parent::EventNotFound();
        if ($oDesign->Delete()) {
            $this->Message_AddNoticeSingle('Дизайн успешно удален', false, true);
        } else {
            $this->Message_AddErrorSingle('Дизайн не может быть удален, так как с ним есть заказы', false, true);
        }
        return Router::Location($_SERVER['HTTP_REFERER']);
    }

    /**
     * Список категорий
     */
    public function CategoryList()
    {
        if (!LS::HasRight('6_product_edit')) return parent::EventForbiddenAccess();
        if (isset($_GET['search'])) {
            $sSearch = getRequestStr('search');
            $sSearch1 = lat2rus($sSearch);
            $sSearch2 = Translit($sSearch);
            $sSearch3 = rus2lat($sSearch);
            $aFilter = [
                '#select' => [
                    't.*', 'pp.price price_make', 'm.file_path'
                ],
                '#join' => [
                    'LEFT JOIN ' . Config::Get('db.table.media') . '    m  ON m.target_id  = t.id AND m.main = 1 AND m.target_type = "product"',
                    'LEFT JOIN ' . Config::Get('db.table.product_prices') . '  pp ON pp.product_id = t.id AND pp.make_group = 1',
                ],
                '#where' => [
                    't.title_full LIKE ?
                     OR t.title_full LIKE ?
                     OR t.title_full LIKE ?
                     OR t.title_full LIKE ?
                ' => [
                        '%' . $sSearch . '%',
                        '%' . $sSearch1 . '%',
                        '%' . $sSearch2 . '%',
                        '%' . $sSearch3 . '%'
                    ]],
                '#order' => 't.title',
                '#page' => [1, 1000]
            ];
            $aProduct = $this->Product_GetProductItemsByFilter($aFilter);
            $this->Viewer_Assign('aProduct', $aProduct['collection']);
            $this->SetTemplateAction('product.list');
        } else {
            $this->Viewer_Assign('aCategoryTree', $this->Category_GetFilterItemsByFilter([
                '#where' => ['t.base = ?' => [1]],
                '#order' => ['title' => 'asc']
            ]));
            $this->SetTemplateAction('category.list');
        }
    }

    /**
     * Список категорий
     */
    public function ProductList()
    {
        if (!LS::HasRight('6_product_edit')) return parent::EventForbiddenAccess();
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);

        $iCategoryId = (int)Router::GetParam(0);
        $iPerPage = 50;
        $iPage = $this->GetParamEventMatch(1, 2);
        if (!$iPage) $iPage = 1;
        /**
         * Данные для хлебных крошек
         */
        $oCategory = $this->Category_GetFilterByFilter([
            'id' => $iCategoryId,
            'base' => 1
        ]);
        $iLevel = 50;
        if ($oCategory) {
            $this->AppendBreadCrumb($iLevel, $oCategory->getTitle(), 'product/category/' . $oCategory->getId());
        }

        $aFilter = [
            '#select' => [
                't.*', 'pp.price price_make', 'm.file_path'
            ],
            '#join' => [
                'LEFT JOIN ' . Config::Get('db.table.media') . '    m  ON m.target_id  = t.id AND m.main = 1 AND m.target_type = "product"',
                'LEFT JOIN ' . Config::Get('db.table.product_prices') . '  pp ON pp.product_id = t.id AND pp.make_group = 1',
            ],
            '#where' => [
                't.category_id = ? { AND (t.title_full LIKE ?} 
                                            { OR t.title_full LIKE ?}
                                            { OR t.title_full LIKE ?}
                                            { OR t.title_full LIKE ?
                                           )}' => [
                    $iCategoryId,
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP
                ]],
            '#order' => 't.title',
            '#page' => [$iPage, $iPerPage]
        ];
        if (($sSort = getRequestStr('sort')) && ($sDirection = getRequestStr('direction'))) {
            $aFilter['#order'] = array($sSort => $sDirection);
            $this->Viewer_Assign('sSort', $sSort);
            $this->Viewer_Assign('sDirection', $sDirection);
        }
        $aProduct = $this->Product_GetProductItemsByFilter($aFilter);
        if ($iPage > 1 && count($aProduct['collection']) == 0) return parent::EventNotFound();
        $this->Viewer_Assign('aProduct', $aProduct['collection']);
        $this->Viewer_Assign('oCategory', $oCategory);
        $this->Viewer_Assign('iCategoryId', $oCategory->getId());
        $aPaging = $this->Viewer_MakePaging($aProduct['count'], $iPage, $iPerPage, Config::Get('pagination.pages.count'), ADMIN_URL . 'product/category/' . $oCategory->getId() . '/', $_GET);
        $this->Viewer_Assign('aPaging', $aPaging);
        $this->SetTemplateAction('product.list');
    }

    /**
     * Список товаров со скидками
     */
    public function ProductDiscount()
    {
        if (!LS::HasRight('8_product_discount')) return parent::EventForbiddenAccess();
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);

//        $iCategoryId = (int)Router::GetParam(0);
//        $iPerPage = 50;
//        $iPage = $this->GetParamEventMatch(1, 2);
//        if (!$iPage) $iPage = 1;
        /**
         * Данные для хлебных крошек
         */
//        $oCategory = $this->Category_GetFilterByFilter([
//            'id' => $iCategoryId,
//            'base' => 1
//        ]);
//        $iLevel = 50;
//        if ($oCategory) {
//            $this->AppendBreadCrumb($iLevel, $oCategory->getTitle(), 'product/category/' . $oCategory->getId());
//        }

        $aFilter = [
            '#select' => [
                't.*', 'pp.price price_make', 'm.file_path'
            ],
            '#join' => [
                'LEFT JOIN ' . Config::Get('db.table.media') . '    m  ON m.target_id  = t.id AND m.main = 1 AND m.target_type = "product"',
                'LEFT JOIN ' . Config::Get('db.table.product_prices') . '  pp ON pp.product_id = t.id AND pp.make_group = 1',
            ],
            '#where' => [
                't.discount_date_from <> "" { AND (t.title_full LIKE ?} 
                                            { OR t.title_full LIKE ?}
                                            { OR t.title_full LIKE ?}
                                            { OR t.title_full LIKE ?
                                           )}' => [
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP
                ]],
            '#order' => 't.discount_date_from, t.title'
        ];
        $aProduct = $this->Product_GetProductItemsByFilter($aFilter);
        $this->Viewer_Assign('aProduct', $aProduct);
        $this->SetTemplateAction('product.discount.list');
    }

    /**
     *  Редактирование товара
     */
    public function ProductEdit()
    {
        if (!LS::HasRight('6_product_edit')) return parent::EventForbiddenAccess();
        $this->SubmitProduct();
        $iProductId = $this->GetParamEventMatch(1);
        $oProduct = $this->Product_GetById($iProductId);
        $iLevel = 50;
        $this->AppendBreadCrumb($iLevel, $oProduct->getTitle(), 'product/' . $oProduct->getId());
        /**
         * Категория
         */
        $oCategory = $this->Category_GetFilterById($oProduct->getCategoryId());
        --$iLevel;
        $this->AppendBreadCrumb($iLevel, $oCategory ? $oCategory->getTitle() : '_category_not_found_' , 'category/' . ($oCategory ? $oCategory->getId()  : ''));
        $this->Viewer_Assign('oCategory', $oCategory);
        /**
         * Если есть категория, то формируем полный урл для товара
         */
        if ($oCategory) {
            $oProduct = $this->Product_GetProductItemsByFilter([
                '#select' => [
                    't.*',
                    "CONCAT(c.url_full, '/', t.url, '-p', IF(t.id < 1000, LPAD(t.id,4,'0'), t.id)) url_full",
                ],
                '#join' => [
                    'LEFT JOIN ' . Config::Get('db.table.category_filter') . ' c ON t.category_id = c.id',
                ],
                '#where' => ['t.id = ?' => [$iProductId]],
                '#limit' => 1,
                '#with' => ['category', 'make', 'media_items', 'chars', 'opts'],
                '#cache' => ['product_' . $iProductId]
            ])[0];
        }
        /**
         * Дополнительные даные для формы
         */
        $aCategorySelect = $this->Category_GetListForSelect();
        $aMakeSelect = $this->Make_GetListForSelect();
        $this->Viewer_Assign('aCategorySelect', $aCategorySelect);
        $this->Viewer_Assign('aMakeSelect', $aMakeSelect);
        $this->Viewer_Assign('oMake', $this->Make_GetById($oProduct->getMakeId()));
        $this->Viewer_Assign('oProduct', $oProduct);
        /**
         * Выводим карточку товара
         */
        $this->SetTemplateAction('product.edit');
    }

    /**
     * Обработка обновления товара
     */
    private function SubmitProduct()
    {
        if ($aProduct = getRequest('product', null, 'post')) {
            $oCategory = $this->Category_GetFilterById($aProduct['category_id']);
            $oMake = $this->Make_GetById($aProduct['make_id']);
            if (!isset($aProduct['in_stock'])) $aProduct['in_stock'] = 0;
            if (!isset($aProduct['hide'])) $aProduct['hide'] = 0;
            if (!isset($aProduct['not_produced'])) $aProduct['not_produced'] = 0;
            if (!isset($aProduct['slider'])) $aProduct['slider'] = 0;
            if (!isset($aProduct['new_yml'])) $aProduct['new_yml'] = 0;
            if (!isset($aProduct['3d'])) $aProduct['3d'] = 0;
            if (!isset($aProduct['market'])) $aProduct['market'] = 0;
            if (!isset($aProduct['url']) || trim($aProduct['url']) == '') {
                $aProduct['url'] = $this->Text_Transliteration($aProduct['title']);
                $aProduct['update_url'] = 1;
            }
            if (isset($aProduct['update_url'])) {
                $aProduct['url'] = $this->Main_GetUrl($aProduct['url'], 'product');
            }
            // реплейсим запятые в тканях
            $aProduct['fabric1'] = str_replace(',', '.', $aProduct['fabric1']);
            $aProduct['fabric2'] = str_replace(',', '.', $aProduct['fabric2']);
            $aProduct['fabric3'] = str_replace(',', '.', $aProduct['fabric3']);
            $aProduct['fabric4'] = str_replace(',', '.', $aProduct['fabric4']);
//            $aProduct['stolyary_price'] = str_replace(',', '.', $aProduct['stolyary_price']);
//            $aProduct['shvei_price'] = str_replace(',', '.', $aProduct['shvei_price']);
//            $aProduct['drapera_price'] = str_replace(',', '.', $aProduct['drapera_price']);

            if ($aProduct['discount_date_from']) {
                $oDateTo = new DateTime($aProduct['discount_date_from']) ;
                $aProduct['discount_date_from'] = $oDateTo->format('Y-m-d H:i:s');
            }
            if ($aProduct['discount_date_to']) {
                $oDateTo = new DateTime($aProduct['discount_date_to']) ;
                $aProduct['discount_date_to'] = $oDateTo->format('Y-m-d H:i:s');
            }
            $oDate = new DateTime($aProduct['date_new_before']);
            $aProduct['date_new_before'] = $oDate->format('Y-m-d H:i:s');

            /**
             * Чистим Кеш
             */
            $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('add_product', 'update_product'));
            $oProduct = Engine::GetEntity('Product');
            $oProduct->_setData($aProduct);
            if (!$oProduct->getUrl()) $oProduct->setUrl($this->Main_GetUrl(translit($oProduct->getName()), 'product'));
            if ($oProduct->_Validate()) {
                $oDate = new DateTime();
                $oProduct->setDateUpdate($oDate->format('Y-m-d H:i:s'));
                $oProduct->setTitleFull($oCategory->getProductPrefix() . ' ' . $oProduct->getTitle() . ' MФ (' . $oMake->getTitle() . ')');
                if (!$oProduct->getId()) {
                    $oProduct->setMargin(50);
                    $oProduct = $oProduct->Add();
                    return Router::Location(ADMIN_URL . 'product/' . $oProduct->getId() . '/');
                }
                $oProduct->Update();
                $oProductOld = $this->Product_GetById($oProduct->getId());
                $oProductOld->optionvalues->clear();
                $oProductOld->Save();
                /**
                 * Добавляем опции
                 */
                if (isset($aProduct['option_values'])) {
                    $aProductOptionValues = $aProduct['option_values'];
                    unset($aProduct['option_values']);
                    foreach ($aProductOptionValues as $sOptId) {
                        $oProductOpt = Engine::GetEntity('Product_OptionValues', [
                            'product_id' => $oProduct->getId(),
                            'option_value_id' => $sOptId
                        ]);
                        $oProductOpt->Add();
                    }
                    unset($aProduct['option_values']);
                }

                /**
                 * Добавляем характеристики
                 */
                $this->Product_DeleteCharsItemsByFilter(array(
                    '#where' => array('t.product_id = ?d' => array($oProduct->getId()))
                ));
                if (isset($aProduct['char'])) {
                    $aChar = $this->Char_GetItemsByArrayId(array_keys($aProduct['char']));
                    foreach ($aProduct['char'] as $iCharId => $mCharValue) {
                        $oChar = $aChar[$iCharId];
                        if (!is_array($mCharValue)) {
                            $oProductChar = Engine::GetEntity('Product_Chars', [
                                'product_id' => $oProduct->getId(),
                                'char_id' => $iCharId,
                                'char_value' => $oChar->getTypeText() == 'number' && trim($mCharValue, "\s\n") == '' ? 0 : trim($mCharValue, "\n")
                            ]);
//                            if ($iCharId == 31)prex($oProductChar);
                            $oProductChar->Add();
                        } else {
                            // множественный выбор
                            foreach ($mCharValue as $sValue) {
                                $oProductChar = Engine::GetEntity('Product_Chars', array('product_id' => $oProduct->getId(), 'char_id' => $iCharId, 'char_value' => trim($sValue, "\n")));
                                $oProductChar->Add();
                            }
                        }
//                        prex($oProductChar);
                    }
                }
                $aPrice = getRequest('prices');
                $oProduct->setPriceMake(min($aPrice));
                /**
                 * Загружаем фото
                 */
                $bRedirect = false;
                if (isset($_FILES['photo']) && count($_FILES['photo'])) {
                    foreach ($_FILES['photo']['error'] as $iK => $iError) {
                        if ($iError == 0) {
                            $mMedia = $this->Media_UploadUrl($_FILES['photo']['tmp_name'][$iK], 'product', $oProduct->getId());
                            if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                                $this->Message_AddError($mMedia . ' : ' . $iK, '', true);
                            }
                        }
                    }
                    $bRedirect = true;
                }
                /**
                 * Загружаем фото 3d
                 */
                if (isset($_FILES['photo-3d']) && count($_FILES['photo-3d'])) {
                    foreach ($_FILES['photo-3d']['error'] as $iK => $iError) {
                        if ($iError == 0) {
                            $mMedia = $this->Media_UploadUrl($_FILES['photo-3d']['tmp_name'][$iK], '3d', $oProduct->getId());
                            if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                                $this->Message_AddError($mMedia . ' : ' . $iK, '', true);
                            }
                            $aInfo = pathinfo($_FILES['photo-3d']['name'][$iK]);
                            $mMedia->setAlt($aInfo['filename']);
                            $mMedia->setSort((int)$aInfo['filename']);
                            $mMedia->Update();
                        }
                    }
                    $bRedirect = true;
                }
                /**
                 * Обновляем цены
                 */
                $this->Product_DeletePricesItemsByFilter(['product_id' => $oProduct->getId()]);
                $aPrice = getRequest('prices');
                $aMargin = getRequest('margin');
                $aDiscount = getRequest('discount');
                foreach ($aPrice as $iMakeGroup => $iPrice) {
                    if ($iPrice > 0) {
                        $oProductPrice = Engine::GetEntity('Product_Prices', [
                            'product_id' => $oProduct->getId(),
                            'make_group' => (int)$iMakeGroup,
                            'price' => (int)$iPrice,
                            'margin' => (float)$aMargin[$iMakeGroup],
                            'discount_date' => (float)$aDiscount[$iMakeGroup]
                        ]);
                        $oDateNow = new DateTime();
                        if ($oProduct->getDiscountDateFrom('Y-m-d') <= $oDateNow->format('Y-m-d') &&
                            $oDateNow->format('Y-m-d') <= $oProduct->getDiscountDateTo('Y-m-d')) {
                            $oProductPrice->setDiscount((float)$aDiscount[$iMakeGroup]);
                        } else {
                            $oProductPrice->setDiscount(0);
                        }
                        $oProductPrice->Save();
                    }
                    if ($iMakeGroup == 1) {
                        // дефолтная маржинальность на случай если не выбраны ткани
                        $oProduct->setMargin((float)$aMargin[$iMakeGroup]);
                    }
                }
                $oProduct->Update();
                $this->Message_AddNotice('Товар успешно обновлен', false, true);
                if ($bRedirect) return Router::Location(ADMIN_URL . 'product/' . $oProduct->getId() . '/');
            } else {
                $this->Viewer_Assign('oProduct', $oProduct);
                $this->Message_AddError($oProduct->_getValidateError(), $this->Lang_Get('error'));
            }
        }
    }

    /**
     * Добавляем новый товар
     */
    public function ProductAdd()
    {
        if (!LS::HasRight('6_product_edit')) return parent::EventForbiddenAccess();
        if (isPost('product_name')) {
            $oProduct = Engine::GetEntity('Product');
            $oProduct->setTitle(getRequestStr('product_name'));
            $oProduct->setCategoryId(getRequestStr('category_id'));
            $oProduct->setUrl($this->Main_GetUrl(getRequestStr('product_name'), 'product'));
            $oProduct->Add();
            $this->Message_AddNoticeSingle('Товар успешно добавлен', false, true);
            return Router::Location(ADMIN_URL . 'product/' . $oProduct->getId() . '/');
        }
    }

    /**
     * Копируем товар
     */
    public function ProductCopy()
    {
        $oProduct = $this->Product_GetById($this->GetParamEventMatch(0, 0));

        if (!$oProduct) return Router::ActionError('', 'Товар не найден');
        $iProductIdNew = $this->Product_Copy($oProduct);
        /**
         * Копируем изображения
         */
        foreach($oProduct->getPhotos() as $oMedia) {
            $oM = $this->Media_UploadUrl($oMedia->getFileServerPath(), 'product', $iProductIdNew);
            $oM->setAlt($oMedia->getAlt());
            $oM->setMain($oMedia->getMain());
            $oM->Update();
        }
        $this->Message_AddNoticeSingle('Товар успешно скопирован', '', true);
        return Router::Location(ADMIN_URL.'product/'.$iProductIdNew.'/');

    }

    /**
     * Удаляем товар
     */
    public function ProductDelete()
    {
        if (!LS::HasRight('6_product_edit')) return parent::EventForbiddenAccess();
        /**
         * Получаем ади товараиз УРЛ и проверяем существует ли он
         */
        $iProductId = $this->GetParamEventMatch(0, 0);
        if (!($oProduct = $this->Product_GetById($iProductId))) {
            return parent::EventNotFound();
        }
        $oProduct->Delete();
        $this->Message_AddNoticeSingle('Товар успешно удален', null, true);
        Router::Location(ADMIN_URL . 'product/category/' . $oProduct->getCategoryId() . '/');
    }

    /**
     * Переадресация на публичную страницу товара
     */
    public function ProductRedirect()
    {
        $iId = $this->GetParamEventMatch(0, 0);
        $oProduct = $this->Product_GetByFilter([
            '#select' => [
                't.*',
                'CONCAT(c.url_full, "/", t.url, "-p", IF(t.id < 1000, LPAD(t.id,4,"0"), t.id)) url_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.category_filter') . ' c ON c.id = t.category_id',
            ],
            '#where' => [
                't.id = ?d' => [$iId]
            ]
        ]);
        return Router::Location($oProduct->getUrlFull());
    }

    /**
     * Обновление главного фото дизайнов
     */
    public function ProductDesignMainPhotoUpdate()
    {
        if (isPost()) {
            $this->Viewer_SetResponseAjax('json');
            $oDesign = $this->Design_GetById((int)getRequest('id'));
            if ($oDesign) {

                $oMediaBok = $this->Media_GetByFilter([
                    'target_id' => $oDesign->getId(),
                    'target_type' => 'design',
                    'alt' => 'Вид по диагонали',
                ]);
                if ($oMediaBok) {
                    $oMediaMain = $this->Media_GetByFilter([
                        'target_id' => $oDesign->getId(),
                        'target_type' => 'design',
                        'main' => 1,
                    ]);
                    $this->Viewer_AssignAjax('text', '---');
                    if ($oMediaMain) {
                        $oMediaMain->setMain(0);
                        $oMediaMain->Update();
                    }
                    if ($oMediaBok) {
                        $oMediaBok->setMain(1);
                        $oMediaBok->Update();
                        $this->Viewer_AssignAjax('text', 'изменено');
                    }
                } else {

                    $this->Viewer_AssignAjax('text', '---');
                }
            }
        } else {
            $this->Viewer_Assign('aDesign', $this->Design_GetAll());
            $this->SetTemplateAction('design.photo.list');
        }
    }

    /**
     * Обновление главного фото товара
     */
    public function ProductMainPhotoUpdate()
    {
        if (isPost()) {
            $this->Viewer_SetResponseAjax('json');
            $oProduct = $this->Product_GetById((int)getRequest('id'));
            if ($oProduct) {

                $oMediaBok = $this->Media_GetByFilter([
                    'target_id' => $oProduct->getId(),
                    'target_type' => 'product',
                    'alt' => 'Вид по диагонали',
                ]);
                if ($oMediaBok) {
                    $oMediaMain = $this->Media_GetByFilter([
                        'target_id' => $oProduct->getId(),
                        'target_type' => 'product',
                        'main' => 1,
                    ]);
                    $this->Viewer_AssignAjax('text', '---');
                    if ($oMediaMain) {
                        $oMediaMain->setMain(0);
                        $oMediaMain->Update();
                    }
                    if ($oMediaBok) {
                        $oMediaBok->setMain(1);
                        $oMediaBok->Update();
                        $this->Viewer_AssignAjax('text', 'изменено');
                    }

                } else {

                    $this->Viewer_AssignAjax('text', '---');
                }
            }
        } else {
            $this->Viewer_Assign('aProduct', $this->Product_GetAll());
            $this->SetTemplateAction('product.photo.list');
        }
    }

    /**
     * Импорт товаров из основной базы
     */
    public function ProductImportData()
    {
        if (isPost()) {
            $this->Viewer_SetResponseAjax('json');
            $oProductLocal = $this->Product_getByExternalId(getRequest('externalId'));
            if (!$oProductLocal) {
                /**
                 * TODO Добавляем товар
                 */
                $this->Message_AddNoticeSingle('Товар не найден по external_id');
            }
            $oXml = simplexml_load_file(getRequestStr('url'));
            $aPrice = [];
            $aGroup = [];
            foreach ($oXml->prices->price as $oPrice) {
                $aPrice[] = [
                    $oProductLocal->getId(),
                    (int)$oPrice['group'],
                    (int)$oPrice[0],
                    2100
                ];
                $aGroup[] = $oPrice['groupName'];
            }
            $this->Product_UpdateProductPriceMakeByArray($aPrice, $oProductLocal->getId());
            $oProductLocal->setExternalDateUpdate((string)$oXml['dateUpdate']);
            $oProductLocal->Update();
            $this->Viewer_Assign('aPrice', $aPrice);
            $this->Viewer_Assign('aGroup', $aGroup);
            $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'product/ajax.product.import.data.result.tpl'));
            $this->Viewer_AssignAjax('dateUpdate', (string)$oXml['dateUpdate']);
            $this->Message_AddNoticeSingle('Успешно обновлено');
        } else {
            $sPublicKey = Config::Get('no-watermark-public-key');
            $oXml = simplexml_load_file('https://sergey-utin.ru/pricelist/product/?public_key=' . $sPublicKey);
            $aImportData = [];
            foreach ($oXml as $oUrl) {
                $aUrl = json_decode(json_encode($oUrl), true);
                $aImportData[$aUrl['@attributes']['id']] = [
                    'date_update' => new DateTime($aUrl['@attributes']['dateUpdate']),
                    'date_new_before' => new DateTime($aUrl['@attributes']['dateNewBefore']),
                    'url' => $aUrl[0],
                    'title_full' => $aUrl['@attributes']['titleFull']
                ];
            }
            $this->Viewer_Assign('aProduct', $this->Product_GetItemsByFilter(['#index-from' => 'external_id']));
            $this->Viewer_Assign('aImportData', $aImportData);
            $this->SetTemplateAction('product.import.data');
        }
    }

    /**
     * Импорт товаров из основной базы
     */
    public function ProductImportDataAddProduct()
    {
        if (isPost()) {
            $this->Viewer_SetResponseAjax('json');
            $oProductLocal = $this->Product_getByExternalId(getRequest('externalId'));
            if (!$oProductLocal) {
                $oXml = simplexml_load_file(getRequestStr('url'));
//                prex($oXml);
//                $oChar = $this->Char_GetById(5);
//                prex($oChar->getValueByRus('Аккордеон'));
                $oDate = new DateTime();
                /**
                 * Товар
                 */
                $oProduct = Engine::GetEntity('Product', [
                    'title' => (string)$oXml->productTitle,
                    'title_full' => (string)$oXml->productTitleFull,
                    'url' => $this->Main_GetUrl((string)$oXml->productTitle, 'product'),
                    'category_id' => (int)$oXml->categoryId,
                    'make_id' => (int)$oXml->brandId,
                    'date_add' => $oDate->format('Y-m-d H:i:s'),
                    'date_update' => $oDate->format('Y-m-d H:i:s'),
                    'external_date_update' => (string)$oXml['dateUpdate'],
                    'external_id' => (int)$oXml->attributes()['id']
                ]);
                /**
                 * Ткани
                 */
                $aFabric = [];
                foreach ($oXml->fabrics->fabric as $oFabric) {
                    $i = (int)$oFabric->attributes()['number'];
                    $aFabric['fabric' . $i] = (float)$oFabric[0];
                    $aFabric['fabric' . $i . '_name'] = (string)$oFabric->attributes()['name'];
                }
                $oProduct->_setData($aFabric);
                $oProduct->Add();
                /**
                 * Хар-ки
                 */
                foreach ($oXml->params->param as $oParam) {
                    $iCharId = (int)$oParam['id'];
                    $sCharType = (string)$oParam['type'];
                    $sCharValue = (string)$oParam[0];
                    if (in_array($sCharType, ['select.one', 'select.multiple'])) {
                        $oChar = $this->Char_GetById($iCharId);
                        $sCharValue = $oChar->getValueByRus($sCharValue);
                    }
                    $oProductChar = $this->Product_GetCharsByFilter([
                        'product_id' => $oProduct->getId(),
                        'char_id' => $iCharId,
                        'char_value' => $sCharValue
                    ]);
                    if (!$oProductChar) {
                        $oProductChar = Engine::GetEntity('Product_Chars', [
                            'product_id' => $oProduct->getId(),
                            'char_id' => $iCharId,
                            'char_value' => $sCharValue
                        ]);
//                        pr([
//                            'car_type' => $sCharType,
//                            'product_id' => $oProduct->getId(),
//                            'char_id' => $iCharId,
//                            'char_value' => $sCharValue
//                        ]);
                        $oProductChar->Add();
                    }
                }
                /**
                 * Цены
                 */
                $aPrice = [];
                $aGroup = [];
                foreach ($oXml->prices->price as $oPrice) {
                    $aPrice[] = [
                        $oProduct->getId(),
                        (int)$oPrice['group'],
                        (int)$oPrice[0],
                    ];
                    $aGroup[] = $oPrice['groupName'];
                }
                $this->Product_UpdateProductPriceMakeByArray($aPrice, $oProduct->getId());
                /**
                 * Изображения
                 */
                foreach ($oXml->pictures->picture as $oPicture) {
                    if ($oPicture->attributes()['width'] > 300) {
                        if ($oMedia = $this->Media_UploadUrl(trim((string)$oPicture[0], " \r\n"), 'product', $oProduct->getId())) {
                            if ($oMedia instanceof ModuleMedia_EntityMedia) {
                                $oMedia->setAlt((string)$oPicture->attributes()['name']);
                                $oMedia->Update();
                            } else {
                                $this->Viewer_AssignAjax('sMediaError', $oMedia);
                            }
                        }
                    }
                }
                $this->Viewer_Assign('aPrice', $aPrice);
                $this->Viewer_Assign('aGroup', $aGroup);
                $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath($this) . 'product/ajax.product.import.data.result.tpl'));
                $this->Viewer_AssignAjax('dateUpdate', (string)$oXml['dateUpdate']);
                $this->Message_AddNoticeSingle('Успешно обновлено');
            } else {
                $this->Message_AddNoticeSingle('Товар с таким external_id уже существует');
            }
        }
    }

    /**
     * Импорт дизайнов из основной базы
     */
    public function DesignImportData()
    {
        if (isPost()) {
            $this->Viewer_SetResponseAjax('json');
            $oDesignLocal = $this->Design_GetByExternalId(getRequest('externalId'));
            if (!$oDesignLocal) {
                return $this->Message_AddErrorSingle('Дизайн не найден');
            } else {
                $oXml = simplexml_load_file(getRequestStr('url'));
                $oDesignLocal->setPrice((int)$oXml->price);
                $oDesignLocal->setExternalDateUpdate((string)$oXml['dateUpdate']);
                $oDesignLocal->Update();
            }
            /**
             * TODO сделать проверку и одновление фото и тканей
             */
            $this->Viewer_AssignAjax('sHtml', 'Успешно');
            $oDate = new DateTime((string)$oXml['dateUpdate']);
            $this->Viewer_AssignAjax('dateUpdate', $oDate->format('d.m.Y H:i'));
            $this->Message_AddNoticeSingle('Успешно обновлено');
        } else {
            $sPublicKey = Config::Get('no-watermark-public-key');
            $oXml = simplexml_load_file('https://sergey-utin.ru/pricelist/design/?public_key=' . $sPublicKey);
            $aImportData = [];
            foreach ($oXml as $oUrl) {
                $aUrl = json_decode(json_encode($oUrl), true);
                $aImportData[$aUrl['@attributes']['id']] = [
                    'date_update' => new DateTime($aUrl['@attributes']['dateUpdate']),
                    'date_new_before' => new DateTime($aUrl['@attributes']['dateNewBefore']),
                    'url' => $aUrl[0],
                    'title_full' => $aUrl['@attributes']['titleFull']
                ];
            }
            $this->Viewer_Assign('aDesign', $this->Design_GetItemsByFilter(['#index-from' => 'external_id']));
            $this->Viewer_Assign('aImportData', $aImportData);
            $this->SetTemplateAction('design.import.data');
        }
    }

    /**
     * Импорт дизайна из основной базы
     */
    public function ProductImportDataAddDesign()
    {
        if (isPost()) {
            $this->Viewer_SetResponseAjax('json');
            $oDesignLocal = $this->Design_GetByExternalId(getRequest('externalId'));
            if (!$oDesignLocal) {
                $oXml = simplexml_load_file(getRequestStr('url'));
                /**
                 * Проверим наличие товара к которому привязан дизайн
                 */
                $oProduct = $this->Product_GetByExternalId((int)$oXml->productId);
                if (!$oProduct) return $this->Message_AddErrorSingle('Товар дизайна не добавлен в базу');
                /**
                 * Проверим наличие тканей
                 */
                $aFabric = [];
                foreach ($oXml->fabrics->fabric as $oFabric) {
                    $i = (int)$oFabric->attributes()['number'];
                    $aFabric['id'][$i] = (float)$oFabric[0];
                    $aFabric['fabric_name'][$i] = (string)$oFabric->attributes()['name'];
                }
                $aFabricArray = $this->Media_GetItemsByArrayExternalId($aFabric['id']);
                if (count($aFabric['id']) != count($aFabricArray)) {
                    return $this->Message_AddErrorSingle('Одна или несколько тканей не найдены. Возможно нужно импортировать ткани');
                }

                /**
                 * Добавим Дизайн
                 */
                $oDate = new DateTime();
                $oDesign = Engine::GetEntity('Design', [
                    'title' => (string)$oXml->designTitle,
                    'title_full' => (string)$oXml->designTitleFull,
                    'url' => $this->Main_GetUrl((string)$oXml->designTitle, 'design'),
                    'product_id' => $oProduct->getId(),
                    'margin' => 4900,
                    'price_make' => (int)$oXml->price,
                    'date_add' => $oDate->format('Y-m-d H:i:s'),
                    'date_update' => $oDate->format('Y-m-d H:i:s'),
                    'date_new_before' => (string)$oXml['dateNewBefore'],
                    'external_date_update' => (string)$oXml['dateUpdate'],
                    'external_id' => (int)$oXml->attributes()['id'],
                    'color' => GetSelectValueByText((string)$oXml->color, 'colors')
                ]);
//                prex($oDesign);
                foreach ($aFabric['id'] as $i => $iId) {
                    $n = $i + 1;
                    $sFunc = "setFabric{$n}Id";
                    $oDesign->$sFunc($iId);
                    $sFunc = "setFabric{$n}Name";
                    $oDesign->$sFunc($aFabric['fabric_name'][$i]);
                }
                $oDesign->Add();
                /**
                 * Изображения
                 */
                foreach ($oXml->pictures->picture as $oPicture) {
                    if ($oPicture->attributes()['width'] > 300) {
                        if ($oMedia = $this->Media_UploadUrl(trim((string)$oPicture[0], " \r\n"), 'design', $oDesign->getId())) {
                            if ($oMedia instanceof ModuleMedia_EntityMedia) {
                                $oMedia->setAlt((string)$oPicture->attributes()['name']);
                                $oMedia->Update();
                            } else {
                                $this->Viewer_AssignAjax('sMediaError', $oMedia);
                            }
                        }
                    }
                }
                $this->Viewer_AssignAjax('sHtml', 'Успешно');
                $this->Viewer_AssignAjax('dateUpdate', (string)$oXml['dateUpdate']);
                $this->Message_AddNoticeSingle('Успешно обновлено');
            } else {
                $this->Message_AddNoticeSingle('Дизайн с таким external_id уже существует');
            }
        }
    }

    public function ProductImportKypitDivan()
    {
        $this->AppendBreadCrumb(30, 'Импорт с kypit-divan');

        $productId = (int) getRequestStr('product_id');
        if ($productId) {
            $product = $this->Product_ImportKypitDivan($productId);
            $this->Viewer_Assign('product', $product);
        }
        $this->SetTemplateAction('import.kypit.divan');
    }
}
