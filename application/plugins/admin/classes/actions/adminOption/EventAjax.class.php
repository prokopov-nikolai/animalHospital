<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminOption_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Добавляем значение опции
     */
    public function ValueAdd()
    {
        $iOptionId = (int)getRequest('id');

        $oOPVMAx = $this->Option_GetValuesByFilter([
            '#select' => ['MAX(sort) `max`'],
            '#where' => [
                'option_id = ?d' => [$iOptionId]
            ],
        ]);
        $oOptionValue = Engine::GetEntity('Option_Values', [
            'option_id' => $iOptionId,
            'sort' => $oOPVMAx->getMax()
        ]);
        $oOptionValue->Add();
        $this->Viewer_Assign('oOptionValue', $oOptionValue);
        $this->Viewer_AssignAjax('sHtml', $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__) . 'forms/option/ajax.item.tpl'));
        $this->Message_AddNoticeSingle('Успешно добавлено');
    }

    /**
     * Обновляем значение опции
     */
    public function ValueUpdate()
    {
        $oOptionValue = $this->Option_GetValuesById((int)getRequest('id'));
        if (!$oOptionValue) return $this->Message_AddErrorSingle('Значение опции не найдено');
        if (isPost('title')) $oOptionValue->setTitle(getRequestStr('title'));
        if (isPost('margin')) $oOptionValue->setMargin((float)getRequest('margin'));
        $oOptionValue->Update();
        if (isset($_FILES['image']['tmp_name']) && $_FILES['image']['tmp_name']) {
            if ($oMedia = $oOptionValue->getImage()) $oMedia->Delete();
            if (isset($_FILES['image']['error']) && $_FILES['image']['error'] == 1) {
                $this->Viewer_AssignAjax('sError', 'Размер файла превышает допустимый');
                $this->Viewer_AssignAjax('success', false);
                return false;
            }
            if (isset($_FILES['image']['size']) && $_FILES['image']['size'] > 2 * 1024 * 1024) {
                $this->Viewer_AssignAjax('sError', 'Размер файла превышает 2мб');
                $this->Viewer_AssignAjax('success', false);
                return false;
            }
            if (isset($_FILES['image']['tmp_name'])) {
                @$aExif = exif_read_data($_FILES['image']['tmp_name']);
                if(!in_array($aExif['MimeType'], ['image/jpeg', 'image/png']) || !$aExif) {
                    $this->Viewer_AssignAjax('sError', 'Не верный формат файла');
                    $this->Viewer_AssignAjax('success', false);
                    return false;
                }
                /**
                 * Сохраняем изображение
                 */
                $mMedia = $this->Media_UploadLocal($_FILES['image'], 'option_value', $oOptionValue->getId());
                if ($mMedia instanceof ModuleMedia_EntityMedia) {
                    $this->Viewer_AssignAjax('sSrc', $mMedia->getFileWebPath('50x50crop'));
                    $this->Viewer_AssignAjax('sMessage', 'Успешно обновлено');
                    $this->Viewer_AssignAjax('success', true);
                } else {
                    $this->Viewer_AssignAjax('sError', 'Ошибка при заргрузке изображения');
                    $this->Viewer_AssignAjax('success', false);
                }
            }
        }
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

    /**
     * Обновляем медиа
     */
    public function ValueSort()
    {
        foreach (getRequest('sort') as $iSort => $iOVId) {
            $oOptionValue = $this->Option_GetValuesById((int)$iOVId);
            $oOptionValue->setSort($iSort)->Update();
        }
        $this->Message_AddNoticeSingle('Успешно обновлено');
    }

    /**
     * Обновляем медиа
     */
    public function ValueDelete()
    {
        $oOptionValue = $this->Option_GetValuesById((int)getRequest('id'));
        if (!$oOptionValue) return parent::EventNotFound();
        if ($oMedia = $oOptionValue->getImage()) $oMedia->Delete();
        $oOptionValue->Delete();
        $this->Message_AddErrorSingle('Успешно удалено');
    }
}
