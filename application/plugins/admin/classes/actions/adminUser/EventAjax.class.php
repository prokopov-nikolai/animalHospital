<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminUser_EventAjax extends Event
{

    public function Init()
    {
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }
    
    /**
     * Добавление пользователя
     */
    public function Add()
    {
        $sPhone = NormalizePhone(getRequestStr('sPhone'));
        if (!$sPhone) return $this->Message_AddErrorSingle('Некорректный телефон');
        $oUser = $this->User_GetByPhone($sPhone);
        if ($oUser) return $this->Message_AddErrorSingle('Пользователь с таким телефоном уже существует');
        $oUser = Engine::GetEntity('User',['phone' => $sPhone]);
        $oUser->Add();
        $this->Viewer_AssignAjax('iUserId', $oUser->getId());
        $this->Message_AddNoticeSingle('Пользователь успешно добавлен');
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
        $this->Viewer_AssignAjax('users', $aRes);
    }

    public function RightChange()
    {
        if (!LS::HasRight('16_user_rights')) return parent::EventForbiddenAccess();
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

    /**
     * Добавляем обновляем удаляем рабочий день для менеджера
     */
    public function Workday() {
        if (!LS::HasRight('3_report_salary')) return parent::EventForbiddenAccess();
        $workDayData = getRequest('work_day');
        $date = new DateTime($workDayData['date_start'].'+'.((int)$workDayData['num']-1).'days');

        if (!(LS::Adm() || (LS::CurUsr()->getId() == $workDayData['user_id'])))
            $this->Message_AddErrorSingle('Вы можете редактировать только свои дни');

        $this->User_DeleteWorkdaysItemsByFilter([
            '#where' => [
                'user_id = ?d AND date = ?' => [
                    (int)$workDayData['user_id'],
                    $date->format('Y-m-d')
                ]
            ]
        ]);

        $workDay = Engine::GetEntity('User_Workdays', [
            'user_id' => (int)$workDayData['user_id'],
            'date' => $date->format('Y-m-d'),
            'type' => $workDayData['type']
        ]);

        if ($workDayData['date_start'] < date('Y-m-d') && !LS::Adm()) {
            return $this->Message_AddErrorSingle('Изменять прошедшие даты нельзя');
        }

        switch ($workDayData['type']) {
            case 'morning':
                $workDay->setSalary('700');
                $workDay->Save();
            break;
            case 'evening':
                $workDay->setSalary('900');
                $workDay->Save();
            break;
            case 'day-off':
                $workDay->setSalary('1100');
                $workDay->Save();
            break;
        }

    }
}
