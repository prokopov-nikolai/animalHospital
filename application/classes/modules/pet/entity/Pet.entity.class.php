<?php

class ModulePet_EntityPet extends EntityORM
{
    protected $aValidateRules = [
        ['nickname', 'string', 'allowEmpty' => false, 'min' => 2, 'on' => ['registration'], 'label' => 'Питомец'],
        ['user_id', 'userExists', 'on' => ['registration']],
    ];

    /**
     * Определяем дополнительные правила валидации
     *
     * @param array|bool $aParam
     */
    public function __construct($aParam = false)
    {
        parent::__construct($aParam);
    }

    public function ValidateUserExists($sValue, $aParams)
    {
        if (!$this->User_GetUserById($sValue)) {
            return 'Пользователь не найден';
        }
        return true;
    }

    public function getPhoto()
    {
        if ($aMedia = $this->Media_GetMediaByTarget('pet_photo', $this->getId())) {
            if (isset($aMedia[0])) {
                return  $aMedia[0];
            }
        }
        return false;
    }

    public function getPhotoWebPath($sSize = '') : string
    {
        if ($oPhoto = $this->getPhoto()) {
            return  $oPhoto->getFilewebPath($sSize);
        }
        return '';
    }

    public function getSpeciesText()
    {
        return GetSelectText($this->getSpecies(), 'pets_species_items');
    }
}