{**
 * Выбор даты
 *
 * TODO: Заменить на datepicker
 *}

{extends './field.tpl'}

{block 'field_input'}
    <select name="{$smarty.local.sName}_day">
        <option value="">{$aLang.date_day}</option>

        {section name=date_day start=1 loop=32 step=1}
            <option value="{$smarty.section.date_day.index}" {if $smarty.section.date_day.index == $aItems|date_format:"%d"}selected{/if}>{$smarty.section.date_day.index}</option>
        {/section}
    </select>

    <select name="{$smarty.local.sName}_month" class="width-150">
        <option value="">{$aLang.date_month}</option>

        {section name=date_month start=1 loop=13 step=1}
            <option value="{$smarty.section.date_month.index}" {if $smarty.section.date_month.index == $aItems|date_format:"%m"}selected{/if}>{$aLang.month_array[$smarty.section.date_month.index][0]}</option>
        {/section}
    </select>

    <select name="{$smarty.local.sName}_year">
        <option value="">{$aLang.date_year}</option>

        {section name=date_year loop=$smarty.now|date_format:"%Y"+1 max=$smarty.now|date_format:"%Y"-2012+130 step=-1}
            <option value="{$smarty.section.date_year.index}" {if $smarty.section.date_year.index == $aItems|date_format:"%Y"}selected{/if}>{$smarty.section.date_year.index}</option>
        {/section}
    </select>
{/block}