<?php
/**
 * Основной файл центрального крона
 * Файл необходимо добавить на сервере в список cron процессов с периодом запуска 1 раз в 5 минут.
 * ВНИМАНИЕ! Крон необходимо добавить от имени пользователя, под которым работает ваш веб-сервер. Это позволит избежат проблем с правами.
 */

require_once(dirname(dirname(__DIR__)) . '/bootstrap/start.php');

class CronTelegram extends Cron {
    /**
     * Производить логирование или нет
     *
     * @var bool
     */
    protected $bLogEnable = false;

    /**
     * Запускаем обработку
     */
    public function Client()
    {
        set_time_limit(0);
        $aTask = $this->Task_GetItemsByFilter([
            '#where' => [
                'date_time < NOW() AND sended = ?d' => [0]
            ],
            '#cache' => false
        ]);
        /* Отправим задачи */
        if (count($aTask) > 0) {
            $aUser = $this->User_GetItemsByFilter([
                '#where' => [
                    'telegram_chat_id IS NOT NULL' => []
                ],
                '#index-from' => 'id'
            ]);

            foreach ($aTask as $oTask) {
                $oOrder = $this->Order_GetById($oTask->getOrderId());
                $aData = [
                    'chat_id' => '',
                    'text' => "🗓 ".($oTask->getPersonal() ? '1️⃣ ': '') . $oTask->getText() . "
<a href=\"https://fisher-store.ru/jarvis/order/" . $oOrder->getId() . "/#tab6\">" . $oOrder->getAgentNumber() . "</a>
#задачи".($oTask->getPersonal() ? '  #задачи_личная️⃣': ''),
                    'parse_mode' => 'html'
                ];
                if ($oTask->getPersonal() && isset($aUser[$oTask->getUserId()])) {
                    $aData['chat_id'] = $aUser[$oTask->getUserId()]->getTelegramChatId();
                    $aData['text'] .= ' #задачи_личная';
                    $this->Telegram_SendMessage($aData);
                } else {
                    foreach ($aUser as $oUser) {
                        $aData['chat_id'] = $oUser->getTelegramChatId();
                        $this->Telegram_SendMessage($aData);
                    }
                }
                $oTask->setSended(1);
                $oTask->Save();
            }

        }

        /* Отправим уведомления, что надо закрыть рекламацию */
        $managerOrders = [];
        $orders = $this->Order_GetItemsByFilter([
            '#where' => ['t.status = ?' => ['reclamation']]
        ]);
        $order = $this->Order_GetById(4869);
        if (count($orders) > 0) {
            foreach ($orders as $order) {
                if (!(count($order->getTasksFuture()) > 0)) {
                    $manager = $order->getManager();
                    if ($manager && $manager->getTelegramChatId()) {
                        $managerOrders[$manager->getId()][$order->getId()] = $order;
                    }
                }
            }
            if (count($managerOrders) > 0) {
                    $date = new DateTime();
                    if ($date->format('H') > 9 && $date->format('H') < 21 && $date->format('i') == 57) {
                        foreach ($managerOrders as $managerId => $orders) {
                            $aData = [
                                'chat_id' => '',
                                'text' => "⚠️ Необходимо закрыть рекламации:",
                                'parse_mode' => 'html'
                            ];
                            foreach ($orders as $order) {
                                pr($order->getId());
                                $aData['chat_id'] = $order->getManager()->getTelegramChatId();
                                $aData['text'] .= "
<a href=\"https://fisher-store.ru/jarvis/order/" . $order->getId() . "/\">Заказ №" . $order->getAgentNumber() . "</a>";
                            }
                            $aData['text'] .= "
#задачи #рекламации";
                            $this->Telegram_SendMessage($aData);
                        }
                    }
                }
        }
    }
}

/**
 * Создаем объект крон-процесса,
 * передавая параметром путь к лок-файлу
 */
$app = new CronTelegram(Config::Get('sys.cache.dir') . 'CronTelegram.lock');
print $app->Exec();