{component field template='text'
label   = 'Title'
name    = 'seo[product][title]'
value   = ($aSeo['product']) ? $aSeo['product']['title'] : ''}

{component field template='text'
label   = 'Keywords'
name    = 'seo[product][keywords]'
value   = ($aSeo['product']) ? $aSeo['product']['keywords'] : ''}

{component field template='text'
label   = 'Description'
name    = 'seo[product][description]'
value   = ($aSeo['product']) ? $aSeo['product']['description'] : ''}