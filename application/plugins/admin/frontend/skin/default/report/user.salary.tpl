<table class="table report-cost">
    <tr>
        <td>Дневных смен</td>
        <td>{$userWorkdaysCount[$managerId]['morning']} * 500</td>
    </tr>
    {$managerSalary = $managerSalary + $userWorkdaysCount[$managerId]['morning'] * 500}

    <tr>
        <td>Вечерних смен</td>
        <td>
            {if $userWorkdaysCount[$managerId]['evening']}
                {$userWorkdaysCount[$managerId]['evening']} * 700
            {else}
                -
            {/if}
        </td>
    </tr>
    {$managerSalary = $managerSalary + $userWorkdaysCount[$managerId]['evening'] * 700}

    <tr>
        <td>Выходных смен</td>
        <td>{if $userWorkdaysCount[$managerId]['day-off']}
                {$userWorkdaysCount[$managerId]['day-off']} * 900
            {else}
                -
            {/if}
        </td>
    </tr>

    {$managerSalary = $managerSalary + $userWorkdaysCount[$managerId]['day-off'] * 900}

    {* Расчитаем коэффифциент выполнения персонального плана *}
    {$d = round($marginManager/$marginPlanManager*100)}
    {* Прогноз *}
    {$d1 = round(($marginManager/$dayCurrent*$daysMonth)/$marginPlanManager*100)}
    {if $d1 >= 100}
        {$k = 0.05}
        {$class = 'green'}
    {elseif 85 <=$d1 &&  $d1 < 100}
        {$k = 0.04}
        {$class = 'light-red'}
    {elseif 70 <=$d1 &&  $d1 < 85}
        {$k = 0.03}
        {$class = 'red'}
    {elseif $d1 < 70}
        {$k = 0.02}
        {$class = 'red'}
    {/if}
    <tr>
        <td{if LS::Adm()} title="k = {$k}"{/if}>Выполнение личного план
            <span class="margin-plan {$class}">{$d}% {if $viewCurrentMonth}({$d1}%){/if} (k={$k})</span>
        </td>
        <td>{GetPrice($marginManager * $k, 1)} {if $viewCurrentMonth}({GetPrice($marginManager/$dayCurrent*$daysMonth*$k, 1)}){/if}</td>
    </tr>

    {$managerSalaryPrognoz = $managerSalary + $marginManager/$dayCurrent*$daysMonth*$k}
    {$managerSalary = $managerSalary + $marginManager * $k}

    {* Расчитаем коэффифциент выполнения общего плана *}
    {$c = round($marginCommon/$marginPlan*100)}
    {* Прогноз *}
    {$c1 = round(($marginCommon/$dayCurrent*$daysMonth)/$marginPlan*100)}
    {if $c1 >= 100}
        {$k = 0.05}
        {$class = 'green'}
    {elseif 85 <=$c1 &&  $c1 < 100}
        {$k = 0.04}
        {$class = 'light-red'}
    {elseif 70 <=$c1 &&  $c1 < 85}
        {$k = 0.03}
        {$class = 'red'}
    {elseif $c1 < 70}
        {$k = 0.02}
        {$class = 'red'}
    {/if}
    <tr{if LS::Adm()} title="k = {$k}"{/if}>
        <td>Выполнение общего план  <span class="margin-plan {$class}">{$c}% {if $viewCurrentMonth}({$c1}%){/if} (k={$k})</span></td>
        <td>{GetPrice($marginCommon * $k / 3, 1)} {if $viewCurrentMonth}({GetPrice($marginCommon/$dayCurrent*$daysMonth*$k/3, 1)}){/if}</td>
    </tr>
    {$managerSalary = $managerSalary + $marginCommon * $k / 3}
    {$managerSalaryPrognoz = $managerSalaryPrognoz + $marginCommon/$dayCurrent*$daysMonth*$k/3}

    {if $managerPremium|count}
        {foreach $managerPremium as $work => $payment}
            <tr>
                <td>{$work}</td>
                <td>{GetPrice($payment, 1)}</td>
            </tr>
            {$managerSalary = $managerSalary + $payment}
            {$managerSalaryPrognoz = $managerSalaryPrognoz + $payment}
        {/foreach}
    {else}
        <tr>
            <td>Премиальная часть за другие работы</td>
            <td>-</td>
        </tr>
    {/if}
    <tr>
        <th>ИТОГО</th>
        <th>{$managerSalary|GetPrice:1} {if $viewCurrentMonth}({$managerSalaryPrognoz|GetPrice:1}){/if}</th>
    </tr>
    <tr>
        <td>Личный план (факт)</td>
        <td>{$marginPlanManager|GetPrice:1} ({GetPrice($marginManager, 1)})</td>
    </tr>
    <tr>
        <td>Общий план (факт)</td>
        <td>{$marginPlan|GetPrice:1} ({GetPrice($marginCommon, 1)})</td>
    </tr>
</table>