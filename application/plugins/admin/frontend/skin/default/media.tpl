<div><b>ОРИГИНАЛ</b></div>
<div class="fl" style="width: 380px;"><b>Ширина:</b>{$oMedia->getWidth()}px, <b>Высота:</b>{$oMedia->getHeight()}px, {$iS = ($oMedia->getFileSize()/1024)}<b>Вес:</b>{if $iS < 1024}
    {$iS|number_format:0:',':' '}Kb
    {else}
    {($iS/1024)|number_format:1:',':' '}Mb
    {/if}</div>

{component field template='text'
    id='image_format'
    label='Формат изображения'
    note='100x100crop, 300x, x600'
    classes='fl'
    attributes=['style'=>'width:200px; margin:-20px 0;']}
{component button text='Сгенерировать'
attributes=['style'=>'margin:0 0 0 15px;'] id="generate_preview"}
<div class="cl" style="height: 20px;"></div>
{component field template='text'
    id='image_format_link'
    label='Ссылка для вставки'
    value="{$oMedia->getFileWebPath()}"}

<div class="img"><img src="{$oMedia->getFileWebPath()}" alt=""></div>
