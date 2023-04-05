<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminCollection_EventAjax extends Event
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
        if(isPost('alt')) $oMedia->setAlt(getRequestStr('alt'));
        if(isPost('color')) $oMedia->setColor(implode(',', getRequest('color'))); else $oMedia->setColor('');
        if(isPost('main')){
            // получим товар и все его фото и снимем флаг главного
            $oCollection = $this->Collection_GetById((int)getRequest('collection_id'));
            if (!$oCollection) return $this->Message_AddErrorSingle('Коллекция не найдена');
            foreach ($this->Media_GetMediaByTarget('collection', $oCollection->getId()) as $oM) {
                $oM->setMain(0)->Update();
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
        foreach(getRequest('sort') as $iSort => $iMediaId) {
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
     * Поиск коллекции
     */
    public function Search()
    {
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $aFilter = [
            '#select' => ['t.*'],
            '#where' => [
                't.title LIKE ? OR t.title LIKE ? OR t.title LIKE ? OR t.title LIKE ? ' => [
                '%' . $sSearch . '%',
                '%' . $sSearch1 . '%',
                '%' . $sSearch2 . '%',
                '%' . $sSearch3 . '%'
            ]
            ],
            '#limit' => 10,
        ];
        $aCollection = $this->Collection_GetCollectionItemsByFilter($aFilter);
        $aRes = [];
        foreach ($aCollection as $oCollection) {
            $aRes[] = array(
                'id' => $oCollection->getId(),
                'name' => $oCollection->getTitle(),
            );
        }
        $this->Viewer_AssignAjax('collections', $aRes);
    }
}
