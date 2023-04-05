<?php
/*
 * LiveStreet CMS
 * Copyright © 2013 OOO "ЛС-СОФТ"
 *
 * ------------------------------------------------------
 *
 * Official site: www.livestreetcms.com
 * Contact e-mail: office@livestreetcms.com
 *
 * GNU General Public License, version 2:
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 *
 * ------------------------------------------------------
 *
 * @link http://www.livestreetcms.com
 * @copyright 2013 OOO "ЛС-СОФТ"
 * @author Maxim Mzhelskiy <rus.engine@gmail.com>
 *
 */

/**
 * Сущность медиа данных (изображение, видео и т.п.)
 *
 * @package application.modules.media
 * @since 2.0
 */
class ModuleMedia_EntityMedia extends EntityORM
{

    protected $aValidateRules = array();

//    protected $aRelations = array(
//        'targets' => array(self::RELATION_TYPE_HAS_MANY, 'ModuleMedia_EntityTarget', 'media_id'),
//    );

    protected function beforeSave()
    {
        if ($bResult = parent::beforeSave()) {
            if ($this->_isNew()) {
                $this->setDateAdd(date("Y-m-d H:i:s"));
            }
        }
        return $bResult;
    }

    protected function beforeDelete()
    {
        if ($bResult = parent::beforeDelete()) {
            $this->deleteCopies();
            /**
             * Удаляем все файлы медиа
             */
            $this->Media_DeleteFiles($this);
        }
        return $bResult;
    }

    /**
     * Размер скидки в рублях
     * @param bool $bNumberFormat
     * @param bool $bWithCurrency
     */
    public function getDiscount($bNumberFormat = false, $bWithCurrency = false)
    {
        $iDiscount =
            ($this->getPriceMake()
                + ($this->getMargin() < 100 ? $this->getPriceMake() * $this->getMargin() / 100 : $this->getMargin())
                + $this->getPriceDeliveryMake()
                - $this->getPriceDelivery())
            * ($this->_getDataOne('discount') / 100);
        /**
         * $this->getPriceOptions()
         * Стоимость дополнительных опций не учитываем, так как скидка на них не распространяется.
         */
        return GetPrice($iDiscount, $bNumberFormat, $bWithCurrency);
    }

    /**
     * Возвращает Серверный путь
     *
     * @return null
     */
    public function getFileServerPath()
    {
        if ($this->getFilePath()) {
            return $this->Fs_GetPathServer($this->getFilePath());
        } else {
            return null;
        }
    }

    /**
     * Возвращает URL до файла нужного размера, в основном используется для изображений
     *
     * @param null $sSize
     *
     * @return null
     */
    public function getFileWebPath($sSize = null)
    {
        if ($this->getFilePath()) {
            return $this->Media_GetFileWebPath($this, $sSize);
        } else {
            return null;
        }
    }

    public function getData()
    {
        $aData = @unserialize($this->_getDataOne('data'));
        if (!$aData) {
            $aData = array();
        }
        return $aData;
    }

    public function setData($aRules)
    {
        $this->_aData['data'] = @serialize($aRules);
    }

    public function getDataOne($sKey)
    {
        $aData = $this->getData();
        if (isset($aData[$sKey])) {
            return $aData[$sKey];
        }
        return null;
    }

    public function setDataOne($sKey, $mValue)
    {
        $aData = $this->getData();
        $aData[$sKey] = $mValue;
        $this->setData($aData);
    }

    public function getRelationTarget()
    {
        return $this->_getDataOne('_relation_entity');
    }


    public function isFileExists()
    {
        return file_exists($this->Fs_GetPathServerFromWeb($this->getFileWebPath()));
    }

    /**
     * Поставщик на русском
     * @return string
     */
    public function getSupplierRu() {
        $aSupplier = Config::Get('collection_supplier_ru');
        return isset($aSupplier[$this->getSupplier()]) ? $aSupplier[$this->getSupplier()] : '';
    }

    public function getTitle()
    {
        return $this->getAlt();
    }

    public function getTitleFull()
    {
        return $this->getAlt().' ('.$this->getSupplierRu().')';
    }

    /**
     * Удаляем все копии кроме оригинала
     * Array
    (
    [dirname] => /files/www/fisher.local/uploads/media/design/2019/12/27/11
    [basename] => a3eae0ca5f0a04975f24.jpg
    [extension] => jpg
    [filename] => a3eae0ca5f0a04975f24
    )
     */
    public function deleteCopies()
    {
        $sFilePath = $this->Fs_GetPathServer($this->getFilePath());
        $aInfo = pathinfo($sFilePath);
//        echo "{$aInfo['basename']}\n";
        if ($oHandler = opendir($aInfo['dirname'])) {
            while (false !== ($sEntry = readdir($oHandler))) {
                if ($sEntry != $aInfo['basename'] && substr($sEntry, 0, strlen($aInfo['filename'])) == $aInfo['filename']) {
                    unlink($aInfo['dirname'].'/'.$sEntry);
                }
            }
        }
        return true;
    }

    /**
     * Цена дизайна / товара если полностью в этой ткани
     * @param bool $bNumberFormat
     * @param bool $bWithCurrency
     * @return int|string
     */
    public function getPrice($bNumberFormat = false, $bWithCurrency = false)
    {
        if ($this->getPriceMake()) {
            $iPrice =
                ($this->getPriceMake() +
                (($this->getMargin() < 100) ? $this->getPriceMake()*$this->getMargin()/100: $this->getMargin()) +
                $this->getPriceDeliveryMake() -
                $this->getPriceDelivery())
                * (1 - $this->_getDataOne('discount') / 100)
            ;
        } else {
            $iPrice = $this->_getDataOne('price');
        }
        return GetPrice($iPrice, $bNumberFormat, $bWithCurrency);
    }

    /**
     * Старая цена
     * @param bool $bNumberFormat
     * @param bool $bWithCurrency
     * @return string
     */
    public function getPriceOld($bNumberFormat = false, $bWithCurrency = false)
    {
        if ($this->_getDataOne('discount') > 0) {
            $iPrice = $this->getPrice() + $this->getDiscount();
            return GetPrice($iPrice, $bNumberFormat, $bWithCurrency);
        }
        return null;
    }

    /**
     * Массив значений цветов
     */
    public function getColorArray()
    {
        $aColor =  explode(',', $this->getColor());
        if (!is_array($aColor)) $aColor = [];
        return $aColor;
    }

    public function getFileExtension () {
        $aInfo = pathinfo($this->getFilePath());
        return $aInfo['extension'];
    }
}
