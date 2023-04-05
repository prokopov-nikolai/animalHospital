{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'price-agent'}
{/block}

{block name='layout_content'}
    <h1>Добавление скидки агента на категорию товаров</h1>
    {component 'alert' text=[['msg' => 'после операции добавления все старые скидки выбранной категории будут удалены и добавлены вновь', 'title' => 'Внимание']] mods='error' close=true}
    {component 'alert' text=[['msg' => 'Цены устанавливаются для всех товаров выбранной категории, включая скрытые']] mods='notice' close=true}
    <form action="" method="post" class="agent-prices-add-by-category">
        {component field template='select'
        label   = 'Производитель'
        items   = $aMakeSelect
        id      = 'make-id'
        selectedValue = ($oMake) ? $oMake->getid() : ''
        name    = 'make_id'}

        {if $oMake}
            {component field template='select'
            label   = 'Группа тканей'
            items   = $oMake->getGroupsArrayForSelect()
            id      = 'make_group'
            selectedValue = $iMakeId
            name    = 'make_group'}
        {/if}

        {component field template='select'
        label   = 'Категория товаров'
        items   = $aCategorySelect
        name    = 'category_id'}

        {component field template='text'
        label           = 'Агент'
        name            = 'agent'
        value           = $sAgentName
        inputClasses    = 'agent autocomplete-pro'
        isDisabled      = ($oUserCurrent->isAdmin()) ? false : true
        inputAttributes = ['autocomplete' => 'off']}

        {component field template='hidden' name='agent_id' id='agent-id'}

        {component field template='text' name='discount' label='Скидка'}
        <small class="note">Если скидка установлена как 0, то будут удалены все цены по выбранным параметрам</small>
        <br>
        {component button text='Добавить'}
    </form>
{/block}

{block 'scripts' append}
    <script>
        $(function () {
            /**
             * Выбор производителя
             */
            $('#make-id').change(function () {
                window.location.href = ADMIN_URL + 'product/price-agent/add-by-category/?make_id=' + $(this).val();
            });
            /**
             * Поиск агента
             */
            $('.autocomplete-pro.agent').autocompletePro({
                    name: 'agent',
                    url: '/ajax/search/agent/',
                    data: {
                        field: 'value'
                    },
                    render: function (obj) {
                        var item =
                            '<div class="row" data-id="' + obj.id + '">' +
                            '<span>' + obj.fio + ' // ' + obj.phone + '</span>'
                        '</div>';
                        return item;
                    }
                },
                function (obj) {
                    $('#agent-id').val(obj.id);
                    $('.autocomplete-pro.agent').val(obj.fio + ' // ' + obj.phone);
                }
            );
        });
    </script>
{/block}