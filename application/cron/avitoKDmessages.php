<?php
/**
 * Основной файл центрального крона
 * Файл необходимо добавить на сервере в список cron процессов с периодом запуска 1 раз в 5 минут.
 * ВНИМАНИЕ! Крон необходимо добавить от имени пользователя, под которым работает ваш веб-сервер. Это позволит избежат проблем с правами.
 */


require_once(dirname(dirname(__DIR__)) . '/bootstrap/start.php');

class CronAvitoKDMessages extends Cron {
    /**
     * Производить логирование или нет
     *
     * @var bool
     */
    protected $bLogEnable = false;

    protected array $session = [];

    /**
     * @var string
     */
    protected string $sessionFilePath = '';

    /**
     * Запускаем обработку
     * @throws Exception
     */
    public function Client()
    {
        set_time_limit(0);

        $this->initSession();

        $accessToken = $this->getSession('avito_kd_access_token');
        $keys = Config::Get('avito.kd');
        if (!$accessToken) {
            $keys['grant_type'] = 'client_credentials';
            $curl = new Curl();
            $curl->SetUrl('https://api.avito.ru/token/');
            $curl->SetPostfields($keys);
            $result = $curl->GetResponseBody(true);
            $data = json_decode($result, true);

            if (isset($data['access_token'])) {
                $this->setSession('avito_kd_access_token', $data['access_token']);
            }
            $accessToken = $data['access_token'];
        }

        /* Получим информацию о себе */
        $userId = $this->getSession('avito_kd_user_id');
        if (!$userId) {
            $curl = new Curl();
            $curl->SetUrl('https://api.avito.ru/core/v1/accounts/self');
            $curl->SetOptionsArray([
                'CURLOPT_HTTPHEADER' => [
                    'Authorization: Bearer ' . $accessToken
                ]
            ]);
            $result = $curl->GetResponseBody(true);
            $data = json_decode($result, true);
            if (isset($data['id'])) {
                $this->setSession('avito_kd_user_id', $data['id']);
            }
            $userId = $data['id'];
        }

        /* Получим непрочитанные чаты */
        $curl = new Curl();
        $curl->SetUrl("https://api.avito.ru/messenger/v2/accounts/{$userId}/chats?unread_only=true");
        $curl->SetOptionsArray([
            'CURLOPT_HTTPHEADER' => [
                'Authorization: Bearer ' . $accessToken
            ]
        ]);
        $result = $curl->GetResponseBody(true);
        $data = json_decode($result, true);

        $users = $this->User_GetItemsByFilter([
            '#where' => [
                'telegram_chat_id IS NOT NULL AND make_id = 0' => []
            ],
            '#index-from' => 'id'
        ]);
        if (isset($data['chats']) && count($data['chats']) > 0) {
            /* Пройдем по всем чатам и сообщим если время непрочтения больше 15 минут */
            $this->SendChatsMessages($data, $users);
        } else {
            /* Получим новый токен */
            $keys['grant_type'] = 'client_credentials';
            $curl = new Curl();
            $curl->SetUrl('https://api.avito.ru/token/');
            $curl->SetPostfields($keys);
            $result = $curl->GetResponseBody(true);
            $data = json_decode($result, true);

            if (isset($data['access_token'])) {
                $this->setSession('avito_kd_access_token', $data['access_token']);
            }
            $accessToken = $data['access_token'];

            /* Снова получим чаты */
            $curl = new Curl();
            $curl->SetUrl("https://api.avito.ru/messenger/v2/accounts/{$userId}/chats?unread_only=true");
            $curl->SetOptionsArray([
                'CURLOPT_HTTPHEADER' => [
                    'Authorization: Bearer ' . $accessToken
                ]
            ]);
            $result = $curl->GetResponseBody(true);
            $data = json_decode($result, true);
            $this->SendChatsMessages($data, $users);
        }
    }

    private function SendChatsMessages($data, array $users)
    {
        foreach ($data['chats'] as $i => $chat) {
            $lastMessage = $chat['last_message'];
            $date = new DateTime(date('Y-m-d H:i:s', $lastMessage['created']));
            $dateNow = new DateTime();
            $interval = $date->diff($dateNow);
            $messageId = 'avito_kd_message_' . $lastMessage['id'];

            /* Если прошло больше 15 минут, то отправляем мне сообщение */
            if ($interval->h == 0 && $interval->i >= 15 && $interval->i < 20) {
                if (!$this->getSession($messageId)) {
                    $messageTelegram = [
                        'chat_id' => '',
                        'text' => "📩 Непрочитанное сообщение от {$date->format('d.m.Y H:i')} <a href=\"https://www.avito.ru/profile/messenger/channel/" . $chat['id'] . "/\">" . $chat['context']['value']['title'] . " (" . $chat['users'][0]['name'] . ")</a>
    {$lastMessage['content']['text']}
    #avito_kypit_divan_chats",
                        'parse_mode' => 'html'
                    ];
                    foreach ($users as $user) {
                        $messageTelegram['chat_id'] = $user->getTelegramChatId();
                        $this->Telegram_SendMessage($messageTelegram);
                    }
                    $this->setSession($messageId, 1);
                }
            }
        }
    }

    private function getSession(string $key)
    {
        if (isset($this->session[$key])) {
            return $this->session[$key];
        }
        return false;
    }

    private function setSession(string $key, $value)
    {
        $this->session[$key] = $value;
        file_put_contents($this->sessionFilePath, json_encode($this->session));
    }

    private function initSession()
    {
        $this->sessionFilePath = Config::Get('path.root.server') . '/uploads/telegram.chats.session.json';
        $json = (array)@json_decode(@file_get_contents($this->sessionFilePath), true);
        $this->session = $json;
    }
}

/**
 * Создаем объект крон-процесса,
 * передавая параметром путь к лок-файлу
 */
$app = new CronAvitoKDMessages(Config::Get('sys.cache.dir') . 'CronAvitoKDMessages.lock');
print $app->Exec();