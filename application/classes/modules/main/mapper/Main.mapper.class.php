<?php

class ModuleMain_MapperMain extends Mapper
{
    // для импорта данных
    public function GetUrl($sUrl, $sTable)
    {
        $sSql = 'SELECT url
				FROM ' . Config::Get('db.table.' . $sTable) . '
				WHERE url = ?
				LIMIT 1';
        return $this->oDb->selectCell($sSql, $sUrl);
    }

    /**
     * Генерирует гуид
     */
    public function GenerateGUID()
    {
        return $this->oDb->selectCell('SELECT UUID() LIMIT 1');
    }

}
