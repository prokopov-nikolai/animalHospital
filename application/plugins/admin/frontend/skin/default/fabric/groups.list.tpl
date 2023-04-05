{foreach $aFabricGroup as $oGroup}
<ul>
	<li><a href="/{Config::Get('url_adm')}/fabric/{$oGroup->getId()}/">{$oGroup->getTitle()} (+{$oGroup->getMargin()} руб.)</a></li>
</ul>
{/foreach}