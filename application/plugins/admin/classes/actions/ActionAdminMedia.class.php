<?php

class PluginAdmin_ActionAdminMedia extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Изображения', 'media');
        $this->SetDefaultEvent('page1');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^upload$/i', '/^ckeditor$/i', 'UploadCKeditor');
        $this->AddEventPreg('/^upload$/i', 'Upload');
        $this->AddEventPreg('/^(page([\d]+))?$/i', 'MediaList');
        $this->AddEventPreg('/^([\d]+)$/i', '/^create$/', 'MediaCreate');
        $this->AddEventPreg('/^([\d]+)$/i', '/^delete$/', 'MediaDelete');
        $this->AddEventPreg('/^copy$/i', '/^delete$/', 'MediaCopyDelete');
        $this->AddEventPreg('/^([\d]+)$/i', 'MediaInfo');
        /**
         * ajax
         */
        $this->RegisterEventExternal('AjaxMedia', 'PluginAdmin_ActionAdminMedia_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^change$/i', 'AjaxMedia::MediaChange');
    }


    /**
     * Удаляем копии всех изображений рекурсивно
     * Array
     * (
     * [dirname] => /files/www/fisher.local/uploads/media/design
     * [basename] => 2019
     * [filename] => 2019
     * )
     */
    public function MediaCopyDelete()
    {

        $aId = explode(',', getRequest('aId'));
        if (is_array($aId) && $aId[0] > 0) {
            $this->Message_AddNoticeSingle('Ничего не удалено', false, true);
            $aMedia = $this->Media_GetItemsByArrayId($aId);
            if (is_array($aMedia)) {
                foreach ($aMedia as $oMedia) $oMedia->deleteCopies();
            }
            $this->Message_AddNoticeSingle('Копии изображений успешно удалены', false, true);
        } else {
            $sDir = Config::Get('path.root.server') . '/uploads/media/design';
            if ($oHandler = opendir($sDir)) {
                while (false !== ($sEntry = readdir($oHandler))) {
                    if ($sEntry == '.' || $sEntry == '..') {
                        // ничего не делаем
                    } elseif (is_dir($sDir . '/' . $sEntry)) {
                        $this->DeleteCopy($sDir . '/' . $sEntry);
                    }
                }
            }
            $sDir = Config::Get('path.root.server') . '/uploads/media/product';
            if ($oHandler = opendir($sDir)) {
                while (false !== ($sEntry = readdir($oHandler))) {
                    if ($sEntry == '.' || $sEntry == '..') {
                        // ничего не делаем
                    } elseif (is_dir($sDir . '/' . $sEntry)) {
                        $this->DeleteCopy($sDir . '/' . $sEntry);
                    }
                }
            }
            $sDir = Config::Get('path.root.server') . '/uploads/media/3d';
            if ($oHandler = opendir($sDir)) {
                while (false !== ($sEntry = readdir($oHandler))) {
                    if ($sEntry == '.' || $sEntry == '..') {
                        // ничего не делаем
                    } elseif (is_dir($sDir . '/' . $sEntry)) {
                        $this->DeleteCopy($sDir . '/' . $sEntry);
                    }
                }
            }
        }
        $this->Message_AddNoticeSingle('Удалены копии изображений товаров, дизайнов, 3d', false, true);
        return Router::Location($_SERVER['HTTP_REFERER'] ? $_SERVER['HTTP_REFERER'] : ADMIN_URL);
    }

    /**
     * Вспомогательная функция для рекурсивного удаления копий
     * @param $sDir
     */
    private function DeleteCopy($sDir)
    {
        if ($oHandler = opendir($sDir)) {
            while (false !== ($sEntry = readdir($oHandler))) {
                if ($sEntry == '.' || $sEntry == '..') {

                } elseif (is_dir($sDir . '/' . $sEntry)) {
                    $this->DeleteCopy($sDir . '/' . $sEntry);
                } else {
                    $sFilePath = $sDir . '/' . $sEntry;
                    if (!preg_match('/\/[a-z0-9]+.jpg$/m', $sFilePath)) {
                        unlink($sFilePath);
                    }
                }
            }
        }
    }

    /**
     * Загрузка изображений
     */
    public function UploadCKeditor()
    {
        $aFile = $_FILES['upload'];
        $sFullPath = '';
        $sMessage = 'Успешно загружено';
        $sСallback = $_REQUEST['CKEditorFuncNum'];
        $iTargetId = (int)getRequest('target_id');
        $sTargetType = getRequest('target_type');
        if ($aFile['tmp_name']) {
            // Загрузка изображения
            $mMedia = $this->Media_UploadLocal($aFile, $sTargetType, $iTargetId);
            if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                $sMessage = $mMedia;
            } else {
                $sFullPath = $mMedia->getFileWebPath();
            }
        }
        exit('<script type="text/javascript">window.parent.CKEDITOR.tools.callFunction("' . $sСallback . '", "' . $sFullPath . '", "' . $sMessage . '" );</script>');
    }

    // ==================================================================
    // ==================================================================
    // ==================================================================
    // ==================================================================


    public function MediaList()
    {
        $iPage = $this->GetEventMatch(2, 0);
        $iPage = (!$iPage ? 1 : $iPage);
        $aResult = $this->Media_GetMediaItemsByFilter([
            '#select' => ['t.*'],
            '#order' => ['t.date_add' => 'desc'],
            '#where' => ['t.target_type = ?' => ['media']],
            '#page' => [$iPage, Config::Get('module.media.per_page')]
        ]);
        $this->Viewer_Assign('aMedia', $aResult['collection']);
        $aPaging = $this->Viewer_MakePaging($aResult['count'], $iPage, Config::Get('module.media.per_page'), Config::Get('pagination.pages.count'), ADMIN_URL . 'media/');
        $this->Viewer_Assign('paging', $aPaging);
        $this->SetTemplateAction('list');
    }


    public function MediaInfo()
    {
        $iId = $this->GetEventMatch(1, 0);
        $oMedia = $this->Media_GetMediaById($iId);
        $this->Viewer_Assign('oMedia', $oMedia);
        $this->Viewer_SetResponseAjax('json');
        $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__) . 'media.tpl'));
    }

    public function MediaCreate()
    {
        $iId = $this->GetEventMatch(1, 0);
        $oMedia = $this->Media_GetMediaById($iId);
        $sFormat = getRequestStr('format');
        $this->Viewer_SetResponseAjax('json');
        $this->Viewer_AssignAjax('sFilePath', $oMedia->getFileWebPath($sFormat));
    }

    public function Upload()
    {
        $aFile = $_FILES['file'];
        if ($aFile['tmp_name']) {
            // Загрузка изображения
            $oMedia = $this->Media_UploadLocal($aFile, getRequestStr('target_type'), (int)getRequest('target_id'));
            $this->Viewer_Assign('oMedia', $oMedia);
            $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__) . 'media_item.tpl'));
        }

        $this->Viewer_SetResponseAjax('json', false, false);
        $this->Message_AddNoticeSingle('Изображение успешно загружено');
    }

    public function MediaDelete()
    {
        $iId = $this->GetEventMatch(1, 0);
        $oMedia = $this->Media_GetMediaById($iId);
        $oMedia->Delete();
        $this->Viewer_SetResponseAjax('json');
        $this->Message_AddNoticeSingle('Успешно удалено');
    }
}
