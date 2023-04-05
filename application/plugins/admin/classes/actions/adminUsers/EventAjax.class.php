<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminUsers_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    /**
     * Поиск пользователя
     */
    public function Search()
    {
        $search = getRequestStr('search');
        $phone = preg_replace('/[^0-9]+/m', '', $search);

        if (substr($phone, 0, 1) == 8) {
            $phone = '7'.substr($phone, 1);
        }

        $aFilter = [
            '#where' => [
                't.fio LIKE ? OR t.email LIKE ?{ OR t.phone LIKE ?}' => [
                    '%' . $search . '%',
                    '%' . $search . '%',
                    $phone ? '%' . $phone . '%' : DBSIMPLE_SKIP,
                ]
            ],
            '#cache' => '',
            '#limit' => 10,
        ];
        $aUser = $this->User_GetItemsByFilter($aFilter);
        $aRes = [];
        if (count($aUser) > 0) {
            foreach ($aUser as $oUser) {
                $aRes[] = $oUser->_getData();
            }
        } else {
            if ($phone) {
                $aRes[] = array(
                    'id' => 'add',
                    'fio' => 'Добавить пользователя',
                    'phone' => FormatPhone($phone),
                    'email' => '',
                );
            }
        }
        $this->Viewer_AssignAjax('users', $aRes);
    }

    public function RightChange()
    {
        if (!LS::HasRight('3_users_edit_rights')) return parent::EventForbiddenAccess();
        $iRightId = (int)getRequest('iRightId');
        $bChecked = getRequest('bChecked');
        $iUserId = (int)getRequest('iUserId');
        $oRight = $this->Right_GetById($iRightId);
        if (!$oRight) return $this->Message_AddErrorSingle('Права с указанным айди не найдены');
        $oUser = $this->User_GetById($iUserId);
        if (!$oUser) return $this->Message_AddErrorSingle('Пользователь не найден');
        $this->Cache_Delete('user_'.$oUser->getId().'_right');
        $aUserRight = $this->User_GetRightsItemsByFilter([
            'user_id' => $oUser->getId(),
            'right_id' => $oRight->getId(),
        ]);
        if ($bChecked == 'false' && count($aUserRight)) {
            foreach($aUserRight as $oUserRight) $oUserRight->Delete();
            return $this->Message_AddNoticeSingle('Права успешно удалены');
        }
        $oUserRight = Engine::GetEntity('User_Rights', [
            'user_id' => $oUser->getId(),
            'right_id' => $oRight->getId(),
        ]);
        $oUserRight->Save();
        $this->Message_AddNoticeSingle('Права успешно добавлены');
    }
}
