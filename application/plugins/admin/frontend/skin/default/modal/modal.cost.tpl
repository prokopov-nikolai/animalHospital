<div id="modal-cost" class="modal-window">
    <div class="modal-close"></div>
    <div class="modal-content">
        <h3>Добавление расхода</h3>
        {component field template='date'
        label       = 'Дата'
        value       = $smarty.now|date_format:'d.m.Y'
        classes     = '_item'
        inputClasses = 'cost-date'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component field template='select'
        label       = 'Тип'
        classes     = '_item'
        inputClasses = 'cost-type'
        items       = $costItems}

        {component field template='text'
        label       = 'Сумма'
        value       = ''
        classes     = '_item'
        inputClasses = 'cost-sum'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component field template='textarea'
        label       = 'Комментарий'
        value       = ''
        classes     = '_item'
        inputClasses = 'cost-comment'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component button text='Добавить расход' classes="cost-add" mods='primary'}
    </div>
</div>

{capture name="scripts"}
    <script>
        $('#modal-cost .cost-add').on('click', function(e){
            e.stopPropagation();
            e.preventDefault();
            let cost = {};
            cost.date = $('#modal-cost .cost-date').val();
            cost.type = $('#modal-cost .cost-type').val();
            cost.sum = $('#modal-cost .cost-sum').val();
            cost.comment = $('#modal-cost .cost-comment').val();
            ls.ajax.load(ADMIN_URL+'cost/ajax/add/', { cost: cost }, function(answer){
                if (answer.bStateError == false) {
                    window.location.reload();
                    ModalHide(false, $('#modal-cost'));
                }
            });
            return false;
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}