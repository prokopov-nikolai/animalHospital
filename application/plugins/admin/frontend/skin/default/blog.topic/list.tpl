<table class="table">
    <tr>
        <th>id</th>
        <th>Превью</th>
        <th>Название</th>
        <th>Url</th>
        <th>Раздел</th>
        <th></th>
    </tr>
    {foreach $aTopic as $oTopic}
        <tr>
            <td>{$oTopic->getId()}</td>
            <td><img src="{$oTopic->getPreviewImage()}" alt="" width="50"></td>
            <td>{$oTopic->getTitle()}</td>
            <td>{$oTopic->getUrl()}</td>
            <td>{$oTopic->getBlogTitle()}</td>
            <td>
                <a href="{$oTopic->getUrlFull()}" class="ls-icon-share" target="_blank" data-tooltip="Открыть с клиентской стороны"></a> &nbsp;
                <a href="{$ADMIN_URL}blog/topic/{$oTopic->getId()}/" class="ls-icon-edit" data-tooltip="Редактировать"></a> &nbsp;
                <a href="{$ADMIN_URL}blog/topic/delete/{$oTopic->getId()}/" class="ls-icon-remove"></a></td>
        </tr>
    {/foreach}
</table>

{component pagination paging=$aPaging}
