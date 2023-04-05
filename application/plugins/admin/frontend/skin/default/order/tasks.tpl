{if !count($tasks)}
    <p>Ничего не найдено</p>
{else}
    {$day = ''}
    <table class="table tasks">
        <tr>
            <th>Время</th>
            <th>Заказ</th>
            <th>Постановщик</th>
            <th>Задача</th>
            <th>Персональная</th>
            <th>Выполнил(а)</th>
            <th>Дата время выполнения(а)</th>
        </tr>
        {foreach $tasks as $task}
            {if $task->getDateTimeFormat('d F') != $day}
                {$day = $task->getDateTimeFormat('d F')}
                <tr>
                    <th colspan="7">{$day}</th>
                </tr>
            {/if}
            <tr title="{$task->getId()}" data-id="{$task->getId()}">
                <td>{$task->getDateTimeFormat('H:i')}</td>
                <td class="order-number"><a href="{$ADMIN_URL}order/{$task->getOrderId()}/#tab6">{$task->getAgentNumber()}</a></td>
                <td>{$task->getUserFio()}</td>
                <td>{$task->getText()}</td>
                <td>{if $task->getPersonal()}да{else}нет{/if}</td>
                <td>
                    {if !$task->getDone()}
                        <button type="submit" value="" class="ls-button  task-done">Да</button>
                    {else}
                        {$task->getUserFioDone()}
                    {/if}
                </td>
                <td>{$task->getDateTimeDoneFormat('H:i')}</td>
            </tr>
        {/foreach}
    </table>

{/if}