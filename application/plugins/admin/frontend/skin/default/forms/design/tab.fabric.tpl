<h3>Ткани</h3>
<div class="ls-field autocomplete">
    <input type="text" class="fabric autocomplete-pro" name="fabric">
    <small class="note">Начните вбивать название ткани</small>
</div>

<div class="ls-field" id="fabric1">
    {component field template='text'
    name    = 'design[fabric1_name]'
    value   = $oDesign->getFabric1Name()|default:$oProduct->getFabric1Name()
    classes = 'w250'}
    {component field template='hidden'
    name    = 'design[fabric1_id]'
    value   = $oDesign->getFabric1Id()}
    <div class="dflex">
        {if $oFabricMedia = $oDesign->getFabric1()}
            <img src="{$oFabricMedia->getFileWebPath('100x100crop')}" alt="" width="100" class="">
            <div class="fabric-title">
                {$oFabricMedia->getTitle()}<br>
                <span>{$oFabricMedia->getCollectionTitle()}<br>
                {$oFabricMedia->getSupplierRu()}</span>
            </div>
            <div class="ls-icon-remove"></div>
        {/if}
    </div>
</div>

<div class="ls-field" id="fabric2">
    {component field template='text'
    name    = 'design[fabric2_name]'
    value   = $oDesign->getFabric2Name()|default:$oProduct->getFabric2Name()
    classes = 'w250'}
    {component field template='hidden'
    id      = 'fabric2'
    name    = 'design[fabric2_id]'
    value   = $oDesign->getFabric2Id()}
    <div class="dflex">
        {if $oFabricMedia = $oDesign->getFabric2()}
            <img src="{$oFabricMedia->getFileWebPath('100x100crop')}" alt="" width="100" class="">
            <div class="fabric-title">
                {$oFabricMedia->getTitle()}<br>
                <span>{$oFabricMedia->getCollectionTitle()}<br>
                {$oFabricMedia->getSupplierRu()}</span>
            </div>
            <div class="ls-icon-remove"></div>
        {/if}
    </div>
</div>

<div class="ls-field" id="fabric3">
    {component field template='text'
    name    = 'design[fabric3_name]'
    value   = $oDesign->getFabric3Name()|default:$oProduct->getFabric3Name()
    classes = 'w250'}
    {component field template='hidden'
    id      = 'fabric3'
    name    = 'design[fabric3_id]'
    value   = $oDesign->getFabric3Id()}
    <div class="dflex">
        {if $oFabricMedia = $oDesign->getFabric3()}
            <img src="{$oFabricMedia->getFileWebPath('100x100crop')}" alt="" width="100" class="">
            <div class="fabric-title">
                {$oFabricMedia->getTitle()}<br>
                <span>{$oFabricMedia->getCollectionTitle()}<br>
                {$oFabricMedia->getSupplierRu()}</span>
            </div>
            <div class="ls-icon-remove"></div>
        {/if}
    </div>
</div>

<div class="ls-field" id="fabric4">
    {component field template='text'
    name    = 'design[fabric4_name]'
    value   = $oDesign->getFabric4Name()|default:$oProduct->getFabric4Name()
    classes = 'w250'}
    {component field template='hidden'
    id      = 'fabric4'
    name    = 'design[fabric4_id]'
    value   = $oDesign->getFabric4Id()}
    <div class="dflex">
        {if $oFabricMedia = $oDesign->getFabric4()}
            <img src="{$oFabricMedia->getFileWebPath('100x100crop')}" alt="" width="100" class="">
            <div class="fabric-title">
                {$oFabricMedia->getTitle()}<br>
                <span>{$oFabricMedia->getCollectionTitle()}<br>
                {$oFabricMedia->getSupplierRu()}</span>
            </div>
            <div class="ls-icon-remove"></div>
        {/if}
    </div>
</div>

{capture name='script'}
    <script>
        $(function () {
            /**
             * Автокомплит тканей
             */
            $('.fabric.autocomplete-pro').autocompletePro({
                'name': 'fabric',
                'url': '/ajax/search/fabric/',
                'minLength': 1,
                name_search: 'search',
                'render': function (obj) {
                    var item =
                        '<div class="row" data-id="' + obj.id + '" data-scr="' + obj.image + '">' +
                        '<div class="img">' +
                        '<img src="' + obj.image + '" width="100">' +
                        '<span class="item fabric1" data-id="fabric1">Ткань 1</span>' +
                        '<span class="item fabric2" data-id="fabric2">Ткань 2</span>' +
                        '<span class="item fabric3" data-id="fabric3">Ткань 3</span>' +
                        '<span class="item fabric4" data-id="fabric4">Ткань 4</span>' +
                        '</div>' +
                        '<span>' + obj.title + ' <br><span>' + obj.collection_title + '<br>'+obj.supplier + '</span> '+(obj.hide == 1 ? ' <span style="color:#d60000;">(выведена)</span> ' : '') + '</span>' +
                        '</div>';
                    return item;
                }
            }, function (obj, item) {
                var iNum = $(item).data('id');
                $('input[name="design[' + iNum +'_id]"]').val(obj.id);
                $('#'+iNum+' .dflex').html('<img src="' + obj.image + '" width="100"><div class="fabric-title">' + obj.title + ' <br><span>' + obj.collection_title + '<br>'+obj.supplier + '</span> </div><div class="ls-icon-remove"></div>');
                BindRemove();
            });
            BindRemove();
            /**
             * Удаление ткани
             */
            function BindRemove() {
                $('#fabric1 .ls-icon-remove, #fabric2 .ls-icon-remove, #fabric3 .ls-icon-remove, #fabric4 .ls-icon-remove').off('click.remove').on('click.remove', function() {
                    var oParent = $(this).parent().parent();
                    oParent.find('input').val('');
                    oParent.find('.dflex').html('');
                });
            }
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}