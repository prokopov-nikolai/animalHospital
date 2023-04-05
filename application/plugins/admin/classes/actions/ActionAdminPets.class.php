<?php

class PluginAdmin_ActionAdminPets extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.pets'), 'pets');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        /**
         * Покупатели
         */
        $this->AddEventPreg('/^(page([\d]+))?$/i', 'PetsList');
        $this->AddEventPreg('/^([\d]+)$/i', 'PetEdit');
        $this->AddEventPreg('/^add$/i', 'PetAdd');
        $this->AddEventPreg('/^remove$/i','/^([\d]+)$/i', 'PetRemove');
        /**
         * ajax
         */
        $this->RegisterEventExternal('AjaxPet', 'PluginAdmin_ActionAdminPets_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^search$/i', 'AjaxPet::Search');
    }

    /**
     * Список покупателей
     */
    public function PetsList()
    {
        if (!LS::HasRight('4_pets')) return parent::EventForbiddenAccess();
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $iPage = $this->GetEventMatch(2, 0);
        $iPage = (!$iPage ? 1 : $iPage);
        $aResult = $this->Pet_GetPetItemsByFilter(array(
            '#select' => [
                't.*',
                'u.fio user_fio, u.phone user_phone'
            ],
            '#join' => [
                'LEFT JOIN '.Config::Get('db.table.prefix').'user u ON u.id = t.user_id'
            ],
            '#where' => [
                '1=1 {AND ((t.nickname LIKE ?} 
                            { OR t.nickname LIKE ?}
                            { OR t.nickname LIKE ?}
                            { OR t.nickname LIKE ?
                           )
                        OR (u.fio LIKE ?} 
                            { OR u.fio LIKE ?}
                            { OR u.fio LIKE ?}
                            { OR u.fio LIKE ?
                           )
                        OR (u.phone LIKE ?} 
                            { OR u.phone LIKE ?}
                            { OR u.phone LIKE ?}
                            { OR u.phone LIKE ?
                           ))}
                           ' => [
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP,
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP,
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP,
                ]
            ],
            '#sort' => array('id' => 'desc'),
            '#page' => array($iPage, Config::Get('module.pets.per_page'))
        ));
        $this->Viewer_Assign('aPets', $aResult['collection']);
        $aPaging = $this->Viewer_MakePaging($aResult['count'], $iPage, Config::Get('module.pets.per_page'), Config::Get('pagination.pages.count'), ADMIN_URL . 'pets/');
        $this->Viewer_Assign('paging', $aPaging);
        $this->SetTemplateAction('pets.list');
    }

    /**
     * Выводим данные по пользователю
     */
    public function PetEdit()
    {
        if (!LS::HasRight('5_pets_edit')) return parent::EventForbiddenAccess();
        $oPet = $this->Pet_GetByFilter([
            '#select' => [
                't.*',
                'u.id user_id, u.fio user_fio'
            ],
            '#join' => [
                'LEFT JOIN '.Config::Get('db.table.prefix').'user u ON u.id = t.user_id'
            ],
            '#where' => ['t.id = ?d' => [$this->GetParamEventMatch(0)]]
        ]);
        $this->PetSubmit($oPet);
        $this->AppendBreadCrumb(20, $oPet->getNickname());
        $this->Viewer_Assign('oPet', $oPet);
        $this->Viewer_Assign('aPetsSpeciesItems', Config::Get('pets_species_items'));
        $this->SetTemplateAction('pet.edit');
    }

    public function PetAdd()
    {
        if (isPost()) {
            $oPet = Engine::GetEntity('Pet', getRequest('pet'));
            $oPet->_setValidateScenario('registration');
            if ($oPet->_Validate()) {
                $oPet->Add();
                if (isset($_FILES['pet_photo']) && $_FILES['pet_photo']['error'] == 0) {
                    $this->Media_UploadLocal($_FILES['pet_photo'], 'pet_photo', $oPet->getId());
                }
                Router::Location(ADMIN_URL.'pets/'.$oPet->getId().'/');
            } else {
                foreach ($oPet->_getValidateErrors() as $aFieldErrors) {
                    foreach ($aFieldErrors as $sError) {
                        $this->Message_AddError($sError);
                    }
                }
            }
        } else {
            $oPet = Engine::GetEntity('Pet');
        }
        $this->Viewer_Assign('aPetsSpeciesItems', Config::Get('pets_species_items'));
        $this->Viewer_Assign('oPet', $oPet);
        $this->SetTemplateAction('pet.add');
    }

    public function PetRemove()
    {
        $iUserId = $this->GetParamEventMatch(0,1);
        $oPet = $this->User_GetById($iUserId);
        if (!$oPet) return parent::EventNotFound();
        $oPet->Delete();
        $this->Message_AddNotice('Пользоваль успешно удален', false, true);
        return Router::Location(ADMIN_URL.'users/');
    }

    private function PetSubmit(&$oPet)
    {
        if (isPost()) {
            $aPet = getRequest('pet');
            $oPet->_setData($aPet);

            if ($oPet->_Validate()) {
                $oPet->Update();
                $this->Message_AddNoticeSingle('Успешно обновлено', 'Внимание');
            } else {
                $this->Viewer_Assign('oPet', $oPet);
                $this->Message_AddError($oPet->_getValidateError(), $this->Lang_Get('error'));
            }

            if (isset($_FILES['pet_photo']) && $_FILES['pet_photo']['error'] == 0) {
                if ($oPhoto = $oPet->getPhoto()) {
                    $oPhoto->Delete();
                }
                $this->Media_UploadLocal($_FILES['pet_photo'], 'pet_photo', $oPet->getId());
            }
        }
    }
}
