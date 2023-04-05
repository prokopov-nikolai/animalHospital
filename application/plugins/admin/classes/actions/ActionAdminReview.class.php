<?php

class PluginAdmin_ActionAdminReview extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, 'Отзывы', 'review');
        $this->SetDefaultEvent('page1');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^publish$/', '/^\d+$/', 'ReviewPublishChange');
        $this->AddEventPreg('/^delete$/', '/^\d+$/', 'ReviewDelete');
        $this->AddEventPreg('/^page(\d+)$/', 'ReviewList');
        $this->AddEventPreg('/^(\d+)$/', 'ReviewEdit');

    }

    /**
     * Список отзывов
     */
    public function ReviewList()
    {
        $iPage = $this->GetEventMatch(1);
        $iPage = $iPage ? $iPage : 0;
        $iPerPage = Config::Get('module.review.per_page');
        $aReview = $this->Review_GetItemsByFilter([
            '#select' => [
                't.*',
                'p.title_full product_title_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id'
            ],
            '#order' => ['id' => 'desc'],
            '#page' => [$iPage, $iPerPage]
        ]);
        $aPaging = $this->Viewer_MakePaging($aReview['count'], $iPage, $iPerPage, Config::Get('pagination.pages.count'), ADMIN_URL . "review/", $_GET);
        $this->Viewer_Assign('aPaging', $aPaging);
        $this->Viewer_Assign('aReview', $aReview);
        $this->SetTemplateAction('review.list');
    }

    /**
     * Смена статуса опубликовано
     */
    public function ReviewPublishChange()
    {
        $oReview = $this->Review_GetById($this->GetParamEventMatch(0, 0));
        if($oReview->getModerate()){
            $oReview->setModerate(0);
            $this->Message_AddNoticeSingle('Отзыв снят с публикации', false, true);
        } else {
            $oReview->setModerate(1);
            $this->Message_AddNoticeSingle('Отзыв успешно опубликован', false, true);
        }
        $oReview->Update();
        // пересчитаем рейтинг
        $oRating = $this->Review_GetByFilter([
            '#select' => [
                'SUM(rating) sum',
                'COUNT(rating) count',
            ],
            '#where' => [
                't.product_id = ?d AND t.moderate = ?d' => [$oReview->getProductId(), 1]
            ]
        ]);
        $oProduct =$this->Product_GetById($oReview->getProductId());
        $oProduct->setRatingSum($oRating->getSum());
        $oProduct->setRatingCount($oRating->getCount());
        $oProduct->setRatingItog($oRating->getSum()/$oRating->getCount());
        $oProduct->Update();
        return Router::Location($_SERVER['HTTP_REFERER']);
    }

    /**
     * Удаление отзыва
     */
    public function ReviewDelete()
    {
        $oReview = $this->Review_GetById($this->GetParamEventMatch(0, 0));
        if($oReview){
            $this->Message_AddErrorSingle('Отзыв успешно удален', false, true);
            $oReview->Delete();
            return Router::Location(ADMIN_URL.'review/');
        } else {
            parent::EventNotFound();
        }
    }

    /**
     * Редактирование отзыва
     */
    public function ReviewEdit()
    {
        $this->AppendBreadCrumb(20,'Редактирование');
        $iReviewId = $this->GetEventMatch(1);
        $oReview = $this->Review_GetByFilter([
            '#select' => [
                't.*',
                'p.title_full product_title_full'
            ],
            '#join' => [
                'INNER JOIN ' . Config::Get('db.table.product') . ' p ON p.id = t.product_id'
            ],
            '#where' => [
                't.id = ?d' => [$iReviewId]
            ]
        ]);
        if (!$oReview) return parent::EventNotFound();
        if (isPost()){
            $aReview = getRequest('review');
            $aReview['moderate'] = isset($aReview['moderate']) ? $aReview['moderate'] : 0;
            $oDate = new DateTime($aReview['date_add']);
            $aReview['date_add'] = $oDate->format('Y-m-d H:i:s');
            $oReview->_setData($aReview);
            if ($oReview->_Validate()) {
                $oReview->Update();
                // пересчитаем рейтинг
                $oRating = $this->Review_GetByFilter([
                    '#select' => [
                        'SUM(rating) sum',
                        'COUNT(rating) count',
                    ],
                    '#where' => [
                        't.product_id = ?d AND t.moderate = ?d' => [$oReview->getProductId(), 1]
                    ]
                ]);
                $oProduct =$this->Product_GetById($oReview->getProductId());
                $oProduct->setRatingSum($oRating->getSum());
                $oProduct->setRatingCount($oRating->getCount());
                $oProduct->setRatingItog($oRating->getSum()/$oRating->getCount());
                $oProduct->Update();
                $this->Message_AddNotice('Успешно сохранено');
            } else {
                $this->Message_AddError($oReview->_getValidateError(), 'Ошибка');
            }
            if(isset($_FILES['photos']['name'][0]) && $_FILES['photos']['name'][0]) {
                $files = $_FILES['photos'];
                foreach ($files['name'] as $i => $name) {
                    $file = [
                        'name' => $name,
                        'type' => $files['type'][$i],
                        'tmp_name' => $files['tmp_name'][$i],
                        'error' => $files['error'][$i],
                        'size' => $files['size'][$i],
                    ];
                    $this->Media_UploadLocal($file, 'review', $oReview->getId());
                }

                $this->Message_AddNotice('Фото успешно добавлено');
            }
        }
        $this->Viewer_Assign('review', $oReview);
        $this->SetTemplateAction('review.edit');
    }
}
