<?php

class ModuleMain extends Module
{

    /**
     * Инициализация
     */
    public function Init()
    {
        $this->oMapper = Engine::GetMapper(__CLASS__);
    }


    /**
     * Получаем уникальный урл по таблице
     * @param $sUrl
     * @param $sTable
     */
    public function GetUrl($sUrl, $sTable, $bTranslit = true)
    {
        $sUrl = translit($sUrl);
        while($this->oMapper->GetUrl($sUrl, $sTable)){
            preg_match_all('/-(\d+)$/', $sUrl, $aM, PREG_SET_ORDER);
            if (isset($aM[0][1])){
                $sUrl = preg_replace('/-\d+$/', '-'.(intval($aM[0][1])+1), $sUrl);
            } else {
                $sUrl .= '-1';
            }
        }
        return $sUrl;
    }

    /**
     * Генерирует гуид
     */
    public function GenerateGUID()
    {
        return $this->oMapper->GenerateGUID();
    }

    public function CheckAccessControlAllowOrigin($bAccessAll = false){
        $oSite = $this->User_GetSitesByPublicKey(getRequestStr('public_key'));
        if ($oSite) {
            header('Access-Control-Allow-Origin: ' . ($bAccessAll ? '*' : 'https://'.$oSite->getSite()));
        } else {
            exit('access denied');
        }
        /**
         * Проверка по рефереру
         */
        if (isset($_SERVER['HTTP_REFERER'])) {
            $aData = parse_url($_SERVER['HTTP_REFERER']);
            if (isset($aData['host']) && $oSite->getSite() == $aData['host']) {
                header('Access-Control-Allow-Origin: ' . ($bAccessAll ? '*' : 'https://'.$oSite->getSite()));
            } else {
                exit('access denied');
            }
        }
        return true;
    }
}