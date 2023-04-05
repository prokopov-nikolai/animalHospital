<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminMedia_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Заменяем оригинал изображение и удаляем его копии
     */
    public function MediaChange()
    {
        $sMediaType = 'collection';
        $iFabricId = (int)getRequest('iFabricId');
        if (!isset($_FILES['photo'])) return $this->Message_AddErrorSingle('Не передано изображение');
        if ($_FILES['photo']['error'] !== 0)  return $this->Message_AddErrorSingle('Изображение загружено с ошибкой');
        $sFileTmp = Config::Get('path.tmp.server').'/'.md5($_FILES['photo']['tmp_name']);
        if (!move_uploaded_file($_FILES['photo']['tmp_name'], $sFileTmp)) return $this->Message_AddErrorSingle('Hacking attempt');
        $oMediaFabric = $this->Media_GetMediaById($iFabricId);
        if (!$oMediaFabric) return $this->Message_AddErrorSingle('Ткань не найдена');
        $aParams = $this->Image_BuildParams('media.' . $sMediaType);
        /**
         * Если объект изображения не создан, возвращаем ошибку
         */
        if (!$oImage = $this->Image_Open($sFileTmp, $aParams)) {
            $this->Fs_RemoveFileLocal($sFileTmp);
            return $this->Message_AddErrorSingle($this->Image_GetLastError());
        }
        /**
         * Сохраняем оригинальную копию
         */
        $sPathFabric = $this->Fs_GetPathServer($oMediaFabric->getFilePath());
        $aFabricInfo = pathinfo($sPathFabric);
        if (!$sFileResult = $oImage->save($aFabricInfo['dirname'].'/'. $aFabricInfo['basename'])) {
            $this->Fs_RemoveFileLocal($sFileTmp);
            return $this->Image_GetLastError();
        }
        $oMediaFabric->setFileSize(filesize($sFileTmp));
        $oMediaFabric->setWidth($oImage->getWidth());
        $oMediaFabric->setHeight($oImage->getHeight());
        $pHash = PHasher::Instance();
        $sFileServerPath = $this->Fs_GetPathServer($oMediaFabric->getFilePath('300x'));
        $oMediaFabric->setOriginalHash($pHash->HashAsString($pHash->HashImage($sFileServerPath, 0, 0, 32)));
        $oMediaFabric->setMirroredHash($pHash->HashAsString($pHash->HashImage($sFileServerPath, 0, 1, 32)));
        $oMediaFabric->Update();
        /**
         * Удалим копии
         */
        $oMediaFabric->deleteCopies();
        /**
         * Теперь можно удалить временный файл
         */
        $this->Fs_RemoveFileLocal($sFileTmp);
        $this->Message_AddNoticeSingle('Изображение успешно заменено');
        $this->Viewer_AssignAjax('sImgUrlWidth300', $oMediaFabric->getFileWebPath('300x'));
    }
}
