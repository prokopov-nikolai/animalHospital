<div id="modal-rejected-cause" class="modal-window">
    <div class="modal-close"></div>
    <div class="modal-content">
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