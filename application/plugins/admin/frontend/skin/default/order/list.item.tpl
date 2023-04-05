<div class="_order short" data-id="{$oOrder->getId()}" data-price="{$oOrder->getPrice()}" data-agent_commission="{$oOrder->getAgentCommission()-$oOrder->getDiscount()}">
    <div class="row-1">
        <a href="{$ADMIN_URL}order/{$oOrder->getId()}/" class="number">{$oOrder->getAgentNumber()}</a>
        <div class="agent-commission{if !LS::HasRight('38_order_margin_view')} hide{/if}{if $oOrder->getMargin() < 2000} red bg-red{/if}">{($oOrder->getAgentCommission()-$oOrder->getDiscount())|GetPrice:true:true}</div>
        <div class="manager">
            {if $oManager = $oOrder->getManager()}
                <img src="{$oManager->getPhotoWebPath('40x40crop')}" alt="">
            {/if}
        </div>
        <div class="color">
            {component field template='select'
            name            = 'color'
            items           = Config::Get('colors')
            selectedValue   = $oOrder->getColor()
            inputClasses    = 'color ajax-save'
            inputAttributes = ['data-field' => 'color']}
        </div>
        <div class="move"></div>
        {foreach $oOrder->getProducts() as $oOrderProduct}
            {if $oOrderProduct->getMakePaid()}
                <div class="make-paid"></div>
            {/if}
        {/foreach}
    </div>
    <div class="row-2">
        <div class="fio">{$oOrder->getUserFio()}</div>
        <a href="https://wa.me/7{$oOrder->getUserPhone()}" class="phone">{$oOrder->getUserPhone(true)}</a>
    </div>
    <div class="row-2">
        <div class="delivery" data-tooltip="{$oOrder->getAddress()}">Доставка</div>
        <div class="delivery" data-tooltip="{GetSelectText($oOrder->getCarNumber(),'car_number')}">{$oOrder->getDateDelivery()}</div>
    </div>
    <div class="row-3 products">
        {foreach $oOrder->getProducts() as $oOrderProduct}
            <div class="product{if !$oOrderProduct->getMakeId()} _error{/if}">
                <div class="name">
                    {$oOrderProduct->getProductTitleFull()}<br>

                </div>
                <div class="make">{$oOrderProduct->getMakeTitle()}</div>
            </div>
        {/foreach}
    </div>
    <div class="row-4">
        <textarea name="comment" class="comment" rows="1" placeholder="Комментарий">{$oOrder->getLastCommentText()}</textarea>
    </div>
    <div class="row-5">
        <span class="time-left">{$oOrder->getTimeLeftInCurrentStatus()}</span>
        {$tasks = $oOrder->getTasksNotDone()}
        {$task = ''}
        {if count($tasks)}
            {$task = array_shift($tasks)}
        {/if}
        {$iTC = count($oOrder->getTasksNotDone())}
        <span class="bell{if $iTC > 0} active{/if}" data-order-id="{$oOrder->getId()}"{if $task} data-tooltip="{$task->getDateTimeFormat()} &nbsp;#&nbsp; {$task->getText()}"{/if}>{if $iTC}({$iTC}){/if}</span>
        {if $oOrder->getCarNumber()}
            <span class="delivery-car" data-tooltip="{GetSelectText($oOrder->getCarNumber(),'car_number')}"></span>
        {/if}
        <div class="drop-down"></div>
    </div>
</div>