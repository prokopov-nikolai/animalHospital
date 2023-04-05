{$aTabs = []}
{foreach Config::Get('collection_supplier') as $aD}
    {if $aD.value != ''}
        {capture name="sTabSupplierCollection"}
            {include file="{$aTemplatePathPlugin.admin}make/tab.supplier.collections.tpl" aCollection=$aMakeCollection[$aD.value]}
        {/capture}
        {$aTabs[] = ['text' => $aD.text, 'body' => $smarty.capture.sTabSupplierCollection]}
    {/if}
{/foreach}

{component 'tabs' classes='' mods='align-top' tabs=$aTabs}

<style>
    .collection-title {
        padding: 18px 5px!important;
    }
    .make-group {
        padding: 2px 10px!important;
    }
</style>

{capture name='script'}
    <script>
        $(function(){
            $('.make-collection').change(function() {
                var aData =  {
                    'make_id' : $(this).data('make-id'),
                    'collection_id' : $(this).data('collection-id'),
                    'make_group' : $(this).val(),
                };
                ls.ajax.load(ADMIN_URL+'make/ajax/collection/change/', aData);
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}