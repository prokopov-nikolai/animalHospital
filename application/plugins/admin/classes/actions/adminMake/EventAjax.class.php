<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminMake_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Изменяем группу ткани для производителя
     */
    public function CollectionChange()
    {
        $aMC = [
            'make_id' => (int)getRequest('make_id'),
            'collection_id' => (int)getRequest('collection_id')
        ];
        $oMC = $this->Make_GetCollectionsByFilter($aMC);
        if ($oMC) $oMC->Delete();
        $aMC['make_group'] = (int)getRequest('make_group');
        if ($aMC['make_group'] == -1) {
            $this->Message_AddErrorSingle('Внимание', 'Кол-ция не будет выводиться');
        } else {
            $oMC = Engine::GetEntity('Make_Collections', $aMC);
            $oMC->Save();
            /**
             * Пересчитаем все дизайны которые в этих тканях
             */
            $aFabric = $this->Media_GetItemsByFilter([
                'target_type' => 'collection',
                'target_id' => $oMC->getCollectionId()
            ]);
            foreach ($aFabric as $oFabric) {
                // дизайны выбранного производителя в тканях этой коллекции
                $aDesign = $this->Design_GetItemsByFilter([
                    '#join' => [
                        'INNER JOIN '.Config::Get('db.table.product').' p ON p.id = t.product_id AND p.make_id = '.$oMC->getMakeId()
                    ],
                    '#where' => [
                        't.fabric1_id = ? OR t.fabric2_id = ? OR t.fabric3_id = ? OR t.fabric4_id = ?' =>
                        [$oFabric->getId(), $oFabric->getId(), $oFabric->getId(), $oFabric->getId(),]
                    ]
                ]);
                foreach ($aDesign as $oDesign) {
                    $oDesign->setMakeId($aMC['make_id']);
                    $oDesign->RecalcPriceMake();
                    $oDesign->Update();
                }
            }
            $this->Message_AddNoticeSingle('Внимание', 'Успешно обновлено');
        }
    }
}
