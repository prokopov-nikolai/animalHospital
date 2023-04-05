<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminPets_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Поиск пользователя
     */
    public function Search()
    {
        $search = getRequestStr('search');
        $phone = preg_replace('/[^0-9]+/m', '', $search);

        if (substr($phone, 0, 1) == 8) {
            $phone = '7'.substr($phone, 1);
        }

        $aFilter = [
            '#select' => [
                't.*',
                'u.fio user_fio, u.phone user_phone'
            ],
            '#join' => [
                'LEFT JOIN '.Config::Get('db.table.prefix').'user u ON u.id = t.user_id'
            ],
            '#where' => [
                't.nickname LIKE ? OR u.fio LIKE ?{ OR t.phone LIKE ?}' => [
                    '%' . $search . '%',
                    '%' . $search . '%',
                    $phone ? '%' . $phone . '%' : DBSIMPLE_SKIP,
                ]
            ],
            '#cache' => '',
            '#limit' => 10,
        ];
        $aPets = $this->Pet_GetItemsByFilter($aFilter);
        $aRes = [];
        if (count($aPets) > 0) {
            foreach ($aPets as $oPet) {
                $aRes[] = [
                    'id' => $oPet->getId(),
                    'nickname' => $oPet->getNickname(),
                    'species' => GetSelectText($oPet->getSpecies(), 'pets_species_items'),
                    'user_fio' => $oPet->getUserFio(),
                    'user_phone' => $oPet->getUserPhone(),
                ];
            }
        }
        $this->Viewer_AssignAjax('pets', $aRes);
    }
}
