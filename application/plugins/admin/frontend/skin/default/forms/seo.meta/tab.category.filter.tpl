{component field template='text'
label   = 'Title'
name    = 'seo[category_filter][title]'
value   = ($aSeo['category_filter']) ? $aSeo['category_filter']['title'] : ''}

{component field template='text'
label   = 'Keywords'
name    = 'seo[category_filter][keywords]'
value   = ($aSeo['category_filter']) ? $aSeo['category_filter']['keywords'] : ''}

{component field template='text'
label   = 'Description'
name    = 'seo[category_filter][description]'
value   = ($aSeo['category_filter']) ? $aSeo['category_filter']['description'] : ''}