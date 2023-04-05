<?php

class PluginAdmin_ActionAdminCategory extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->SetDefaultEvent('filter');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {

//        $this->AddEventPreg('/list/i', 'CategoryList');
//        $this->AddEventPreg('/^([0-9]+)$/i', 'CategoryEdit');
//        $this->AddEvent('add', 'CategoryAdd');
//        $this->AddEventPreg('/^delete$/', '/^([0-9]+)$/i', 'CategoryDelete');
        $this->AddEventPreg('/^filter?$/i', '/^add?$/i', 'CategoryFilterAdd');
        $this->AddEventPreg('/^filter?$/i', '/^delete$/', '/^([0-9]+)$/i', 'CategoryFilterDelete');
        $this->AddEventPreg('/^filter?$/i', '/^redirect$/', '/^([0-9]+)$/i', 'CategoryFilterRedirect');
        $this->AddEventPreg('/^filter?$/i', '/^([0-9]+)$/i', 'CategoryFilterEdit');
        $this->AddEventPreg('/^filter?$/i', 'CategoryFilterList');

        /**
         * Для ajax регистрируем внешний обработчик
         */
        $this->RegisterEventExternal('AjaxCategory', 'PluginAdmin_ActionAdminCategory_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^filter$/i', '/^search$/i', 'AjaxCategory::FilterSearch');
        $this->AddEventPreg('/^ajax$/i', '/^filter$/i', '/^update$/i', 'AjaxCategory::FilterUpdate');
    }
    /**
     * ИСКЛЮЧАЕМ сущность категории
     * @return string
     */

//    /**
//     * Список категорий / Категория товаров
//     */
//    public function CategoryList()
//    {
//        if (!LS::HasRight('11_category')) return parent::EventForbiddenAccess();
//        $this->AppendBreadCrumb(10, 'Категории', 'category');
////        $aCategoryTree = $this->Category_GetTree(0);
//        $this->Viewer_Assign('aCategoryTree', $this->Category_GetItemsByFilter([
//            '#order' => ['title' => 'asc']
//        ]));
//        $this->SetTemplateAction('category.list');
//    }
//
//    /**
//     * Редактирование категории
//     */
//    public function CategoryEdit()
//    {
//        if (!LS::HasRight('12_category_change')) return parent::EventForbiddenAccess();
//        $this->AppendBreadCrumb(10, 'Категории', 'category');
//        /**
//         * Добавление / обновление
//         */
//        $this->SubmitCategory();
//        /**
//         * Вывод
//         */
//        $iCategoryId = (int)Router::GetActionEvent(0);
//        $oCategory = $this->Category_GetById($iCategoryId);
//        if (!$oCategory) {
//            return parent::EventNotFound();
//        }
//            $this->AppendBreadCrumb(50, $oCategory->getTitle(), 'category/edit' . $oCategory->getId());
//        $aChar = $this->Char_GetItemsByFilter(['#order' => ['sort' => 'asc']]);
//        $this->Viewer_Assign('oCategory', $oCategory);
//        $this->Viewer_Assign('aChar', $aChar);
//        $this->SetTemplateAction('category.edit');
//    }
//
//    /**
//     * Обработка добавления категории
//     */
//    private function SubmitCategory()
//    {
//        if ($aCategory = getRequest('category', null, 'post')) {
//            /**
//             * Чистим Кеш
//             */
//            $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('tree', 'add_category', 'update_category'));
//            $oCategory = Engine::GetEntity('Category');
//            $oCategory->_setData($aCategory);
//            if ($oCategory->_Validate()) {
//                if (!$oCategory->getId()) {
//                    $oCategory = $oCategory->Add();
//                    return Router::Location(ADMIN_URL.'category/edit/' . $oCategory->getId() . '/');
//                }
//                /**
//                 * Добавляем характеристики
//                 */
//                $oCategoryOld = $this->Category_GetById($oCategory->getId());
//                $oCategoryOld->chars->Clear();
//                $oCategoryOld->Save();
//                if (isset($aCategory['char'])) {
//                    foreach ($aCategory['char'] as $iCharId) {
//                        $oCategoryChars = Engine::GetEntity('Category_Chars', array('category_id' => $oCategory->getId(), 'char_id' => $iCharId));
//                        $oCategoryChars->Add();
//                    }
//                }
//                if (!$oCategory->getUrl() || getRequest('update_url')) {
//                    $oCategory->setUrl($this->Main_GetUrl($oCategory->getTitle(), 'category'));
//                }
//                $oCategory->Update();
//                $this->Cache_Clean(Zend_Cache::CLEANING_MODE_ALL);
//                $this->Message_AddNotice('Успешно обновлена', 'Категория');
//            } else {
//                $this->Viewer_Assign('oCategoryCurrent', $oCategory);
//                $this->Message_AddError($oCategory->_getValidateError(), $this->Lang_Get('error'));
//            }
//        }
//    }

    public function CategoryFilterList()
    {
        if (!LS::HasRight('13_category_filter')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(20, 'Категории');
        if (isset($_GET['search'])) {
            $sSearch = '%' . getRequestStr('search') . '%';
            $sSearch1 = '%' . lat2rus($sSearch) . '%';
            $sSearch2 = '%' . Translit($sSearch) . '%';
            $sSearch3 = '%' . rus2lat($sSearch) . '%';
            $aCategoryFilter = $this->Category_GetFilterItemsByFilter([
                '#where' => ["t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ?" => [$sSearch, $sSearch1, $sSearch2, $sSearch3]]
            ]);
            $aCategoryFilterSelect = [];
            foreach ($aCategoryFilter as $oCF) {
                $aCategoryFilterSelect[] = array(
                    'value' => $oCF->getId(),
                    'base' => $oCF->getBase(),
                    'text' => $oCF->getAlias(),
                    'product_prefix' => $oCF->getProductPrefix(),
                    'group_by' => '',
                    'count' => $oCF->getItemsCount(),
                    'url_full' => $oCF->getUrlFull(),
                    'in_menu' => $oCF->getInMenu(),
                    'price_min' => $oCF->getPriceMin(),
                    'price_max' => $oCF->getPriceMax(),
                    'level' => 0
                );
            }
        } else {
            $aCategoryFilterSelect = $this->Category_GetFilterTreeForSelect();
        }
        $this->Viewer_Assign('aCategoryFilterSelect', $aCategoryFilterSelect);
        $this->SetTemplateAction('filter.list');
    }

    public function CategoryFilterAdd()
    {
        if (!LS::HasRight('13_category_filter')) return parent::EventForbiddenAccess();
        $oCategoryFilter = Engine::GetEntity('Category_Filter', ['title' => 'title']);
        $oCategoryFilter->Add();
        $oCategoryFilter->setTitle('Новая категория фильтр #'.$oCategoryFilter->getId());
        $sUrl = $this->Main_GetUrl(translit($oCategoryFilter->getTitle()), 'category_filter');
        $oCategoryFilter->setUrl($sUrl);
        $oCategoryFilter->setUrlFull($sUrl);
        $oCategoryFilter->Update();
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, ['update_category_filter', 'category_filter', 'update_category', 'category_filter_tree', 'tree']);
        return Router::Location(ADMIN_URL.'category/filter/' . $oCategoryFilter->getId() . '/');
    }

    public function CategoryFilterEdit()
    {
        if (!LS::HasRight('13_category_filter')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(20, 'Категории фильтры', 'category/filter');
        $iCategoryFilterId = $this->GetParamEventMatch( 0, 0);
        $oCategoryFilter = $this->Category_GetFilterById($iCategoryFilterId);
        $this->AppendBreadCrumb(30, $oCategoryFilter->getTitle());
        if (isPost()) {
            $aCategoryFilter = getRequest('category_filter');
            $aCategoryFilter['in_menu'] = isset($aCategoryFilter['in_menu']) ? $aCategoryFilter['in_menu'] : 0;
            $aCategoryFilter['novinki'] = isset($aCategoryFilter['novinki']) ? $aCategoryFilter['novinki'] : 0;
            $aCategoryFilter['popular'] = isset($aCategoryFilter['popular']) ? $aCategoryFilter['popular'] : 0;
            $aCategoryFilter['sale']    = isset($aCategoryFilter['sale'])    ? $aCategoryFilter['sale'] : 0;
            $aCategoryFilter['base']    = isset($aCategoryFilter['base'])    ? $aCategoryFilter['base'] : 0;
            if ($aCategoryFilter['parent_id'] == $oCategoryFilter->getId()) {
                $this->Message_AddErrorSingle('Нельзя поместить категорию внутрь самой себя', false, true);
                return Router::Location($_SERVER['REQUEST_URI']);
            }
            if (!isset($aCategoryFilter['url']) || !$aCategoryFilter['url']) {
                $aCategoryFilter['url'] = $this->Main_GetUrl(translit($aCategoryFilter['title']), 'category_filter');
            }
            if (!isset($aCategoryFilter['make'])) {
                $aCategoryFilter['make'] = NULL;
            } else {
                $aCategoryFilter['make'] = json_encode($aCategoryFilter['make']);
            }
            if (!isset($aCategoryFilter['color'])) {
                $aCategoryFilter['color'] = NULL;
            } else {
                $aCategoryFilter['color'] = json_encode($aCategoryFilter['color']);
            }
            if (!isset($aCategoryFilter['chars'])) {
                $aCategoryFilter['chars'] = NULL;
            } else {
                $aCategoryFilter['chars'] = json_encode($aCategoryFilter['chars']);
            }
            if ($oC = $this->Category_GetByUrl($aCategoryFilter['url'])){
                $this->Message_AddErrorSingle('С таким урл уже есть категория. Фильтр не будет доступен');
            }

//            if ($aCategoryFilter['base']) {
//                $aCategoryFilter['category'] = json_encode([$iCategoryFilterId]);
//            }
            $oCF = $oCategoryFilter;
            $oCategoryFilter->_setData($aCategoryFilter);
            $sUrlFull = $oCategoryFilter->getUrl();
            while($oCF->getParentId()) {
                $oCF = $this->Category_GetFilterById($oCF->getParentId());
                $sUrlFull = $oCF->getUrl().'/'.$sUrlFull;
            }
            $oCategoryFilter->setUrlFull($sUrlFull);
            $oCategoryFilter->Update();
            /**
             * Обновим товары и дизайны в категории фильтре
             */
            $this->Category_UpdateFilterItems($oCategoryFilter->getId());
            /**
             * Добавляем характеристики
             */
            $oCategoryOld = $this->Category_GetFilterById($oCategoryFilter->getId());
            $oCategoryOld->params->clear();
            $oCategoryOld->Save();
            if (isset($aCategoryFilter['param'])) {
                foreach ($aCategoryFilter['param'] as $iCharId) {
                    $oCategoryChars = Engine::GetEntity('Category_Chars', ['category_id' => $oCategoryFilter->getId(), 'char_id' => $iCharId]);
                    $oCategoryChars->Add();
                }
            }
            /**
             * Добавляем опции, которые будут выводится при заполнении товара по дефолту
             */
            $oCategoryOld = $this->Category_GetFilterById($oCategoryFilter->getId());
            $oCategoryOld->options->clear();
            $oCategoryOld->Save();
            if (isset($aCategoryFilter['option'])) {
                foreach ($aCategoryFilter['option'] as $iOptionId) {
                    $oCategoryFilterOptions = Engine::GetEntity('Category_FilterOptions', ['category_filter_id' => $oCategoryFilter->getId(), 'option_id' => $iOptionId]);
                    $oCategoryFilterOptions->Add();
                }
            }

            if (!$oCategoryFilter->getUrl()) $this->Message_AddErrorSingle('Урл не может быть пустым!!!');
            $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, ['update_category_filter', 'category_filter', 'update_category', 'category_filter_tree', 'tree']);
            $this->Message_AddNoticeSingle('Внимание', 'Успешно обновлено', true);
            return Router::Location($_SERVER['REQUEST_URI']);
        }
        $oCategoryFilter = $this->Category_GetFilterById($iCategoryFilterId);
        $aChar = $this->Char_GetItemsByFilter(['#order' => ['sort' => 'asc']]);
        $this->Viewer_Assign('aChar', $aChar);
        $this->Viewer_Assign('oCategoryFilter', $oCategoryFilter);
        $this->Viewer_Assign('aCategoryFilterSelect', $this->Category_GetFilterTreeForSelect());
        $this->Viewer_Assign('aCategoryFilter', $this->Category_GetFilterItemsByFilter(['#index-from' => 'id']));
        $this->Viewer_Assign('aCategorySelect', $this->Category_GetListForSelect());
        $this->Viewer_Assign('aMakeSelect', $this->Make_GetListForSelect());
        $this->Viewer_Assign('aOption', $this->Option_GetAll());
        $this->SetTemplateAction('filter.edit');
//        prex($this->Category_GetFilterTreeForSelect());
    }

    public function CategoryFilterDelete()
    {
        if (!LS::HasRight('13_category_filter')) return parent::EventForbiddenAccess();
        $iId = $this->GetParamEventMatch( 1, 0);
        $oCategoryFilter = $this->Category_GetFilterById($iId);
        if (!$oCategoryFilter) return parent::EventNotFound();
        $oCategoryFilter->Delete();
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, ['update_category_filter', 'category_filter', 'update_category', 'category_filter_tree', 'tree']);
        $this->Message_AddErrorSingle('Успешно удалено', false, true);
        return Router::Location(ADMIN_URL.'category/filter/');
    }

    public function CategoryFilterRedirect()
    {
        $iId = $this->GetParamEventMatch( 1, 0);
        $oCategoryFilter = $this->Category_GetFilterById($iId);
        return Router::Location($oCategoryFilter->getUrlFull());
    }

    public function CategoryAdd()
    {
        if (!LS::HasRight('12_category_change')) return parent::EventForbiddenAccess();
        $oCategory = Engine::GetEntity('Category', ['title' => 'title']);
        $oCategory->Add();
        $oCategory->setTitle('Новая категория #'.$oCategory->getId());
        $sUrl = $this->Main_GetUrl(translit($oCategory->getTitle()), 'category');
        $oCategory->setUrl($sUrl);
        $oCategory->setUrlFull($sUrl);
        $oCategory->Update();
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('tree', 'add_category', 'update_category'));
        return Router::Location(ADMIN_URL.'category/' . $oCategory->getId() . '/');
    }

    public function CategoryDelete()
    {
        if (!LS::HasRight('34_category_delete')) return parent::EventForbiddenAccess();
        $iCategiryId = (int)Router::GetParam(0);
        $oCategory = $this->Category_GetCategoryById($iCategiryId);
        $this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('tree', 'add_category', 'update_category'));
        if ($oCategory->Delete()) {
            $this->Message_AddNoticeSingle('Успешно удалена', 'Категория', true);
        } else {
            $this->Message_AddErrorSingle('Категория не удалена', 'Ошибка', true);
        }
        return Router::Location(ADMIN_URL . '/category/');
    }
}
