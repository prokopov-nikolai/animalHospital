{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'price-agent'}
{/block}

{block name='layout_content'}
    <h1>Добавление скидки агента на дизайн</h1>
    <form action="" method="post" class="agent-prices-add-by-design">

        {component field template='text'
        label           = 'Дизайн'
        name            = 'design-item'
        value           = $sAgentName
        inputClasses    = 'design-item autocomplete-pro'
        isDisabled      = ($oUserCurrent->isAdmin()) ? false : true
        inputAttributes = ['autocomplete' => 'off']}

        {component field template='hidden' name='design_id' id='design-id'}

        {component field template='text'
        label           = 'Агент'
        name            = 'agent'
        value           = $sAgentName
        inputClasses    = 'agent autocomplete-pro'
        isDisabled      = ($oUserCurrent->isAdmin()) ? false : true
        inputAttributes = ['autocomplete' => 'off']}

        {component field template='hidden' name='agent_id' id='agent-id'}

        {component field template='text' name='price_agent' label='Цена' inputAttributes = ['autocomplete' => 'off']}

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
             * Поиск дизайна
             */
            $('.design-item.autocomplete-pro').autocompletePro({
                name: 'designs',
                url: ADMIN_URL+'product/ajax/design/search/',
                url_search: ADMIN_URL+'product/design/',
                render : function(obj){
                    var item =
                        '<div class="row" data-id="'+obj.id+'">' +
                        '<span>'+obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ': '')+'</span>'+
                        '</div>';
                    return item;
                }
            }, function(obj){
                $('.design-item.autocomplete-pro').val(obj.name);
                $('#design-id').val(obj.id);
            });
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