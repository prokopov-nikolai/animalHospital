<?php

class PluginAdmin_ActionAdminCoupon extends PluginAdmin_ActionPlugin
{

    public function Init()
    {
        parent::Init();
        $this->AppendBreadCrumb(10, $this->Lang_Get('plugin.admin.menu.coupon'), 'coupon');
        $this->SetDefaultEvent('list');
    }

    /**
     * Регистрируем евенты
     *
     */
    protected function RegisterEvent()
    {
        $this->AddEventPreg('/^list$/i', 'CouponList');
        $this->AddEventPreg('/^delete$/', '/^([a-x0-9]+)$/i', 'CouponDelete');
    }

    /**
     * Список
     */
    public function CouponList()
    {
        if (!LS::HasRight('36_coupon')) return parent::EventForbiddenAccess();

        if (isPost()) {
            $coupon = Engine::GetEntity('Coupon', [
                'date_time_start' => date( 'Y-m-d H:i:s', strtotime(getRequestStr('date_time_start'))),
                'date_time_end' => date( 'Y-m-d H:i:s', strtotime(getRequestStr('date_time_end'))),
                'code' => getRequestStr('code'),
                'sum' => (int)getRequestStr('sum')
            ]);
            if ($coupon->_Validate()) {
                $coupon->Add();
                $this->Message_AddNoticeSingle('Купон успешно добавлен', false, true);
                Router::Location(ADMIN_URL.'coupon/');
            } else {
                foreach ($coupon->_getValidateErrors() as $field => $error) {
                    $this->Message_AddError($error[0]);
                }
            }
        }

        $this->Viewer_Assign('coupons', $this->Coupon_GetItemsByFilter(['#order' => ['code' => 'asc']]));
        $this->SetTemplateAction('coupon.list');
    }

    /**
     * Удаление
     * @param $oMake
     */
    public function CouponDelete()
    {
        if (!LS::HasRight('36_coupon')) return parent::EventForbiddenAccess();

        $coupon = $this->Coupon_GetByCode($this->GetParamEventMatch(0, 0));

        if (!$coupon) return parent::EventNotFound();

        if ($coupon->getAppliedCount() > 0){
            $this->Message_AddErrorSingle('Купон нельзя удалить, так как его уже применяли', false, true);
        } else {
            $coupon->Delete();
            $this->Message_AddNoticeSingle('Купон успешно удален', false, true);
        }
        Router::Location(ADMIN_URL.'coupon/');
    }

}
