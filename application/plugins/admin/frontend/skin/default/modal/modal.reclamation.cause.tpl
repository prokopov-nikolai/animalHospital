<div id="modal-reclamation-cause" class="modal-window">
    <div class="modal-close"></div>
    <div class="modal-content">
        {component field template='select'
        label       = 'Тип рекламации'
        value       = ''
        classes     = '_item rejected-type'
        items       = [
            ['text' => 'Ошибка менеджера', 'value' => 'shop-manager'],
            ['text' => 'Ошибка фабрики', 'value' => 'manufacture'],
            ['text' => 'Ошибка доставки', 'value' => 'delivery'],
            ['text' => 'Не устроило клиента', 'value' => 'client']
        ]
        inputClasses = 'rejected-type'
        inputAttributes = [ 'autocomplete' => 'off']}

        &nbsp;<br>
        {component field template='textarea'
        label       = 'Укажите причину'
        value       = ''
        classes     = '_item'
        inputClasses = 'rejected-cause'
        inputAttributes = [ 'autocomplete' => 'off']}

        {component button text='Сохранить' classes="rejected-cause-add" mods='primary'}
    </div>
</div>

{capture name="scripts"}
    <script>
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}