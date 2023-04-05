{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$bNoSystemMessages = true}
{/block}

{block name='layout_page_title'}
	{if $aMsgError[0].title}
		{$aLang.error}: <span>{$aMsgError[0].title}</span>
	{/if}
{/block}

{block name='layout_content'}
	<p>Ошибка 404</p>
{/block}