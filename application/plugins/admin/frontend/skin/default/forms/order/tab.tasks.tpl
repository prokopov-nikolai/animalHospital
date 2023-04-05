{component button text='Добавить задачу' classes="modal-task-show" mods='primary'}

<table class="table history">
    <tbody>
    <tr>
        <th>Дата и время</th>
        <th>Задача</th>
        <th>Персональная</th>
        <th>Отправлено</th>
        <th>Выполнено</th>
        <th>Выполнил</th>
        <th>Дата выполнения</th>
        <th></th>
    </tr>
    {foreach $oOrder->getTasks() as $oTask}
        <tr data-id="{$oTask->getId()}">
            <td>{$oTask->getDateTime()|date_format:'d.m.Y H:i'}</td>
            <td>{$oTask->getText()}</td>
            <td>{if $oTask->getPersonal()}да{else}нет{/if}</td>
            <td>{if $oTask->getSended()}<span class="checkbox-blue"></span>{else}-{/if}</td>
            <td>{if $oTask->getDone()}<span class="checkbox-blue"></span>{else}{component button text='Да' classes="task-done"}{/if}</td>
            <td>{if $userDone = $oTask->getUserDone()}{$userDone->getFio()}{/if}</td>
            <td>{$oTask->getDateTimeDoneFormat()}</td>
            <td><span class="ls-icon-remove task-remove"></span></td>
        </tr>
    {/foreach}
    </tbody>
</table>

{include file="{$aTemplatePathPlugin.admin}modal/modal.task.tpl"}

{capture name="scripts"}
    <script>
        $('.modal-task-show').on('click', function(){
            $('#modal-task .order-id').html(iOrderId);
            ModalShow($('#modal-task'));
            return false;
        });

        $('.task-remove').on('click', function(e){
            let oTr = $(this).parents('tr'),
                iTaskId = oTr.data('id');

            ls.ajax.load(ADMIN_URL + 'order/ajax/task/remove/', { task_id: iTaskId }, function(){
                oTr.remove();
            });
        });

        $('.task-done').on('click', function(){
            let oBut = $(this),
                oTr = $(this).parents('tr'),
                iTaskId = oTr.data('id');
            ls.ajax.load(ADMIN_URL + 'order/ajax/task/done/', { task_id: iTaskId }, function(){
                oBut.after('<span class="checkbox-blue"></span>').remove();
            });
            return false;
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}