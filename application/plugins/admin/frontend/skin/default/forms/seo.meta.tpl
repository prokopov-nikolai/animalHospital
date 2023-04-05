{capture name='sTabCategoryFilter'}     {include file="{$aTemplatePathPlugin.admin}forms/seo.meta/tab.category.filter.tpl"} {/capture}
{capture name='sTabProduct'}            {include file="{$aTemplatePathPlugin.admin}forms/seo.meta/tab.product.tpl"}         {/capture}
{capture name='sTabDesign'}             {include file="{$aTemplatePathPlugin.admin}forms/seo.meta/tab.design.tpl"}          {/capture}
<form action="" method="post">
    {component 'tabs' classes='' mods='align-top' tabs=[
    [ 'text' => 'Категории',     'body' => $smarty.capture.sTabCategoryFilter],
    [ 'text' => 'Товары',        'body' => $smarty.capture.sTabProduct],
    [ 'text' => 'Дизайны',       'body' => $smarty.capture.sTabDesign]
    ]}
    {component button text='Сохранить' mods='primary'}
    <p>
        <b>Переменные для использования</b>
    <table class="table">
        <tr>
            <td>&#123;category_price_min&#125;</td>
            <td>Минимальная цена товара, категории</td>
        </tr>
        <tr>
            <td>&#123;category_price_max&#125;</td>
            <td>Максимальная цена товара, категории</td>
        </tr>
        <tr>
            <td>&#123;category_title&#125;</td>
            <td>Название категории</td>
        </tr>
        <tr>
            <td>&#123;category_product_prefix&#125;</td>
            <td>Префикс категории для товара</td>
        </tr>
        <tr>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>&#123;product_title&#125;</td>
            <td>Название товара</td>
        </tr>
        <tr>
            <td>&#123;product_title_full&#125;</td>
            <td>Полное название товара</td>
        </tr>
        <tr>
            <td>&#123;product_price&#125;</td>
            <td>Цена товара</td>
        </tr>
        <tr>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>&#123;design_title&#125;</td>
            <td>Название дизайна</td>
        </tr>
        <tr>
            <td>&#123;design_title_full&#125;</td>
            <td>Полное название дизайна</td>
        </tr>
        <tr>
            <td>&#123;design_price&#125;</td>
            <td>Цена дизайна</td>
        </tr>
        <tr>
            <td></td>
            <td></td>
        </tr>
        <tr>
            <td>&#123;h1&#125;</td>
            <td>Заголовок h1 из описания</td>
        </tr>
        <tr>
            <td>&#123;city&#125;</td>
            <td>Город</td>
        </tr>
        <tr>
            <td>&#123;...|lower&#125;</td>
            <td>Нижний регистр</td>
        </tr>
        <tr>
            <td>&#123;...|upper&#125;</td>
            <td>Верхний регистр</td>
        </tr>

    </table>
    </p>
</form>