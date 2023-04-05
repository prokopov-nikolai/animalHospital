{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'coupon'}
{/block}

{block name='layout_content'}
    <h1>Купоны</h1>
    <form action="{$ADMIN_URL}coupon/" method="post" class="dflex">
        <div class="hide">
            {$value = mb_strtoupper(func_generator(4))}
            {component field template="datetime" name="date_time_start" label='Начало действия' classes="w200" inputAttributes=['autocomplete' => 'off']}
            {component field template="datetime" name="date_time_end" label='Окончание действия' classes="w200" inputAttributes=['autocomplete' => 'off']}
            {component field template="text" name="code" label="Код" note="Не больше 10 символов" value=$value}
            {component field template="text" name="sum" label="Сумма скидки" value=100}
        </div>
        <div class="cl"></div>
        {component button text='Добавить' mods="primary" id="coupon-add"}
    </form>
    <div class="cl h20"></div>
    <table class="table">
        <tr>
            <th>Код</th>
            <th>Начало</th>
            <th>Окончание</th>
            <th>Сумма</th>
            <th>Кол-во применений</th>
            <th></th>
        </tr>
        {foreach $coupons as $coupon}
            <tr>
                <td>{$coupon->getCode()}</td>
                <td>{$coupon->getDateTimeStart()|date_format:'d.m.Y H:i:s'}</td>
                <td>{$coupon->getDateTimeEnd()|date_format:'d.m.Y H:i:s'}</td>
                <td>{$coupon->getSum()}</td>
                <td>{$coupon->getAppliedCount()}</td>
                <td><a href="{$ADMIN_URL}coupon/delete/{$coupon->getCode()}/" class="ls-icon-remove"></a></td>

            </tr>
        {/foreach}
    </table>
{/block}

{block name='scripts'}
    <script>
		const couponAdd = $('#coupon-add')
		couponAdd.on('click', function (event) {
			if ($('.hide').length) {
				event.preventDefault();
				$('.hide').removeClass('hide');
				return false;
			}
		});
    </script>
{/block}
