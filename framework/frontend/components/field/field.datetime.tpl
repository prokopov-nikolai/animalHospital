{**
 * Выбор даты
 *}

{extends 'component@field.text'}

{block 'field_options' append}
    {$mods = "$mods datetime"}
{/block}