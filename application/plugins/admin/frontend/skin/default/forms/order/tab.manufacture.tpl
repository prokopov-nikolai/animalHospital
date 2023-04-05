<div class="dflex">
    <div class="block w1">
        <table class="table products manufacture rtable">
            <tr>
                <th width="20" rowspan="2">#</th>
                <th class="title" rowspan="2">Наименование</th>
                <th colspan="4">Ткани</th>
                <th colspan="4">Зар. плата</th>
            <tr>
                <th>Основ.</th>
                <th class="ta-c">Комп-н</th>
                <th>3-я</th>
                <th>4-я</th>
                <th>Столяры</th>
                <th>Швеи</th>
                <th>Драп-ки</th>
            </tr>
            {foreach from=$oOrder->getProducts() item='oOrderProduct' name="products"}
                <tr class="order-product" data-product-design-id="{$oOrderProduct->getProductDesignId()}">
                    <td class="number" rowspan="2">{$smarty.foreach.products.index+1}</td>
                    <td class="title" rowspan="2">
                        {$oOrderProduct->getTitle()}
                    </td>
                    <td>
                        {if $oFabric = $oOrderProduct->getFabric(1)}
                            {$oFabric->getAlt()} ({$oFabric->getSupplier()}):
                        {/if}
                    </td>
                    <td>
                        {if $oFabric = $oOrderProduct->getFabric(2)}
                            {$oFabric->getAlt()} ({$oFabric->getSupplier()}):
                        {/if}
                    </td>
                    <td>
                        {if $oFabric = $oOrderProduct->getFabric(3)}
                            {$oFabric->getAlt()} ({$oFabric->getSupplier()}):
                        {/if}
                    </td>
                    <td>
                        {if $oFabric = $oOrderProduct->getFabric(4)}
                            {$oFabric->getAlt()} ({$oFabric->getSupplier()}):
                        {/if}
                    </td>
                    <td class="w200">
                        {component field template='select'
                        items           = Config::Get('make_blocks')
                        name            = "order_products[{$oOrderProduct->getProductId()}][stolyary]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'stolyary']
                        selectedValue   = $oOrderProduct->getStolyary()}
                    </td>
                    <td class="w200">
                        {component field template='select'
                        items           = Config::Get('make_blocks')
                        name            = "order_products[{$oOrderProduct->getProductId()}][shvei]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'shvei']
                        selectedValue   = $oOrderProduct->getShvei()}
                    </td>
                    <td class="w200">
                        {component field template='select'
                        items           = Config::Get('make_blocks')
                        name            = "order_products[{$oOrderProduct->getProductId()}][drapera]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'drapera']
                        selectedValue   = $oOrderProduct->getDrapera()}
                    </td>
                </tr>
                <tr class="order-product" data-product-design-id="{$oOrderProduct->getProductDesignId()}">
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}][fabric1]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'fabric1']
                        value           = $oOrderProduct->getFabric1()}
                    </td>
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}][fabric2]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'fabric2']
                        value           = $oOrderProduct->getFabric2()}
                    </td>
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}][fabric3]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'fabric3']
                        value           = $oOrderProduct->getFabric3()}
                    </td>
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}][fabric4]"
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'fabric4']
                        value           = $oOrderProduct->getFabric4()}
                    </td>
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}]product[stolyary_price]"
                        value           = $oOrderProduct->getStolyaryPrice()
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'stolyary_price']}
                    </td>
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}]product[shvei_price]"
                        value           = $oOrderProduct->getShveiPrice()
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'shvei_price']}
                    </td>
                    <td>
                        {component field template='text'
                        name            = "order_products[{$oOrderProduct->getProductId()}]product[drapera_price]"
                        value           = $oOrderProduct->getDraperaPrice()
                        inputClasses    = 'ajax-save'
                        inputAttributes = ['data-field' => 'drapera_price']}
                    </td>
                </tr>
            {/foreach}
        </table>
    </div>
</div>