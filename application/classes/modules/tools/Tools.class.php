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
 * Модуль Tools - различные вспомогательные методы
 *
 * @package application.modules.tools
 * @since 1.0
 */
class ModuleTools extends Module
{
    /**
     * Инициализация
     *
     */
    public function Init()
    {

    }

    /**
     * Строит логарифмическое облако - расчитывает значение size в зависимости от count
     * У объектов в коллекции обязательно должны быть методы getCount() и setSize()
     *
     * @param aray $aCollection Список тегов
     * @param int $iMinSize Минимальный размер
     * @param int $iMaxSize Максимальный размер
     * @return array
     */
    public function MakeCloud($aCollection, $iMinSize = 1, $iMaxSize = 10)
    {
        if (count($aCollection)) {
            $iSizeRange = $iMaxSize - $iMinSize;

            $iMin = 10000;
            $iMax = 0;
            foreach ($aCollection as $oObject) {
                if ($iMax < $oObject->getCount()) {
                    $iMax = $oObject->getCount();
                }
                if ($iMin > $oObject->getCount()) {
                    $iMin = $oObject->getCount();
                }
            }
            $iMinCount = log($iMin + 1);
            $iMaxCount = log($iMax + 1);
            $iCountRange = $iMaxCount - $iMinCount;
            if ($iCountRange == 0) {
                $iCountRange = 1;
            }
            foreach ($aCollection as $oObject) {
                $iTagSize = $iMinSize + (log($oObject->getCount() + 1) - $iMinCount) * ($iSizeRange / $iCountRange);
                $oObject->setSize(round($iTagSize));
            }
        }
        return $aCollection;
    }

    /**
     * Возвращает дерево объектов
     *
     * @param array $aEntities Массив данных сущностей с заполнеными полями 'childNodes'
     * @param bool $bBegin
     *
     * @return array
     */
    public function BuildEntityRecursive($aEntities, $bBegin = true)
    {
        static $aResultEntities;
        static $iLevel;
        static $iMaxIdEntity;
        if ($bBegin) {
            $aResultEntities = array();
            $iLevel = 0;
            $iMaxIdEntity = 0;
        }
        foreach ($aEntities as $aEntity) {
            $aTemp = $aEntity;
            if ($aEntity['id'] > $iMaxIdEntity) {
                $iMaxIdEntity = $aEntity['id'];
            }
            $aTemp['level'] = $iLevel;
            unset($aTemp['childNodes']);
            $aResultEntities[$aTemp['id']] = $aTemp['level'];
            if (isset($aEntity['childNodes']) and count($aEntity['childNodes']) > 0) {
                $iLevel++;
                $this->BuildEntityRecursive($aEntity['childNodes'], false);
            }
        }
        $iLevel--;
        return array('collection' => $aResultEntities, 'iMaxId' => $iMaxIdEntity);
    }

    /**
     * Преобразует спец символы в html последовательнось, поведение аналогично htmlspecialchars, кроме преобразования амперсанта "&"
     *
     * @param string $sText
     *
     * @return string
     */
    public function Urlspecialchars($sText)
    {
        return func_urlspecialchars($sText);
    }

    /**
     * Отдает файл на загрузку в браузер пользователя
     *
     * @param      $sFilePath
     * @param      $sFileName
     * @param null $iFileSize
     *
     * @return bool
     */
    public function DownloadFile($sFilePath, $sFileName, $iFileSize = null)
    {
        if (file_exists($sFilePath) and $file = fopen($sFilePath, "r")) {
            header("Content-Type: application/octet-stream");
            header("Content-Disposition: attachment; filename=" . urlencode($sFileName) . ";");
            header("Content-Transfer-Encoding: binary");
            if ($iFileSize) {
                header("Content-Length: " . $iFileSize);
            }
            while (!feof($file)) {
                $sContent = fread($file, 1024 * 100);
                echo $sContent;
            }
            Engine::getInstance()->Shutdown();
            exit(0);
        }
        return false;
    }

    /**
     * Запускает задачу рассылки емайлов (отложенная отправка)
     */
    public function SystemTaskNotify()
    {
        $aNotifyTasks = $this->Notify_GetTasksDelayed(Config::Get('module.notify.per_process'));
        if (!$aNotifyTasks) {
            return 'empty';
        }
        /**
         * Последовательно загружаем задания
         */
        $aArrayId = array();
        foreach ($aNotifyTasks as $oTask) {
            $this->Notify_SendTask($oTask);
            $aArrayId[] = $oTask->getTaskId();
        }
        /**
         * Удаляем отработанные задания
         */
        $this->Notify_DeleteTaskByArrayId($aArrayId);
        return "Send notify: " . count($aArrayId);
    }

    /**
     * Подмена переменных в шаблоне метаданных
     * @param $sMeta
     * @param
     */
    public function ReplaceMetaVariables($sMeta, $aData)
    {
        if (isset($aData['category'])) {
            $oCategory = $aData['category'];
        }
        if (isset($aData['product'])) {
            $oProduct = $aData['product'];
        }
        if (isset($aData['design'])) {
            $oDesign = $aData['design'];
        }
        preg_match_all('/{(.*?)\|?(lower|upper)?}/m', $sMeta, $aM, PREG_SET_ORDER);
        if (count($aM) > 0) {
            foreach ($aM as $aD) {
                $sReplace = '';
                switch ($aD[1]) {
                    case 'category_price_min':
                        $sReplace = isset($oCategory) ? round($oCategory->getPriceMin()) : '';
                        break;
                    case 'category_price_max':
                        $sReplace = isset($oCategory) ? round($oCategory->getPriceMax()) : '';
                        break;
                    case 'category_title':
                        $sReplace = isset($oCategory) ? $oCategory->getTitle() : '';
                        break;
                    case 'category_product_prefix':
                        $sReplace = isset($oCategory) ? $oCategory->getProductPrefix() : '';
                        break;
                    case 'product_title':
                        $sReplace = isset($oProduct) ? $oProduct->getProductPrefix() : '';
                        break;
                    case 'product_title_full':
                        $sReplace = isset($oProduct) ? $oProduct->getTitleFull() : '';
                        break;
                    case 'product_price':
                        $sReplace = isset($oProduct) ? round($oProduct->getPrice()) : '';
                        break;
                    case 'design_title':
                        $sReplace = isset($oDesign) ? $oDesign->getProductPrefix() : '';
                        break;
                    case 'design_title_full':
                        $sReplace = isset($oDesign) ? $oDesign->getTitleFull() : '';
                        break;
                    case 'design_price':
                        $sReplace = isset($oDesign) ? round($oDesign->getPrice()) : '';
                        break;
                    case 'h1':
                        $sReplace = '';
                        foreach ($aData as $oObject) {
                            if ($oObject->getText()) {
                                preg_match_all('/<h1.*?>(.*?)<\/h1>/', $oObject->getText(), $aT, PREG_SET_ORDER);
                                if (isset($aT[0][1])) {
                                    $sReplace = $aT[0][1];
                                    break;
                                }
                            }
                        }
                        break;
                    case 'color':
                        $sReplace = isset($oDesign) ? $oDesign->getColorRu() : $oProduct->getColorRu();;
                        break;
                    case 'city':
                        $sReplace = ' ### замена города пока не сделана ### ';
                        break;

                }
                if (isset($aD[2])) {
                    $sFunction = "mb_strto{$aD[2]}";
                    $sReplace = $sFunction($sReplace, 'utf-8');
                }
                $sMeta = str_replace($aD[0], $sReplace, $sMeta);
            }
        }
        return $sMeta;
    }
}
