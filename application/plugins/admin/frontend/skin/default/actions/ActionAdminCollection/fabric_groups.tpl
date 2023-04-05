{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
	{$sMenuSelect = 'fabric'}
{/block}

{block name='layout_content'}
	<h2 class="page-sub-header">Группы тканей</h2>
	{include file="{$aTemplatePathPlugin.admin}fabric/groups.list.tpl" }
	{foreach $aFabricMake as $oFM}
		<br>&nbsp;<br>
		<a href="{Config::Get('url_adm')}fabric/{$oFM->getMakeTitle()}/">{$oFM->getMakeTitle()}</a>
	{/foreach}
{/block}
