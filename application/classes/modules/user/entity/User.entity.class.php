<?php

class ModuleUser_EntityUser extends EntityORM
{
    protected $aRelations = [
        'session' => [self::RELATION_TYPE_HAS_ONE, 'ModuleUser_EntitySession', 'user_id'],
    ];

    protected $aValidateRules = [
        ['email', 'email', 'allowEmpty' => false, 'on' => ['registration']],
        ['email', 'email_exists', 'on' => ['registration']],
        ['phone', 'phone_exists', 'on' => ['registration']],
        ['password', 'string', 'allowEmpty' => false, 'min' => 5, 'on' => ['registration']],
        ['password_confirm', 'compare', 'compareField' => 'password', 'on' => ['registration']],
        ['captcha', 'captcha', 'allowEmpty' => false, 'on' => ['registration']],
    ];

    protected $aRight = [];


    /**
     * Определяем дополнительные правила валидации
     *
     * @param array|bool $aParam
     */
    public function __construct($aParam = false)
    {
        $sCaptchaValidateType = func_camelize('captcha_' . Config::Get('general.captcha.type'));
        $this->aValidateRules[] = [
            'captcha',
            $sCaptchaValidateType,
            'name' => 'user_signup',
            'on' => ['registration'],
            'label' => $this->Lang_Get('auth.labels.captcha_field')
        ];

        parent::__construct($aParam);
    }

    /**
     * Проверка емайла на существование
     *
     * @param string $sValue Валидируемое значение
     * @param array $aParams Параметры
     * @return bool
     */
    public function ValidateEmailExists($sValue, $aParams)
    {
        if (!$this->User_GetUserByEmail($sValue)) {
            return true;
        }
        return $this->Lang_Get('auth.registration.notices.error_mail_used');
    }

    /**
     * Проверка телефон на существование
     *
     * @param string $sValue Валидируемое значение
     * @param array $aParams Параметры
     * @return bool
     */
    public function ValidatePhoneExists($sValue, $aParams)
    {
        if (!$this->User_GetUserByPhone($sValue)) {
            return true;
        }
        return $this->Lang_Get('auth.registration.notices.error_phone_used');
    }

    /**
     * Проверка емайла на существование
     *
     * @param string $sValue Валидируемое значение
     * @param array $aParams Параметры
     * @return bool
     */
    public function ValidateCaptcha($sValue, $aParams)
    {
        if ($this->Session_Get('captcha') == $sValue) {
            return true;
        }
        return $this->Lang_Get('auth.registration.notices.error_captcha_code');
    }


    protected function beforeSave()
    {
        if ($this->_isNew()) {
            if (!$this->getDateCreate()) {
                $this->setDateCreate(date("Y-m-d H:i:s"));
            }
            if (!$this->getIpCreate()) {
                $this->setIpCreate(func_getIp());
            }
        }
        return true;
    }

    public function isAdministrator()
    {
        return $this->isAdmin();
    }

    public function isAdmin()
    {
        return $this->getIsAdmin();
    }

    public function isAgent()
    {
        return $this->getIsAgent();
    }

    public function isManager()
    {
        return $this->getIsManager();
    }

    public function getUrl($sPage = null)
    {
        return '#';
        return Router::GetPath('profile') . $this->getId() . '/' . ($sPage ? $sPage . '/' : '');
    }

    public function getDisplayName()
    {
        return htmlspecialchars($this->getMail());
    }

    public function getRights()
    {
        if (count($this->aRight) == 0) {
            $this->aRight = $this->Right_GetItemsByFilter([
                '#join' => ['INNER JOIN '.Config::Get('db.table.prefix').'user_rights ur ON ur.right_id = t.id'],
                '#where' => ['ur.user_id = ?d' => [$this->getId()]],
                '#index-from' => 'key'
            ]);
        }
        return $this->aRight;
    }

    /**
     * Телефон
     */
    public function getPhone($bFormat = false, $bFull = false)
    {
        $sPhone = $this->_getDataOne('phone');
        return $bFormat ? FormatPhone($sPhone) : (($bFull) ? $sPhone:  substr($sPhone,1));
    }

    /**
     * Телефон доп.
     */
    public function getPhoneDop($bFormat = false, $bFull = false)
    {
        $sPhone = $this->_getDataOne('phone_dop');
        return $bFormat ? FormatPhone($sPhone) : (($bFull) ? $sPhone:  substr($sPhone,1));
    }

    public function getPhoto()
    {
        if ($aMedia = $this->Media_GetMediaByTarget('user_photo', $this->getId())) {
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
}
