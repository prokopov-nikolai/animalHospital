<div class="pull-left admin-fabric" id="fabric-{$oFabric->getId()}">
	{if $oFabric->getHide() == 1}<div style="position: absolute;
    width: 68%;
    background: rgba(255,255,255,.75);
    text-align: center;
    padding: 5px;">Выведена</div>{/if}
	{$aMedia = $oFabric->getMedia()}
	{if $aMedia}
		{$oMedia = $aMedia[0]}
		<a href="/{Config::Get('url_adm')}/fabric/edit/{$oFabric->getId()}/"><img src="{$oMedia->getFileWebPath('100crop')}" alt=""/><br>
	{/if}
	<div class="title">{$oFabric->getTitle()}</div>
	<a class="delete" href="#del-{$oFabric->getId()}" onclick="ls.plugin.shop.fabric.deleteFabric('{$oFabric->getTitle()}', {$oFabric->getId()}); return false;"></a>
</div>