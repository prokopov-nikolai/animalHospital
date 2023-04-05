<?php
/**
 * Основной файл центрального крона
 * Файл необходимо добавить на сервере в список cron процессов с периодом запуска 1 раз в 5 минут.
 * ВНИМАНИЕ! Крон необходимо добавить от имени пользователя, под которым работает ваш веб-сервер. Это позволит избежат проблем с правами.
 */


require_once(dirname(dirname(__DIR__)) . '/bootstrap/start.php');

class CronMailer extends Cron
{
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
        /**
         * Отправляем отложенные письма
         */
        $this->Tools_SystemTaskNotify();
    }
}

/**
 * Создаем объект крон-процесса,
 * передавая параметром путь к лок-файлу
 */
$app = new CronMailer(Config::Get('sys.cache.dir') . 'CronMailer.lock');
print $app->Exec();