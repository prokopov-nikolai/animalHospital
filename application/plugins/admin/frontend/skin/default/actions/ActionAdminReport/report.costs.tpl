{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_head_end'}
    <style>
        @media print {
            @page {
                size:portrait;
            }
        }
    </style>
{/block}

{block name='layout_options'}
    {$sMenuSelect = 'report'}
    {$sMenuSelectSub = 'report_costs'}
{/block}

{block name='layout_content'}
    <h1>{$aLang.plugin.admin.menu.report_costs} - {$months[$dateStart->format('n')]}</h1>
    {include file="{$aTemplatePathPlugin.admin}report/filter.costs.tpl"}

    {component button text='Добавить' id='modal-cost-show'  mods='primary'}
    <div class="cl h20"></div>

    {include file="{$aTemplatePathPlugin.admin}report/costs.list.tpl"}
    {include file="{$aTemplatePathPlugin.admin}modal/modal.cost.tpl"}
{/block}


{block name='scripts' append}
    <script>
        $(function () {
            $('#modal-cost-show').on('click', function(){
                ModalShow($('#modal-cost'));
            });

            $('.cost-delete').on('click', function(){
                if (confirm('Уверены?')) {
                    let id = $(this).data('id');
                    ls.ajax.load(ADMIN_URL+'cost/ajax/delete', { id : id }, function (answer) {
                        if (answer.bStateError == false) {
                            window.location.reload();
                        }
                    });
                }
            });
        });
    </script>
{/block}
