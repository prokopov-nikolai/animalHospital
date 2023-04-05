<div id="modal-task" class="modal-window left-scrolled">
    <div class="modal-close"></div>
    <div class="modal-content">
        <h3>Задача к заказу №<span class="order-id"></span></h3>
        {component field template='datetime'
        label       = 'Дата'
        value       = ''
        classes     = '_item'
        inputClasses = 'task-date'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component field template='textarea'
        label       = 'Задача'
        value       = ''
        classes     = '_item'
        inputClasses = 'task-text'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component field template='checkbox'
        label       = 'Только для меня'
        value       = ''
        classes     = '_item'
        inputClasses = 'task-personal'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component button text='Добавить задачу' classes="task-add" mods='primary'}
    </div>
</div>

{capture name="scripts"}
    <script>
        $('.task-add').on('click', function(e){
            e.stopPropagation();
            e.preventDefault();
            let oTask = {};
            oTask.order_id = iOrderId;
            oTask.text = $('.task-text').val();
            oTask.date_time = $('.task-date').val();
            oTask.personal = $('.task-personal')[0].checked;
            ls.ajax.load(ADMIN_URL+'order/ajax/task/add/', { task: oTask }, function(answer){
                if (answer.bStateError == false) {
                    window.location.reload();
                    ModalHide(false, $('#modal-task'));
                }
            });
            return false;
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}