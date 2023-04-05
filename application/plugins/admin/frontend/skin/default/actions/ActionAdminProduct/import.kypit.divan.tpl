{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'product'}
    {$sMenuSelectSub = 'product'}
{/block}

{block name='layout_content'}
    <h2>Импорт товаров c Kypit-Divan</h2>
    <form action="">
        {component field template='text'
        name        = 'product_id'
        label       = 'Айди товара на внешнем сайте'}

        {component button text='Скопировать'}
    </form>
    <p>Товар успешно добавлен <a href="{$ADMIN_URL}product/{$product->getId()}/">{$product->getTitleFull()}</a></p>
{/block}

{block name="scripts"}
    {capture name="script"}
        <script>

        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.script)}
{/block}