<input type="hidden" id="product_id" value="{$oProduct->getId()}">
<div class="product-info">
	{$oOrderProduct = $oProduct->_getManyToManyRelationEntity()}
	{if !$bOrder}<a href="#del-{$oProduct->getId()}" class="product-del red pull-right" data-product-id="{$oProduct->getId()}"><i></i><span>Удалить позицию</span></a>{/if}
	<div class="row product product-{$oProduct->getId()}">
		<div class="col-sm-3">
			<a href="{$oProduct->getUrlFull()}" class="thumb">
				<span class="img-wrap">
					<span class="img {if !bOrder}{$oProduct->getMainPhotoPath('300x')|SizeClass:263:144}{else}{$oProduct->getMainPhotoPath('300x')|SizeClass:178:144}{/if}"><img src="{$oProduct->getMainPhotoPath('300x')}" alt=""></span>
				</span>
			</a>
			<div class="row params">
				<div class="cols-sm-6">
					<span class="char">
						<span class="title grey">Габаритные<br>размеры:</span>
						<span class="value black">
							<i class="icon-size pull-left"></i>
							{$oChar = $oProduct->getCharByTitle('Габариты (Ширина)')}
							{$oChar->getValue()} {$oChar->getUnit()} x
							{$oChar = $oProduct->getCharByTitle('Габариты (Глубина)')}
							{$oChar->getValue()} {$oChar->getUnit()}
						</span>
					</span>
				</div>
				<div class="cols-sm-6">
					<span class="char">
						{if $oChar = $oProduct->getCharByTitle('Спальное место (Ширина)')}
						<span class="title grey">Спальное<br>место:</span>
						<span class="value black">
							<i class="icon-size-sleep pull-left"></i>
							{$oChar = $oProduct->getCharByTitle('Спальное место (Ширина)')}
							{$oChar->getValue()} {$oChar->getUnit()}<br>
							{$oChar = $oProduct->getCharByTitle('Спальное место (Глубина)')}
							{$oChar->getValue()} {$oChar->getUnit()}
						</span>
						{/if}
					</span>
				</div>
				{if $oOrderProduct->getProductDesign()}
					<div class="cols-sm-6">
						Дизайн: <a href="{Config::Get('url_adm')}product/{$oOrderProduct->getProductId()}/#8">№{$oOrderProduct->getProductDesign()}</a>
					</div>
				{/if}
			</div>
		</div>
		<div class="col-sm-5">
			<a href="{$oProduct->getUrlFull()}" class="product-title purple">{$oProduct->getNameFull()}</a>
			<div class="descr">{$oProduct->getText()|Short:250}</div>
			<div class="row fabrics user-fabric">
				<div class="col-sm-12">
					{$oFabric1 = $oProduct->getFabric(1)}
					{$aM = ($oFabric1) ? $oFabric1->getMedia(): null}
					{if $aM}
						{$oFabric1Media = $aM[0]}
					{/if}
					{$oFabric2 = $oProduct->getFabric(2)}
					{$aM = ($oFabric2) ? $oFabric2->getMedia(): null}
					{if $aM}
						{$oFabric2Media = $aM[0]}
					{/if}
					<div class="user-fabric">
						<div class="fabric fabric_1 fabric_1_{$oProduct->getId()}{if $oFabric1Media} active{/if}">
							<a
									href="#fabrics/{if $oFabric1}{$oFabric1->getGroupId()}//{$oFabric1->getId()}{/if}"
									class="img"
									style="background: {if $oFabric1}url({$oFabric1Media->getFileWebPath('100crop')}) center center no-repeat{else} url('/application/frontend/skin/kypitdivan/assets/image/zalivka.gif'){/if};"
									{if $oFabric1}data-group-id="{$oFabric1->getGroupId()}"{/if}
									{if $oFabric1}data-fabric-type="{$oFabric1->getTypeTitle()|translit}"{/if}
									{if $oFabric1}data-fabric-id="{$oFabric1->getId()}"{/if}>{if !$oFabric1}Кликните, чтобы выбрать ткань{/if}</a>
							Основная ткань
							<div class="title">{if $oFabric1}{$oFabric1->getGroupTitle()} категория: <br>{$oFabric1->getTitle()} / {$oFabric1->getCollectionTitle()} ({$oFabric1->getId()}){/if}</div>
							<a class="edit" href="#edit">Изменить ткань</a>
						</div>
						<div class="fabric fabric_2 fabric_2_{$oProduct->getId()}{if $oFabric2Media} active{/if}">
							<a
									href="#fabrics/{if $oFabric2}{$oFabric2->getGroupId()}//{$oFabric2->getId()}{/if}"
									class="img"
									style="background: {if $oFabric2}url({$oFabric2Media->getFileWebPath('100crop')}) center center no-repeat{else} url('/application/frontend/skin/kypitdivan/assets/image/zalivka.gif'){/if};"
									{if $oFabric2}data-group-id="{$oFabric2->getGroupId()}"{/if}
									{if $oFabric2}data-fabric-type="{$oFabric2->getTypeTitle()|translit}"{/if}
									{if $oFabric2}data-fabric-id="{$oFabric2->getId()}"{/if}>{if !$oFabric2}Кликните, чтобы выбрать ткань{/if}</a>
							Ткань-компаньон
							<div class="title">{if $oFabric2}{$oFabric2->getGroupTitle()} категория: <br>{$oFabric2->getTitle()} / {$oFabric2->getCollectionTitle()} ({$oFabric2->getId()}){/if}</div>
							<a class="del" href="#del">Удалить ткань</a>
						</div>
					</div>
					<br>
					<button class="button save_fabrics" data-order_id="{$oOrder->getId()}" data-product_id="{$oProduct->getId()}">Сохранить ткани</button>

				</div>
				<div class="cl"></div>
				<div class="col-sm-6 dop">
					<div class="fabric_3_4">
						{$oFabric3 = $oProduct->getFabric(3)}
						{$aM = ($oFabric3) ? $oFabric3->getMedia(): null}
						{if $aM}
							{$oFabric3Media = $aM[0]}
						{/if}
						<div class="fabric_3 {if !$oFabric3} empty{/if}">
							<div class="group">{if $oFabric3}{$oFabric3->getGroupTitle()}{else}&nbsp;{/if}</div>
							<a href="#fabrics/{if $oFabric3}{$oFabric3->getGroupId()}/{$oFabric3->getTypeTitle()|translit}/{$oFabric3->getId()}{/if}" class="img  js-modal-toggle-fabrics" data-product-block="false" data-choose="false" data-dop-button="false" data-fabric-id="{if $oFabric3}{$oFabric3->getId()}{/if}" data-product-id="{$oProduct->getId()}" style="background: {if $oFabric3}url({$oFabric3Media->getFileWebPath('100crop')}){else}none{/if} center center no-repeat;">{if !$oFabric3}<span class="title">Нет</span>{/if}</a>
							{if $oFabric3}<p class="title">{$oFabric3->getTitle()}</p>{/if}
						</div>
						{$oFabric4 = $oProduct->getFabric(4)}
						{$aM = ($oFabric4) ? $oFabric4->getMedia(): null}
						{if $aM}
							{$oFabric4Media = $aM[0]}
						{/if}
						<div class="fabric_4 {if !$oFabric4} empty{/if}">
							<div class="group">{if $oFabric4}{$oFabric4->getGroupTitle()}{else}&nbsp;{/if}</div>
							<a href="#fabrics/{if $oFabric4}{$oFabric4->getGroupId()}/{$oFabric4->getTypeTitle()|translit}/{$oFabric4->getId()}{/if}" class="img  js-modal-toggle-fabrics" data-product-block="false" data-choose="false" data-dop-button="false" data-fabric-id="{if $oFabric4}{$oFabric4->getId()}{/if}" data-product-id="{$oProduct->getId()}" style="background: {if $oFabric4}url({$oFabric4Media->getFileWebPath('100crop')}){else}none{/if} center center no-repeat;">{if !$oFabric4}<span class="title">Нет</span>{/if}</a>
							{if $oFabric4}<p class="title">{$oFabric4->getTitle()}</p>{/if}
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-sm-2 opts">
			<div class="grey">Дополнительно:</div>
			{$iI = 0}
			{if $iW = $oOrderProduct->getOptVal('length')}
				{$oChar = $oProduct->getCharByTitle('Ширина')}
				<div class="opt">
				{($iW > 0) ? 'Увеличить' : 'Уменьшить'} ширину:<br>
				{($oChar->getValue()+$iW)} {$oChar->getUnit()} ({($iW > 0) ? '+' : ''}{$iW})<br>
				<div class="price purple">+ {($iW/10*(($iW > 0) ? 800 : -500))|GetPrice:true} <span class="rubl">P<span class="line purple"></span></span></div>
				</div>{$iI=$iI+1}
			{/if}
			{if $iW = $oOrderProduct->getOptVal('width')}
				{$oChar = $oProduct->getCharByTitle('Глубина')}
				<div class="opt">
					{($iW > 0) ? 'Увеличить' : 'Уменьшить'} глубину:<br>
					{($oChar->getValue()+$iW)} {$oChar->getUnit()} ({($iW > 0) ? '+' : ''}{$iW})
					<div class="price purple">+ {($iW/10*(($iW > 0) ? 800 : -500))|GetPrice:true} <span class="rubl">P<span class="line purple"></span></span></div>
				</div>{$iI=$iI+1}
			{/if}

			{if $oOrderProduct->getOptVal('corner')}
				<div class="opt">Угол: {($oOrderProduct->getOptVal('corner') == 'right') ? 'правый' : 'левый'}</div>{$iI=$iI+1}
			{elseif $oOrderProduct->getOptVal('corner')}
				<div class="opt">Угол: левый</div>{$iI=$iI+1}
			{/if}

			{foreach $aOption as $oOpt}
				{if !in_array($oOpt->getId(), array('corner', 'fabric_1', 'fabric_2', 'fabric_3', 'fabric_4')) && $oOrderProduct->getOptVal($oOpt->getId())}
					<div class="opt">
					{$oOpt->getAlias()}
					<div class="price purple">+ {$oOpt->getPrice(true)} <span class="rubl">P<span class="line purple"></span></span></div>
					</div>{$iI=$iI+1}
				{/if}
			{/foreach}
			{if !$bOrder}<div class="opt">{if $iI == 0}Вы не заказали дополнительных опций для этого товара{else}<a href="{$oProduct->getUrlFull()}" class="product-title del-opt">Перейдите в карточку товара для удаления лишних опций</a>{/if}</div>{/if}
		</div>
		<div class="col-sm-2">
			<div class="grey">Цена</div>
			{*{if $oCart}*}
				{*<div class="count">*}
					{*<div class="value">{$oOrderProduct->getProductCount()}</div>*}
					{*<a class="up" href="#up" data-id="{$oProduct->getId()}" data-d="1"></a>*}
					{*<a class="down" href="#down" data-id="{$oProduct->getId()}" data-d="-1"></a>*}
				{*</div>*}
				{*<div class="guaranty">*}
					{*<div class="grey">Гарантия</div>*}
					{*<div class="value"><i>{$oProduct->getGuaranty()}</i> <span>{$oProduct->getGuaranty()|sklonenie:['месяц','месяца','месяцев']}</span></div>*}
				{*</div>*}
			{*{else}*}
				{*{$oOrderProduct->getProductCount()}*}
			{*{/if}*}
			{$oProduct->getOrderProduct()}
			<div class="bg-purple price-total">
				<div class="za-divan">&nbsp;</div>
				{*<div class="za-divan">За этот диван</div>*}
				<div class="your_price">
				<span class="cost">{$oOrderProduct->getPriceTotal(true, true)}</span>
				</div>
			</div>
			Доставка:<br>
			{$oOrderProduct->getPriceDelivery(true, true)}
		</div>
	</div>
	<div class="buffer"></div>
</div>
