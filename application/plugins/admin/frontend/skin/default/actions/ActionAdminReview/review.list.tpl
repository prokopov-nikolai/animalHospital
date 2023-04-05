{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'review'}
{/block}

{block name='layout_content'}
    <h1>Отзывы</h1>
    {if $aReview.collection|count == 0}
    <p>пока пусто</p>
    {else}
        <table class="table">
            <tr>
                <th>id</th>
                <th>Дата</th>
                <th width="300">Комментарий</th>
                <th>ФИО</th>
                <th>email</th>
                <th>Рейтинг</th>
                <th>Опубликован</th>
                <th>Товар</th>
                <th></th>
            </tr>
            {foreach $aReview.collection as $oReview}
                <tr>
                    <td><a href="{$ADMIN_URL}review/{$oReview->getId()}/">{$oReview->getId()}</a></td>
                    <td>{$oReview->getDateAdd()}</td>
                    <td>{$oReview->getComment()|CutText:100}</td>
                    <td>{$oReview->getFio()}</td>
                    <td>{$oReview->getEmail()}</td>
                    <td>{$oReview->getRating()}</td>
                    <td>{($oReview->getModerate()) ? 'Да' : '-'}</td>
                    <td><a href="{$oReview->getProduct()->getUrlFull()}" target="_blank">{$oReview->getProductTitleFull()}</a></td>
                    <td>
                        &nbsp;&nbsp;
                        <a href="{$ADMIN_URL}review/publish/{$oReview->getId()}/" class="{if !$oReview->getModerate()}ls-icon-plus{else}ls-icon-minus{/if}" title="{if !$oReview->getModerate()}Опубликовать{else}Снять с публикации{/if}"></a>
                         &nbsp;&nbsp;
                        <a href="{$ADMIN_URL}review/{$oReview->getId()}/" class="ls-icon-edit"></a>
                        &nbsp;&nbsp;
                        <a href="{$ADMIN_URL}review/delete/{$oReview->getId()}/" class="ls-icon-remove"></a>
                    </td>
                </tr>
            {/foreach}
        </table>

        {component pagination paging=$aPaging}
    {/if}
{/block}
