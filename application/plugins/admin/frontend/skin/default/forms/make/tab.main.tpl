{component 'field' template='text'
label = 'Название'
name  = 'make[title]'
value = $oMake->getTitle()}

{component 'field' template='text'
label = 'Url'
name  = 'make[url]'
value = $oMake->getUrl()}

{component 'field' template='textarea'
label = 'Текст'
rows  = 10
name  = 'make[text]'
inputClasses = 'ace-redactor'
inputAttributes = ['style' => 'display:none;', 'data-redactor-id' => 'ace-redactor-text']
value = $oMake->getText()}
<div id="ace-redactor-text" style="min-height: 100px;"></div>

{component 'field' template='textarea'
label = 'Группы тканей'
rows  = 10
name  = 'make[groups]'
inputClasses = 'ace-redactor'
inputAttributes = ['style' => 'display:none;', 'data-redactor-id' => 'ace-redactor-groups']
value = $oMake->getGroups()|json_decode}
<div id="ace-redactor-groups" style="min-height: 100px;"></div>
<small class="note">Номер группы всегда должен быть целым числом и начинаться с 1. Например "1|Спец. кат."</small>


{component 'field' template='text'
label = 'Грантия'
note = 'Количество месяцев'
name  = 'make[guaranty]'
value = $oMake->getGuaranty()}
