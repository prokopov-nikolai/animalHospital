{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'design'}
{/block}

{block name='layout_content'}
    <h1>Дизайны</h1>
    <div class="button update" style="height: 60px;">Заменить главное фото на вид сбоку</div>
    <table class="table">
        <tbody>
        {foreach $aDesign as $oDesign}
            <tr class="dooo" data-id="{$oDesign->getId()}">
                <td>{$oDesign->getId()}</td>
                <td><a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/"><img src="{$oDesign->getMainPhotoUrl('300x')}" alt="" width="100"></a></td>
                <td><a href="/{Config::Get('url_adm')}/product/design/{$oDesign->getId()}/">{$oDesign->getProductPrefix()} {$oDesign->getTitle()}</a></td>
                <td class="update"></td>
                <td>{($oDesign->getHide()) ? 'скрыт' : '-'}</td>
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
                ls.ajax.load(ADMIN_URL+'product/design/main-photo-update/', {
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