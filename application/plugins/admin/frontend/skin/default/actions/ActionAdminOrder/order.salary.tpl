{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'order'}
    {$sMenuSelectSub = 'order_salary'}
{/block}

{block name='layout_head_end'}
    <style>
        tr.processing, .btn-processing, .order-status-processing {
            background: rgba(221, 221, 221, .4) !important;
        }

        tr.make, .btn-make, .order-status-make {
            background: #d9edf7 !important;
        }

        tr.delivered, .btn-delivered, .order-status-delivered {
            background: rgba(92, 184, 92, 0.4) !important;
        }

        tr.ring, .btn-ring, .order-status-ring {
            background: rgba(92, 184, 92, 0.4) !important;
        }

        tr.failure, .btn-failure, .order-status-failure {
            background: rgba(240, 173, 78, .4) !important;
        }

        tr.return, .btn-return, .order-status-return {
            background: rgba(217, 83, 79, .4) !important;
        }
    </style>
{/block}

{block name='layout_content'}
    <h2>Зарплата{if $sDateFrom} c {$sDateFrom} по {$sDateTo} // {GetSelectText($smarty.get.make_block, 'make_blocks')} // {GetSelectText($smarty.get.work_type, 'work_type')}{/if}</h2>
    {if !$smarty.get.print}
        <div class="cl h20"></div>
        <form action="" class="dflex">

            {component field template='date'
            label           = 'Начало периода'
            name            = 'date_from'
            classes         = 'w200'
            inputAttributes = ['style'=>'margin-right:15px;', 'autocomplete' => 'off']
            value           = $sDateFrom}

            {component field template='date'
            label           = 'Окончание периода'
            name            = 'date_to'
            classes         = 'w200'
            inputAttributes = ['style'=>'margin-right:15px;', 'autocomplete' => 'off']
            value           = $sDateTo}

            {component field template='select'
            label           = 'Цех'
            name            = 'make_block'
            items           = Config::Get('make_blocks')
            classes         = 'w200'
            attributes      = ['style'=>'margin-right:15px;']
            selectedValue   = $smarty.get.make_block}

            {component field template='select'
            label           = 'Работа'
            name            = 'work_type'
            items           = Config::Get('work_type')
            classes         = 'w200'
            attributes      = ['style'=>'margin-right:15px;']
            selectedValue   = $smarty.get.work_type}

            {component button text="Показать" attributes=['style'=>'margin-top:25px; right: -20px;']}
        </form>
    {/if}
    {include file="{$aTemplatePathPlugin.admin}order/salary.tpl"}

    {if $smarty.get.date_from && !$smarty.get.print}<a href="{$sCurrentPath}&print=1" target="_blank"
                                                       class="ls-button print-labels"><i class="ls-icon-print"></i>&nbsp;Печать
        </a>{/if}

{/block}



{block name='scripts' append}
    <script>
        $(function () {
        });
    </script>
{/block}