{component field template='text'
label   = 'Title'
name    = 'seo[design][title]'
value   = ($aSeo['design']) ? $aSeo['design']['title'] : ''}

{component field template='text'
label   = 'Keywords'
name    = 'seo[design][keywords]'
value   = ($aSeo['design']) ? $aSeo['design']['keywords'] : ''}

{component field template='text'
label   = 'Description'
name    = 'seo[design][description]'
value   = ($aSeo['design']) ? $aSeo['design']['description'] : ''}