{component field template='text'
name        = 'blog[title]'
label       = 'Название раздела'
value       = $oBlog->getTitle()}

<label for="" class="ls-label">Урл раздела</label>
<div class="ls-field"><a href="{$oBlog->getUrlFull()}" target="_blank">{$oBlog->getUrlFull()}</a></div>
{component field template='checkbox'
name        = 'update_url'
label       = 'Обновить урл'}

<div class="cl h20"></div>

{component field template='file'
name        = 'blog_preview'
label       = 'Превью раздела'}
{if $sFilePath = $oBlog->getPreviewImage()}
    <img src="{$sFilePath}" alt="">
{/if}
<div class="cl h20"></div>

{component field template='textarea'
name            = 'blog[text]'
label           = 'Текст'
iRows           = 10
id              = 'editor'
value           = $oBlog->getText()}