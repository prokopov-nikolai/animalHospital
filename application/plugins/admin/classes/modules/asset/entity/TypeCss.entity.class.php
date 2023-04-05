<?php

class PluginAdmin_ModuleAsset_EntityTypeCss extends PluginAdmin_Inherit_ModuleAsset_EntityTypeCss
{
    /**
     * Возвращает HTML обертку для файла
     *
     * @param $sFile
     * @param $aParams
     *
     * @return string
     */
    public function getHeadHtml($sFile, $aParams)
    {
        $sFileCache = Config::Get('path.tmp.server') . '/cache_hash';
        if (file_exists($sFileCache)) {
            $sCacheHash = file_get_contents($sFileCache);
        } else {
            $sCacheHash = md5(time());
            file_put_contents($sFileCache, $sCacheHash);
        }
        $sHtml = '<link rel="stylesheet" type="text/css" href="' . $sFile . '?' . $sCacheHash . '" />';
        return $this->wrapForBrowser($sHtml, $aParams);
    }
}