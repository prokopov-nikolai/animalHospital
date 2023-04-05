<div class="admin-fabric-list">
	{foreach $aData as $aFabric}
		<div class="pull-left admin-fabric load" data-info='{['fabric' => $aFabric, 'fabric_url'=> $aFabric.fabric_url]|json_encode}' id="">
			<div class="title">{$aFabric.title}</div>
		</div>
	{/foreach}
	<div class="cl"></div>
</div>
