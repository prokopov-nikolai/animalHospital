<?php

class PluginAdmin_ModuleAsset_EntityTypeJs extends PluginAdmin_Inherit_ModuleAsset_EntityTypeJs {
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
		$sFileCache = Config::Get('path.tmp.server').'/cache_hash';
		if (file_exists($sFileCache)) {
			$sCacheHash = file_get_contents($sFileCache);
		} else {
			$sCacheHash = md5(time());
			file_put_contents($sFileCache, $sCacheHash);
		}
		$this->Viewer_Assign('sCacheHash', $sCacheHash);
		$sDefer = (isset($aParams['defer']) and $aParams['defer']) ? ' defer ' : '';
		$sAsync = (isset($aParams['async']) and $aParams['async']) ? ' async ' : '';
		$sHtml = '<script src="' . $sFile . '?'.$sCacheHash.'" ' . $sDefer . $sAsync . '></script>';
		return $this->wrapForBrowser($sHtml, $aParams);
	}
}