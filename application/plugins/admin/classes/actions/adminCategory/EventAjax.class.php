<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminCategory_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Поиск категории-фильтра
     */
    public function FilterSearch()
    {
        $sSearch = '%'.getRequestStr('search').'%';
        $sSearch1 = '%'.lat2rus($sSearch).'%';
        $sSearch2 = '%'.Translit($sSearch).'%';
        $sSearch3 = '%'.rus2lat($sSearch).'%';
        $aCategoryFilter = $this->Category_GetFilterItemsByFilter([
            '#where' => ["t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ?" => [$sSearch, $sSearch1, $sSearch2, $sSearch3]]
        ]);
        $aRes = [];
        foreach ($aCategoryFilter as $oCF) {
            $aRes[] = array(
                'id' => $oCF->getId(),
                'name' => $oCF->getTitle()
            );
        }
        $this->Viewer_AssignAjax('category_filter', $aRes);
    }

    /**
     * Обновляем значение количества и price_min категории фильтра
     */
    public function FilterUpdate()
    {
        $iCategoryFilterId = (int)getRequest('id');
        $oCategoryFilter = $this->Category_GetFilterById($iCategoryFilterId);
        /**
         * Обновим товары и дизайны в категории фильтре
         */
        $this->Category_UpdateFilterItems($oCategoryFilter->getId());
        $oCategoryFilter = $this->Category_GetFilterById($iCategoryFilterId);
        $this->Viewer_AssignAjax('iCount', $oCategoryFilter->getItemsCount());
        $this->Viewer_AssignAjax('iPriceMin', $oCategoryFilter->getPriceMin());
        $this->Viewer_AssignAjax('iPriceMax', $oCategoryFilter->getPriceMax());
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

}
