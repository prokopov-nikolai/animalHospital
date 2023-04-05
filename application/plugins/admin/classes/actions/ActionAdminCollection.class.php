<?php

class PluginAdmin_ActionAdminCollection extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Ткани', 'collection');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->SetDefaultEvent('list');
        /**
         * Коллекции
         */
        $this->AddEventPreg('/^edit$/i', '/^\d+?$/', 'CollectionEdit');
        $this->AddEventPreg('/^delete$/i', '/^\d+?$/', 'CollectionDelete');
        $this->AddEventPreg('/^add$/i', 'CollectionAdd');
        $this->AddEventPreg('/^list$/i', 'CollectionList');
        $this->AddEventPreg('/^page(\d+)$/', 'CollectionList');


        /**
         * Для ajax регистрируем внешний обработчик
         */
        $this->RegisterEventExternal('AjaxCollection', 'PluginAdmin_ActionAdminCollection_EventAjax');
        $this->AddEventPreg('/^ajax$/i', '/^media$/i', '/^update$/i',   'AjaxCollection::MediaUpdate');
        $this->AddEventPreg('/^ajax$/i', '/^media$/i', '/^sort$/i',     'AjaxCollection::MediaSort');
        $this->AddEventPreg('/^ajax$/i', '/^media$/i', '/^remove$/i',   'AjaxCollection::MediaRemove');
        $this->AddEventPreg('/^ajax$/i', '/^search$/i',                 'AjaxCollection::Search');

        // ===================================================
        // ===================================================
        // ===================================================
        // ===================================================
    }


    /**
     * Список коллекций
     */
    public function CollectionList()
    {
        if (!LS::HasRight('9_collection')) return parent::EventForbiddenAccess();
        $iPage = $this->GetEventMatch(1,0);
        $iPage = $iPage ? $iPage : 1;
        $iPerPage = Config::Get('collection.per_page');
        $this->AppendBreadCrumb(30, 'Коллекции', 'list');
        $sSupplier = getRequestStr('supplier');
        $sSearch = getRequestStr('search');
        $sSearch1 = lat2rus($sSearch);
        $sSearch2 = Translit($sSearch);
        $sSearch3 = rus2lat($sSearch);
        $aCollection = $this->Collection_GetItemsByFilter([
            '#where' => [
                '1=1 { AND t.supplier = ?}
                {AND (t.title LIKE ?} 
                            { OR t.title LIKE ?}
                            { OR t.title LIKE ?}
                            { OR t.title LIKE ?
                           )}' => [
                    $sSupplier ? $sSupplier : DBSIMPLE_SKIP,
                    $sSearch ? '%' . $sSearch . '%' : DBSIMPLE_SKIP,
                    $sSearch1 ? '%' . $sSearch1 . '%' : DBSIMPLE_SKIP,
                    $sSearch2 ? '%' . $sSearch2 . '%' : DBSIMPLE_SKIP,
                    $sSearch3 ? '%' . $sSearch3 . '%' : DBSIMPLE_SKIP
                ]
            ],
            '#order' => ['title' => 'asc'],
            '#page' => [$iPage, $iPerPage]
        ]);
        if (!count($aCollection['collection'])) return parent::EventNotFound();
        $this->Viewer_Assign('aCollection', $aCollection['collection']);
        $aPaging = $this->Viewer_MakePaging($aCollection['count'], $iPage, $iPerPage, Config::Get('pagination.pages.count'), ADMIN_URL.'collection/', $_GET);
        $this->Viewer_Assign('aPaging', $aPaging);
        $this->SetTemplateAction('collection.list');
    }

    /**
     * Добавляем коллекцию
     */
    public function CollectionAdd()
    {
        if (!LS::HasRight('9_collection')) return parent::EventForbiddenAccess();
        if (isPost('collection_title')) {
            $oCollection = Engine::GetEntity('Collection');
            $oCollection->setTitle(getRequestStr('collection_title'));
            $oCollection->setUrl($this->Main_GetUrl(getRequestStr('collection_title'), 'collection'));
            $oCollection->Add();
            $this->Message_AddNoticeSingle('Коллекция успешно добавлена', false, true);
            return  Router::Location(ADMIN_URL.'collection/edit/'.$oCollection->getId().'/');

        }
    }

    /**
     * Редактируем коллекцию
     */
    public function CollectionEdit()
    {
        if (!LS::HasRight('9_collection')) return parent::EventForbiddenAccess();
        $this->AppendBreadCrumb(30, 'Коллекции', 'list');
        $oCollection = $this->Collection_GetById($this->GetParamEventMatch(0, 0));
        $this->AppendBreadCrumb(40, $oCollection->getTitle());
        if ($aCollection = getRequest('collection')) {
            if (isset($aCollection['design_type'])) {
                $aCollection['design_type'] = implode(',', $aCollection['design_type']);
            } else {
                $aCollection['design_type'] = '';
            }
            /**
             * Обновляем
             */
            $oCollection->_setData($aCollection);
            if ($oCollection->_Validate()) {
                $oCollection->Save();
                /**
                 * Добавляем изображения
                 */
                if (isset($_FILES['photo']) && count($_FILES['photo'])) {
                    foreach ($_FILES['photo']['error'] as $iK => $iError) {
                        if ($iError == 0) {
                            $mMedia = $this->Media_UploadUrl($_FILES['photo']['tmp_name'][$iK], 'collection', $oCollection->getId());
                            if (!($mMedia instanceof ModuleMedia_EntityMedia)) {
                                $this->Message_AddError($mMedia . ' : ' . $iK, '');
                            } else {
                                $mMedia->setAlt(preg_replace('/\.(.){3,4}$/','', $_FILES['photo']['name'][$iK]));
                                $mMedia->Update();
                            }
                        }
                    }
                }
                $this->Message_AddNotice('Успешно обновлено', 'Внимание', true);
            } else {
                $this->Viewer_Assign('oCollection', $oCollection);
                $this->Message_AddError($oCollection->_getValidateError(), 'Ошибка');
            }
        }

        $this->Viewer_Assign('oCollection', $oCollection);
        $this->SetTemplateAction('collection.edit');
    }

    /**
     * Удаление коллекции
     * @return string
     */
    public function CollectionDelete()
    {
        if (!LS::HasRight('10_collection_delete')) return parent::EventForbiddenAccess();
        $oCollection = $this->Collection_GetById($this->GetParamEventMatch(0, 0));
        if (!$oCollection) return parent::EventNotFound();
        $sMessage = 'Коллекция "'.$oCollection->getTitle().'//'.$oCollection->getSupplierRu().'" успешно удалена';
        if ($oCollection->Delete()){
            $this->Message_AddNoticeSingle($sMessage, false, true);
        } else {
            $this->Message_AddErrorSingle('Коллекция не может быть удалена, так как есть заказы с ее тканями', false, true);
        }
        Router::Location(ADMIN_URL.'collection');
    }

}
