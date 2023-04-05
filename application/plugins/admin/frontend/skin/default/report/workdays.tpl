<div class="workdays" style="grid-template-columns: 100px repeat({$daysMonth}, 30px); width: {(102 + $daysMonth * 31)}px;">
    <div class="month">{$monthItems[0]['text']}</div>
    {for $d = 1; $d <= $daysMonth; $d++}
        <div class="number{if $currentWeekday == 0 || $currentWeekday == 6} day-off{/if}{if $d == $dayCurrent} current{/if}">
            <div class="weekday">{$weekdays[$currentWeekday]}</div>
            {$d}
        </div>
        {$currentWeekday = ($currentWeekday + 1) % 7}
    {/for}
    {foreach $managerItems as $manager}
        {if in_array($manager.value, [19, 20, 1301])}
            <div class="manager" title="{$manager.value}">{$manager.text}</div>
            {for $d = 1; $d <= $daysMonth; $d++}
                <div class="day {if $userWorkdays[$manager.value][$d]}{$userWorkdays[$manager.value][$d]}{/if}" data-num="{$d}" data-manager_id="{$manager.value}"></div>
            {/for}
        {/if}
    {/foreach}

</div>

<div class="cl h20"></div>
<input type="radio" name="type" value="morning" checked><span class="day morning">День</span> &nbsp;
<input type="radio" name="type" value="evening"><span class="day evening">Вечер</span> &nbsp;
<input type="radio" name="type" value="day-off"><span class="day day-off">Рабочий вых. день</span> &nbsp;
<input type="radio" name="type" value="delete"><span class="day delete">Удалить</span> &nbsp;
<span>Выходной день, когда не работает сотрудник - белый</span>

{capture name="scripts"}}
    <script>
        $(function(){
          $('.workdays .day').on('click', function(e){
            e.stopPropagation();
            const type = $('input[name="type"]:checked').val(),
            day = $(this);
            const  workDay = {
              user_id: day.data('manager_id'),
              num: day.data('num'),
              type: type,
              date_start: '{$monthItems[0].value}'
            }
            ls.ajax.load(ADMIN_URL+'user/ajax/workday/', { work_day: workDay }, function(answ){
              if (answ.bStateError == false) {
                day.attr('class', 'day '+type);
              }
            })
          });
          $('.workdays .day').on('contextmenu', function(e){
            e.stopPropagation();
            console.log('правая кнопка мыши');
            return false;
          });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}