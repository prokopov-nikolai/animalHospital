<?php
/**
 * Основной файл центрального крона
 * Файл необходимо добавить на сервере в список cron процессов с периодом запуска 1 раз в 5 минут.
 * ВНИМАНИЕ! Крон необходимо добавить от имени пользователя, под которым работает ваш веб-сервер. Это позволит избежат проблем с правами.
 */


require_once(dirname(dirname(__DIR__)) . '/bootstrap/start.php');

class CronCategoryFilters extends Cron
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
        $aCategoryFilter = $this->Category_GetFilterAll();
        foreach ($aCategoryFilter as $oCategoryFilter) {
            /**
             * Обновим товары и дизайны в категории фильтре
             */
            $this->Category_UpdateFilterItems($oCategoryFilter->getId());
        }
        $this->Cache_Delete('category_filter_tree_node_0');

    }
}

/**
 * Создаем объект крон-процесса,
 * передавая параметром путь к лок-файлу
 */
$app = new CronCategoryFilters(Config::Get('sys.cache.dir') . 'CronCategoryFilters.lock');
print $app->Exec();