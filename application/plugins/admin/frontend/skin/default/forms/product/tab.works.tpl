<table class="table manufacture">
    <tr>
        <th class="work-title" width="100">Столярка</th>
        <td class="work-block">
            {component field template='select'
            items           = Config::Get('make_blocks')
            name            = 'product[stolyary]'
            selectedValue   = $oProduct->getStolyary()}
        </td>
        <td class="work-price">
            {component field template='text'
            name            = 'product[stolyary_price]'
            value           = $oProduct->getStolyaryPrice()
            attributes = ['style' => 'width: 100px; display: inline-block;']}
            руб.
        </td>
    </tr>
    <tr>
        <th class="work-title" width="100">Швейка</th>
        <td class="work-block">
            {component field template='select'
            items           = Config::Get('make_blocks')
            name            = 'product[shvei]'
            selectedValue   = $oProduct->getShvei()}
        </td>
        <td class="work-price">
            {component field template='text'
            name            = 'product[shvei_price]'
            value           = $oProduct->getShveiPrice()
            attributes = ['style' => 'width: 100px; display: inline-block;']}
            руб.
        </td>
    </tr>
    <tr>
        <th class="work-title" width="100">Драпировка</th>
        <td class="work-block">
            {component field template='select'
            items           = Config::Get('make_blocks')
            name            = 'product[drapera]'
            selectedValue   = $oProduct->getDrapera()}
        </td>
        <td class="work-price">
            {component field template='text'
            name            = 'product[drapera_price]'
            value           = $oProduct->getDraperaPrice()
            attributes = ['style' => 'width: 100px; display: inline-block;']}
            руб.
        </td>
    </tr>
</table>

<style>
    .work-title {
        font-size: 15px;
        padding: 20px 0 0 10px!important;
    }
    .work-block {
        padding: 5px!important;
    }
    .work-price {
        padding: 13px 0 0 10px!important;
    }
</style>