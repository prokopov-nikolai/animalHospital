{component field template='select'
name        = 'topic[blog_id]'
label       = 'Раздел'
items       = $aBlogSelect
selectedValue       = $oTopic->getBlogId()}

{component field template='text'
name        = 'topic[title]'
label       = 'Название статьи'
value       = $oTopic->getTitle()}

{component field template='text'
name        = 'topic[url]'
label       = 'Урл статьи'
value       = $oTopic->getUrl()}

{*<label for="" class="ls-label">Урл статьи</label>*}
{*<div class="ls-field"><a href="{$oTopic->getUrlFull()}" target="_blank">{$oTopic->getUrlFull()}</a></div>*}
{*{component field template='checkbox'*}
{*name        = 'update_url'*}
{*label       = 'Обновить урл'}*}

<div class="cl h20"></div>

{component field template='file'
name        = 'topic_preview'
label       = 'Превью статьи'}
{if $sFilePath = $oTopic->getPreviewImage()}
    <img src="{$sFilePath}" alt="">
{/if}

<div class="cl h20"></div>

{component field template='textarea'
name            = 'topic[text]'
label           = 'Текст'
iRows           = 10
id              = 'editor'
value           = $oTopic->getText()}