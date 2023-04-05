<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminProduct_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Обновляем медиа
     */
    public function MediaUpdate()
    {
        $oMedia = $this->Media_GetMediaById((int)getRequest('id'));
        if (isPost('alt')) $oMedia->setAlt(getRequestStr('alt'));
        if (isPost('main')) {
            // получим товар и все его фото и снимем флаг главного
            if (isPost('product_id')) {
                $oProduct = $this->Product_GetById((int)getRequest('product_id'));
                if (!$oProduct) return $this->Message_AddErrorSingle('Продукт не найден');
                foreach ($this->Media_GetMediaByTarget('product', $oProduct->getId()) as $oM) {
                    $oM->setMain(0)->Update();
                }
            } elseif (isPost('design_id')) {
                $oDesign = $this->Design_GetById((int)getRequest('design_id'));
                if (!$oDesign) return $this->Message_AddErrorSingle('Дизайн не найден');
                foreach ($this->Media_GetMediaByTarget('design', $oDesign->getId()) as $oM) {
                    $oM->setMain(0)->Update();
                }
            }

            $oMedia->setMain(1);
        }
        $oMedia->Update();
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

    /**
     * Обновляем медиа
     */
    public function MediaSort()
    {
        foreach (getRequest('sort') as $iSort => $iMediaId) {
            $oMedia = $this->Media_GetMediaById((int)$iMediaId);
            $oMedia->setSort($iSort)->Update();
        }
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

    /**
     * Удаляем фото
     */
    public function MediaRemove()
    {
        $oMedia = $this->Media_GetMediaById((int)getRequest('id'));
        $oMedia->Delete();
        $this->Message_AddNoticeSingle('Фото успешно удалено');
    }

    /**
     * Поиск товара
     */
    public function Search()
    {
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $iMakeId = (int)getRequest('make_id');
        $aFilter = [
            '#select' => ['t.*, c.product_prefix', 'm.title make_title'],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.category_filter') . ' c ON c.id = t.category_id',
                'INNER JOIN ' . Config::Get('db.table.make') . ' m ON m.id = t.make_id'
            ],
            '#where' => [
                '(t.title_full LIKE ? OR 
                t.title_full LIKE ? OR 
                t.title_full LIKE ? OR 
                t.title_full LIKE ? OR 
                t.title LIKE ? OR 
                t.title LIKE ? OR 
                t.title LIKE ? OR 
                t.title LIKE ? OR 
                t.id = ?d)
                {AND t.make_id = ?d}' => [
                    '%'.$sSearch.'%',
                    '%'.$sSearch1.'%',
                    '%'.$sSearch2.'%',
                    '%'.$sSearch3.'%',
                    '%'.$sSearch.'%',
                    '%'.$sSearch1.'%',
                    '%'.$sSearch2.'%',
                    '%'.$sSearch3.'%',
                    $sSearch,
                    $iMakeId ? $iMakeId : DBSIMPLE_SKIP
                ]
            ],
            '#limit' => 10,
        ];
        $aProduct = $this->Product_GetProductItemsByFilter($aFilter);
        $aRes = [];
        foreach ($aProduct as $oProduct) {
            $oMedia = $oProduct->getMediaItems(0);
            $aRes[] = array(
                'id' => $oProduct->getId(),
                'name' => $oProduct->getTitleFull(),
                'image' => $oProduct->getMainPhotoPath('250x')
            );
        }
        $this->Viewer_AssignAjax('products', $aRes);
    }

    /**
     * Поиск Дизайна
     */
    public function DesignSearch()
    {
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $aFilter = [
            '#select' => [
                't.*',
                'p.title product_title, p.price_make product_price_make',
                'c.product_prefix'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id',
                'INNER JOIN ' . Config::Get('db.table.category_filter') . ' c ON c.id = p.category_id'
            ],
            '#where' => [
                't.title_full LIKE ? OR t.title_full LIKE ? OR t.title_full LIKE ? OR t.title_full LIKE ?' => [
                    '%' . $sSearch . '%',
                    '%' . $sSearch1 . '%',
                    '%' . $sSearch2 . '%',
                    '%' . $sSearch3 . '%'
                ]
            ],
            '#order' => ['title_full'],
            '#limit' => 10,
        ];
        $aDesign = $this->Design_GetItemsByFilter($aFilter);
        $aRes = [];
        foreach ($aDesign as $oDesign) {
            $aRes[] = array(
                'id' => $oDesign->getId(),
                'name' => $oDesign->getTitleFull(),
                'image' => $oDesign->getMainPhotoPath('105x')
            );
        }
        $this->Viewer_AssignAjax('designs', $aRes);
    }


    ////////////////////////////////////////////////////////////////////////


    public function ProductPriceUpdate()
    {
        $oProduct = $this->Product_GetById((int)getRequest('id'));
        $oProduct->_setData(getRequest('product'));
        $oProduct->Save();
        $this->Viewer_AssignAjax('price_min', $oProduct->getPriceMin(true, true));
        $this->Viewer_AssignAjax('price_purchase', $oProduct->getPricePurchase(true, true));
        $this->Viewer_AssignAjax('price_profit', $oProduct->getPriceProfit(true, true));
        $this->Viewer_AssignAjax('discount', $oProduct->getDiscount(true, true));
    }


    public function SimilarDelete()
    {
        $iProductId = (int)getRequest('iProductId');
        $iProductSimilarId = (int)getRequest('iProductSimilarId');
        $this->Product_DeleteSimilarsItemsByFilter(array(
            '#where' => array('t.product_id = ?d AND t.product_similar_id = ?d' => array($iProductId, $iProductSimilarId))
        ));
        $sKey = 'similar_' . (int)$iProductId;
        $this->Cache_Delete($sKey);
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('similar_delete'));
    }

    public function SimilarAdd()
    {
        $iProductId = (int)getRequest('iProductId');
        $iProductSimilarId = (int)getRequest('iProductSimilarId');
        $oProductSimilar = Engine::GetEntity('Product_Similars', array(
            'product_id' => $iProductId,
            'product_similar_id' => $iProductSimilarId,
            'anchor' => getRequestStr('sAnchor')
        ));
        $oProductSimilar->Add();
        $sKey = 'similar_' . (int)$iProductId;
        $this->Cache_Delete($sKey);
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('similar_add'));
    }

    public function SimilarUpdate()
    {
        $iProductId = (int)getRequest('iProductId');
        $iProductSimilarId = (int)getRequest('iProductSimilarId');
        $oProductSimilar = $this->Product_GetSimilarsByFilter(array(
            '#where' => array('t.product_id = ?d AND t.product_similar_id = ?d' => array($iProductId, $iProductSimilarId)),
            '#limit' => 1
        ));
        if ($oProductSimilar) {
            $oProductSimilar->setAnchor(getRequestStr('sAnchor'));
            $oProductSimilar->setGroupName(getRequestStr('sGroupName'));
            $oProductSimilar->Update();
        }
        $sKey = 'similar_' . (int)$iProductId;
        $this->Cache_Delete($sKey);
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('similar_update'));
    }

    public function DesignDelete()
    {
        $oProductDesign = $this->Product_GetDesignsById((int)getRequest('iDesignId'));
        $sKey = 'design_' . (int)$oProductDesign->getProductId();
        $oProductDesign->Delete();
        $this->Cache_Delete($sKey);
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('design_delete'));
    }

    public function DesignPriceUpdate()
    {
        $oProductDesign = $this->Product_GetDesignsById((int)getRequest('iDesignId'));
        $oProductDesign->setPriceAction((int)getRequest('iPrice'));
        $oProductDesign->Update();
        $sKey = 'design_' . (int)$oProductDesign->getProductId();
        $this->Cache_Delete($sKey);
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('design_update'));
    }

    public function DesignAdd()
    {
        $iProductId = (int)getRequest('id');
        $oProduct = $this->Product_GetById($iProductId);
        if (!$oProduct) return $this->Message_AddErrorSingle('Товар с таким id не найден');
        $oDesign = Engine::GetEntity('Design');
        $oDesign->setProductId($iProductId);
        $oDesign->Save();
        $this->Viewer_AssignAjax('design_id', $oDesign->getId());
    }

    /**
     * Парсим изображения по урлу
     */
    public function UploadImagesFromSite()
    {
        ini_set('max_execution_time', 300);
        $sUrl = getRequestStr('url');
        $aUrl = parse_url($sUrl);
        $sSite = $aUrl['scheme']."://".$aUrl['host'];
        $sContent = file_get_contents(str_replace('&amp;', '&', getRequestStr('url')));
        preg_match_all('#(href|src|data-zoom-image)="(([^"]+)\.(jpg|png|jpeg))#ms', $sContent, $aM, PREG_SET_ORDER);
        $aImage = [];
        if (count($aM) > 0) {
            foreach ($aM as $aD) {
                if(strpos($aD[2], 'http') !== false || strpos($aD[2], 'https') !== false) {
                    $aInfo = getimagesize($aD[2]);
                    if (is_array($aInfo) && $aInfo[0] > 520) {
                        $aImage[] = [
                            'src' => $aD[2],
                            'size' => $aInfo
                        ];
                    }
                } else {
                    $sImgUrl = $sSite.'/'.trim($aD[2], '/');
                    $aInfo = @getimagesize($sImgUrl);
                    if (is_array($aInfo) && $aInfo[0] > 520) {
                        $aImage[] = [
                            'src' => $sImgUrl,
                            'size' => $aInfo
                        ];
                    }
//                    pr($sImgUrl);
//                    pr($aInfo);
                }
            }
            $this->Viewer_Assign('aImage', $aImage);
        }
        if (count($aImage) == 0) {
            $this->Message_AddErrorSingle('Картинки с шириной больше 600px на указаной странице не найдены');
        } else {
            $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__) . 'actions/ActionAdminProduct/ajax.parsed.images.tpl'));
        }
    }

    /**
     * Загрузка изображений по их урл
     */
    public function UploadImagesByUrl()
    {
        $oProduct = $this->Product_GetById((int)getRequest('product_id'));
        if (!$oProduct) $this->Message_AddErrorSingle('Товар не найден');
        $aImage = getRequest('images');
        if (!is_array($aImage) || count($aImage) == 0) {
            $this->Message_AddErrorSingle('Не передан массив изображений');
        } else {
            foreach ($aImage as $sImgUrl) {
                $mMedia = $this->Media_UploadUrl($sImgUrl, 'product', $oProduct->getId());
                if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                    $this->Message_AddError($sImgUrl . ' : ' . $mMedia, '');
                }
            }
        }
    }

    /**
     * Добавление товара в группу
     */
    public function ProductGroupAdd()
    {
        $iProductId = (int)getRequest('product_id');
        $sItemType = getRequestStr('type');
        $iItemId = (int)getRequest('id');

        $sFunction = func_camelize($sItemType).'_GetById';
        $oPD = $this->$sFunction($iItemId);
        $oItem = Engine::GetEntity('Product_Groups', [
            'product_id' => $iProductId,
            'similar_'.$sItemType.'_id' => $iItemId,
            'item_name' => $oPD->getTitleFull()
        ]);
        $oItem->Save();
        $this->Viewer_Assign('oItem', $oItem);
        $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__) . 'product/ajax.groups.item.tpl'));
    }

    /**
     * Обновление информации о товаре в группе
     */
    public function ProductGroupUpdate()
    {
        $oItem = $this->Product_GetGroupsById((int)getRequest('id'));
        if (!$oItem) return $this->Message_AddErrorSingle('Позиция не найдена');
        $sFunction = func_camelize('set_'.getRequestStr('field'));
        $oItem->$sFunction(getRequestStr('value'));
        $oItem->Update();
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

    /**
     * Удаление товара из группы
     */
    public function ProductGroupRemove()
    {
        $oItem = $this->Product_GetGroupsById((int)getRequest('id'));
        if (!$oItem) return $this->Message_AddErrorSingle('Позиция не найдена');
        $oItem->Delete();
        $this->Message_AddNoticeSingle('Успешно удалено');
    }
}
