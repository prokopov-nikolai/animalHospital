<?php

class PluginAdmin_ActionAdminUsers extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.users'), 'users');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        /**
         * Покупатели
         */
        $this->AddEventPreg('/^(page([\d]+))?$/i', 'UsersList');
        $this->AddEventPreg('/^([\d]+)$/i', 'UserEdit');
        $this->AddEventPreg('/^add$/i', 'UserAdd');
        $this->AddEventPreg('/^remove$/i','/^([\d]+)$/i', 'UserRemove');
        /**
         * ajax
         */
        $this->RegisterEventExternal('AjaxUser', 'PluginAdmin_ActionAdminUsers_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^search$/i', 'AjaxUser::Search');
        $this->AddEventPreg('/^ajax$/i', '/^right$/i', '/^change$/i', 'AjaxUser::RightChange');
    }

    /**
     * Список покупателей
     */
    public function UsersList()
    {
        if (!LS::HasRight('1_users')) return parent::EventForbiddenAccess();
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $iPage = $this->GetEventMatch(2, 0);
        $iPage = (!$iPage ? 1 : $iPage);
        $aResult = $this->User_GetUserItemsByFilter(array(
            '#where' => [
                '1=1 {AND ((t.fio LIKE ?} 
                            { OR t.fio LIKE ?}
                            { OR t.fio LIKE ?}
                            { OR t.fio LIKE ?
                           )
                        OR (t.phone LIKE ?} 
                            { OR t.phone LIKE ?}
                            { OR t.phone LIKE ?}
                            { OR t.phone LIKE ?
                           )
                        OR (t.email LIKE ?} 
                            { OR t.email LIKE ?}
                            { OR t.email LIKE ?}
                            { OR t.email LIKE ?
                           ))}
                           ' => [
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP,
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP,
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP,
                ]
            ],
            '#sort' => array('date_create' => 'desc'),
            '#page' => array($iPage, Config::Get('module.user.per_page'))
        ));
        $this->Viewer_Assign('aUser', $aResult['collection']);
        $aPaging = $this->Viewer_MakePaging($aResult['count'], $iPage, Config::Get('module.user.per_page'), Config::Get('pagination.pages.count'), ADMIN_URL . 'user/');
        $this->Viewer_Assign('paging', $aPaging);
        $this->SetTemplateAction('users.list');
    }

    /**
     * Выводим данные по пользователю
     */
    public function UserEdit()
    {
        if (!LS::HasRight('2_users_edit')) return parent::EventForbiddenAccess();
        $oUser = $this->User_GetById($this->GetParamEventMatch(0));
        $this->UserSubmit($oUser);
        /**
         * Получим пользователя по айди из урла
         */
        $this->AppendBreadCrumb(20, $oUser->getFio());
        $this->Viewer_Assign('oUser', $oUser);
        $aRight = $this->Right_LoadTreeOfRight(['#order' => ['sort' => 'asc']]);
        $this->Viewer_Assign('aRight', $aRight);
        $aUserRight = $this->Right_GetItemsByFilter([
            '#join' => ['INNER JOIN ' . Config::Get('db.table.prefix') . 'user_rights ur ON ur.right_id = t.id'],
            '#where' => ['ur.user_id = ?d' => [$oUser->getId()]],
            '#index-from' => 'key',
            '#cache' => ['user_'.$oUser->getId().'_right']
        ]);
        $this->Viewer_Assign('aUserRight', $aUserRight);
        $this->SetTemplateAction('user.edit');
    }

    public function UserAdd()
    {
        if (isPost()) {
            $oUser = Engine::GetEntity('user', getRequest('user'));
            $oUser->setPasswordConfirm($oUser->getPassword());
            $oUser->_setValidateScenario('registration');
            if ($oUser->_Validate()) {
                $oUser->Add();
                Router::Location(ADMIN_URL.'users/'.$oUser->getId().'/');
            } else {
                foreach ($oUser->_getValidateErrors() as $aFieldErrors) {
                    foreach ($aFieldErrors as $sError) {
                        $this->Message_AddError($sError);
                    }
                }
            }
        } else {
            $oUser = Engine::GetEntity('user');
        }
        $this->Viewer_Assign('oUser', $oUser);
        $this->SetTemplateAction('user.add');
    }

    public function UserRemove()
    {
        $iUserId = $this->GetParamEventMatch(0,1);
        $oUser = $this->User_GetById($iUserId);
        if (!$oUser) return parent::EventNotFound();
        $oUser->Delete();
        $this->Message_AddNotice('Пользоваль успешно удален', false, true);
        return Router::Location(ADMIN_URL.'users/');
    }

    private function UserSubmit(&$oUser)
    {
        if (isPost()) {
            $aUser = getRequest('user');
            $aUser['phone'] = NormalizePhone($aUser['phone']);
            $aUser['phone_dop'] = NormalizePhone($aUser['phone_dop']);
            if (!isset($aUser['is_admin'])) $aUser['is_admin'] = 0;
            if (!isset($aUser['is_manager'])) $aUser['is_manager'] = 0;
            if (!isset($aUser['is_agent'])) $aUser['is_agent'] = 0;
            if (!isset($aUser['activate'])) $aUser['activate'] = 0;
            if (!LS::HasRight('19_user_public_key') && isset($aUser['public_key'])) {
                if (isset($aUser['site'])) unset($aUser['site']);
                unset($aUser['public_key']);
            }
            $oUser->_setData($aUser);
            if (($sPass = getRequestStr('new_pass')) && $sPass != '') {
                $oUser->setPassword(md5($sPass));
            }
            $oU = $this->User_GetByPhone($aUser['phone']);
            if ($oU && $oU->getId() != $oUser->getId()) {
                $this->Viewer_Assign('oUser', $oUser);
                $this->Message_AddError('Пользователь с таким телефоном уже существует');
            } else {
                if ($oUser->_Validate()) {
                    $oUser->Update();
                    $this->Message_AddNoticeSingle('Успешно обновлено', 'Внимание');
                } else {
                    $this->Viewer_Assign('oUser', $oUser);
                    $this->Message_AddError($oUser->_getValidateError(), $this->Lang_Get('error'));
                }
            }

            if (isset($_FILES['user_photo']) && $_FILES['user_photo']['error'] == 0) {
                if ($oPhoto = $oUser->getPhoto()) {
                    $oPhoto->Delete();
                }

                $this->Media_UploadLocal($_FILES['user_photo'], 'user_photo', $oUser->getId());
            }
        }
    }
}
