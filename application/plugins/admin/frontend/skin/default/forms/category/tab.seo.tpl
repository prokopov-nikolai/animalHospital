{component field template='text'
label   = 'seo_title'
name    = 'category[seo_title]'
value   = ($oCategory) ? $oCategory->getSeoTitle() : ''}

{component field template='text'
label   = 'seo_keywords'
name    = 'category[seo_keywords]'
value   = ($oCategory) ? $oCategory->getSeoKeywords() : ''}

{component field template='text'
label   = 'seo_description'
name    = 'category[seo_description]'
value   = ($oCategory) ? $oCategory->getSeoDescription() : ''}