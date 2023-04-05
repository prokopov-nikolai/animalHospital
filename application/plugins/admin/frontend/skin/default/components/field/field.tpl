{**
 * Базовый шаблон поля формы
 *
 * @param string  sName      Имя поля (параметр name)
 * @param string  sLabel     Текст лэйбла
 * @param string  sNote      Подсказка (отображается под полем)
 * @param string  aRules     Правила валидации
 *}

{* Название компонента *}
{$_sComponentName = 'field'}

{block 'field_options'}
	{* Уникальный ID *}
	{$_uid = $smarty.local.sId|default:($_sComponentName|cat:rand(0, 10e10))}

	{* Переменные *}
	{$_sMods = $smarty.local.sMods}
	{$_sValue = $smarty.local.sValue}
	{$_sInputClasses = $smarty.local.sInputClasses}
	{$_sInputAttributes = $smarty.local.sInputAttributes}
	{$_aRules = $smarty.local.aRules|default:[]}
	{$name = $smarty.local.sName}
	{$label = $smarty.local.sLabel}
{/block}

{* Правила валидации *}
{if $smarty.local.sEntity}
	{field_make_rule entity=$smarty.local.sEntity field=$smarty.local.sEntityField|default:$name scenario=$smarty.local.sEntityScenario assign=_aRules}
{/if}

{**
 * Получение значения атрибута value
 *}
{function field_input_attr_value}
{strip}
	{if $_sValue}
		{$_sValue}
	{elseif isset($_aRequest[$name])}
		{$_aRequest[$name]}
	{/if}
{/strip}
{/function}

{**
 * Общие атрибуты
 *}
{function field_input_attr_common bUseValue=true}
	id="{$_uid}{$uid}"
	class="{$_sComponentName}{$component}-input {$_sInputClasses}"
	{if $bUseValue}value="{field_input_attr_value}"{elseif $useValue}value="{$value}"{/if}
	{if $name}name="{$name}"{/if}
	{if $smarty.local.sPlaceholder}placeholder="{$smarty.local.sPlaceholder}"{/if}
	{if $smarty.local.bIsDisabled}disabled{/if}
	{if $isDisabled}disabled{/if}
	{foreach $_aRules as $sRule}
		{if is_bool( $sRule@value ) && ! $sRule@value}{continue}{/if}

		data-{$sRule@key}="{$sRule@value}"
	{/foreach}
	{$_sInputAttributes}
	{foreach $rules as $rule}
		{if is_bool( $rule@value ) && ! $rule@value}
			{continue}
		{/if}

		{if $rule@key === 'remote'}
			data-parsley-remote-validator="{$rules['remote-validator']|default:'livestreet'}"
			data-parsley-trigger="focusout"

			{* Default remote options *}
			{$json = [ 'type' => 'post', 'data' => [ 'security_ls_key' => $LIVESTREET_SECURITY_KEY ] ]}

			{if array_key_exists('remote-options', $rules)}
				{$json = array_merge_recursive($json, $rules['remote-options'])}
			{/if}

			data-parsley-remote-options='{json_encode($json)}'
		{/if}

		{if $rule@key === 'remote-options'}
			{continue}
		{/if}

		data-parsley-{$rule@key}="{$rule@value}"
	{/foreach}
	{cattr list=$inputAttributes}
	{cdata name=$component|cat:$_sComponentName list=$inputData}
{/function}


{block 'field'}
	<div class="{$_sComponentName} {mod name=$_sComponentName mods=$_sMods} clearfix {$smarty.local.sClasses} {block 'field_classes'}{/block}" {$smarty.local.sAttributes}>
		{* Лэйбл *}
		{if $label && $_sMods != ' checkbox'}
			<label for="{$_uid}" class="{$_sComponentName}-label">{$label}</label>
		{/if}

		{* Блок с инпутом *}
		<div class="{$_sComponentName}-holder">
			{block 'field_input'}{/block}
			{if $label && $_sMods == ' checkbox'}
				<label for="{$_uid}" class="{$_sComponentName}-label">{$label}</label>
			{/if}
		</div>

		{* Подсказка *}
		{if $smarty.local.sNote}
			<small class="{$_sComponentName}-note js-{$_sComponentName}-note">{$smarty.local.sNote}</small>
		{/if}
	</div>
{/block}