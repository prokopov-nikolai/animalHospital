{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'design'}
{/block}

{block name='layout_content'}
    <h1>Товары</h1>
    <div class="button update" style="height: 60px;">Заменить главное фото на вид сбоку</div>
    <table class="table">
        <tbody>
        {foreach $aProduct as $oProduct}
            <tr class="dooo" data-id="{$oProduct->getId()}">
                <td><a href="/{Config::Get('url_adm')}/product/design/{$oProduct->getId()}/"><img src="{$oProduct->getMainPhotoUrl('300x')}" alt="" width="100"></a></td>
                <td><a href="/{Config::Get('url_adm')}/product/design/{$oProduct->getId()}/">{$oProduct->getProductPrefix()} {$oProduct->getTitle()}</a></td>
                <td class="update"></td>
                <td>{($oProduct->getHide()) ? 'скрыт' : '-'}</td>
            </tr>
        {/foreach}
        </tbody>
    </table>
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>
            $(function(){
                $('.button.update').on('click', function(){
                    UpdateMainPhoto();
                });
            });
            function UpdateMainPhoto() {
                let id = $('tr.dooo').data('id');
                ls.ajax.load(ADMIN_URL+'product/main-photo-update/', {
                    id:id
                }, function(answ){
                    $('tr[data-id="'+id+'"]').removeClass('dooo').find('.update').html(answ.text);
                    UpdateMainPhoto();
                });
            }
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}