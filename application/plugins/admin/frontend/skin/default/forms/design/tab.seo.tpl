{component field template='text'
label   = 'seo_title'
name    = 'design[seo_title]'
value   = ($oDesign) ? $oDesign->getSeoTitle() : ''}

{component field template='text'
label   = 'seo_keywords'
name    = 'design[seo_keywords]'
value   = ($oDesign) ? $oDesign->getSeoKeywords() : ''}

{component field template='text'
label   = 'seo_description'
name    = 'design[seo_description]'
value   = ($oDesign) ? $oDesign->getSeoDescription() : ''}