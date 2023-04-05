<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminChar_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Сортировка характеристик
     */
    public function Sort()
    {
        $this->Viewer_SetResponseAjax();
        foreach (getRequest('sort') as $iSort => $iCharId) {
            if ($iCharId) {
                $oChar = $this->Char_GetById((int)$iCharId);
                $oChar->setSort($iSort)->Update();
            }
        }
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

    /**
     * Поиск характеристик
     */
    public function Search()
    {
        $sSearch = '%'.getRequestStr('q').'%';
        $sSearch1 = '%'.lat2rus($sSearch).'%';
        $sSearch2 = '%'.Translit($sSearch).'%';
        $sSearch3 = '%'.rus2lat($sSearch).'%';
        $aChar = $this->Char_GetItemsByFilter([
            '#where' => ["t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ?" => [$sSearch, $sSearch1, $sSearch2, $sSearch3]]
        ]);
        $aRes = [];
        foreach ($aChar as $oChar) {
            $aRes[] = array(
                'id' => $oChar->getId(),
                'name' => $oChar->getTitle()
            );
        }
        $this->Viewer_AssignAjax('chars', $aRes);
    }

    /**
     * HTML-код характеристики для динамической вставки на форму
     */
    public function GetHtml()
    {
        $oChar = $this->Char_GetById((int) getRequest('id'));
        if (!$oChar) return $this->Message_AddErrorSingle('Характеристика не найдена');
        $this->Viewer_Assign('oChar', $oChar);
        $this->Viewer_AssignAjax('sType', $oChar->getTypeText());
        $this->Viewer_AssignAjax('iId', $oChar->getId());
        $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__).'category.filter/char.type.'.$oChar->getTypeText().'.tpl'));
    }
}
