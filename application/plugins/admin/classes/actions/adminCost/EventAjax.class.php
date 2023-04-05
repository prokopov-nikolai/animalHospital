<?php

/**
 * Часть экшена админки по управлению ajax запросами
 */
class PluginAdmin_ActionAdminCost_EventAjax extends Event
{

    public function Init()
    {
        if (!LS::HasRight('24_report_costs')) return parent::EventForbiddenAccess();
        /**
         * Устанавливаем формат ответа
         */
        $this->Viewer_SetResponseAjax('json', true, false);
    }

    public function Add()
    {
        $cost = (array)getRequest('cost');
        $cost['date'] = date('Y-m-d', strtotime($cost['date']));

        if (!($cost['type'])) {
            return $this->Message_AddErrorSingle('Выберите тип');
        }

        if (!is_numeric($cost['sum'])) {
            return $this->Message_AddErrorSingle('Сумма должна быть числом');
        }

        if ($cost['sum'] == 0) {
            return $this->Message_AddErrorSingle('Сумма не может быть 0');
        }

        $cost = Engine::GetEntity('Cost', $cost);
        $cost->Add();
        $this->Message_AddNoticeSingle('Успешно добавлено');
    }

    public function Delete()
    {
        $cost = $this->Cost_GetById((int)getRequest('id'));

        if ($cost) {
            $cost->Delete();
            return $this->Message_AddNoticeSingle('Успешно удалено');
        }

        return $this->Message_AddErrorSingle('Неверный id');
    }
}
