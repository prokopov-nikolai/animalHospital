Расчет зарпалаты за {$dateStart->format('m.Y')}

{$managerSalary = 0}
<b>Дневных смен:</b>{$userWorkdaysCount[$managerId]['morning']} * 500 ={GetPrice($userWorkdaysCount[$managerId]['morning']*500, 1 ,1)} {$managerSalary = $managerSalary + $userWorkdaysCount[$managerId]['morning'] * 500}

<b>Вечерних смен:</b> {if $userWorkdaysCount[$managerId]['evening']} {$userWorkdaysCount[$managerId]['evening']} * 700 = {GetPrice($userWorkdaysCount[$managerId]['evening']*700, 1, 1)} {else} - {/if}{$managerSalary = $managerSalary + $userWorkdaysCount[$managerId]['evening'] * 700}

<b>Выходных смен:</b> {if $userWorkdaysCount[$managerId]['day-off']} {$userWorkdaysCount[$managerId]['day-off']} * 900 = {GetPrice($userWorkdaysCount[$managerId]['day-off']*900, 1, 1)}{else} - {/if}{$managerSalary = $managerSalary + $userWorkdaysCount[$managerId]['day-off'] * 900}


{* Расчитаем коэффифциент выполнения персонального плана *}{$d = round($marginManager/$marginPlanManager*100)}{* Прогноз *}{$d1 = round(($marginManager/$dayCurrent*$daysMonth)/$marginPlanManager*100)}{if $d1 >= 100}{$k = 0.05}{$class = 'green'}{elseif 85 <=$d1 &&  $d1 < 100}{$k = 0.04}{$class = 'light-red'}{elseif 70 <=$d1 &&  $d1 < 85}{$k = 0.03}{$class = 'red'}{elseif $d1 < 70}{$k = 0.02}{$class = 'red'}{/if}
Выполнение личного план (прогноз):
{$d}% {if $viewCurrentMonth}({$d1}%){/if} ({$k}) // {GetPrice($marginManager * $k, 1, 1)}{if $viewCurrentMonth} ({GetPrice($marginManager/$dayCurrent*$daysMonth*$k, 1, 1)}){/if}{$managerSalaryPrognoz = $managerSalary + $marginManager/$dayCurrent*$daysMonth*$k}{$managerSalary = $managerSalary + $marginManager * $k}


{* Расчитаем коэффифциент выполнения общего плана *}{$c = round($marginCommon/$marginPlan*100)}{* Прогноз *}{$c1 = round(($marginCommon/$dayCurrent*$daysMonth)/$marginPlan*100)}{if $c1 >= 100}{$k = 0.05}{$class = 'green'}{elseif 85 <= $c1 &&  $c1 < 100}{$k = 0.04}{$class = 'light-red'}{elseif 70 <= $c1 &&  $c1 < 85}{$k = 0.03}{$class = 'red'}{elseif $c1 < 70}{$k = 0.02}{$class = 'red'}{/if}
Выполнение общего план (прогноз):
{$c}% {if $viewCurrentMonth}({$c1}%){/if} ({$k})// {GetPrice($marginCommon * $k / 3, 1, 1)}{if $viewCurrentMonth} ({GetPrice($marginCommon/$dayCurrent*$daysMonth*$k/3, 1, 1)}){/if}{$managerSalary = $managerSalary + $marginCommon * $k / 3}{$managerSalaryPrognoz = $managerSalaryPrognoz + $marginCommon/$dayCurrent*$daysMonth*$k/3}


{if $managerPremium|count}
{foreach $managerPremium as $work => $payment}
{$work}: {GetPrice($payment, 1, 1)}{$managerSalary = $managerSalary + $payment}{$managerSalaryPrognoz = $managerSalaryPrognoz + $payment}

{/foreach}
{else}
Премиальная часть за другие работы: -
{/if}

<b>ИТОГО:</b> {GetPrice($managerSalary, 1, 1)}{if $viewCurrentMonth} ({GetPrice($managerSalaryPrognoz, 1, 1)}){/if}


Личный план (факт): {GetPrice($marginPlanManager, 1, 1)} ({GetPrice($marginManager, 1, 1)})
Общий план (факт): {GetPrice($marginPlan|GetPrice, 1, 1)} ({GetPrice($marginCommon, 1, 1)})