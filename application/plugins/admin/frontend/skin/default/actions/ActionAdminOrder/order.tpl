{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'order'}
    {$sMenuSelectSub = 'order_list'}
{/block}

{block name='layout_head_end'}
    <style>
        #wrapper.admin section .table.products tr td.make_id {
            padding: 0 5px;
            width: 140px;
        }
        #wrapper.admin section .table.products tr td.make_id .select-stylized {
            margin-left: -25px;
            width: 120px;
        }
        #wrapper.admin section .table.products tr td.make_id .select-stylized ._selected {
            text-align: left;
        }

        {foreach Config::Get('colors') as $aColor}
            {if $aColor.value != '-'}
                #wrapper.admin .order-content ._selected[data-value={$aColor.value}]:after {
                    background: {$aColor.color};
                }
                #wrapper.admin .order-content ._option[data-value={$aColor.value}]:after {
                    background: {$aColor.color};
                }
            {/if}
        {/foreach}
    </style>
{/block}

{block name='layout_content'}
    <div class="order-content">
        <h1>Заказ {$oOrder->getAgentNumber()} <span style="font-size: 14px;">{if $oOrder->getUserConfirm()}
                Подтвержден {$oOrder->getUserConfirmDate('d.m.Y')}
            {else}

                    <a href="{Config::Get('path.root.web')}/order/user/confirm/{$oOrder->getGuid()}/" target="_blank">Ссылка на подтвеждение</a>
                {/if}</span>
            {component field template='select'
            name            = 'color'
            items           = Config::Get('colors')
            selectedValue   = $oOrder->getColor()
            classes         = 'order-color'
            inputClasses    = 'color ajax-save'
            inputAttributes = ['data-field' => 'color']}
        </h1>
        {include file="{$aTemplatePathPlugin.admin}forms/order.tpl"}
    </div>
    {include file="{$aTemplatePathPlugin.admin}modal/modal.options.tpl"}

    {capture name="scripts"}
        <script>
            let iOrderId = {$oOrder->getId()};
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.scripts)}
{/block}

