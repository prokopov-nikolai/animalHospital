{component field template='datetime'
label           = 'Дата начала публикации на Avito'
name            = 'design[avito_date_begin]'
value           = $oDesign->getAvitoDateBegin()|date_format:'d.m.Y H:i:s'
inputAttributes = ['autocomplete' => 'off']}

{component field template='datetime'
label           = 'Дата окончания публикации на Avito'
name            = 'design[avito_date_end]'
value           = $oDesign->getAvitoDateEnd()|date_format:'d.m.Y H:i:s'
inputAttributes = ['autocomplete' => 'off']}
{*value           = '10.10.2020 12:00:15'*}

{component field template='text'
label   = 'Наценка наAvito'
name    = 'design[avito_margin]'
value   = ($oDesign) ? $oDesign->getAvitoMargin() : ''}