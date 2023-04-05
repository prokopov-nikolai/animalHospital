{component field template='text'
label   = 'seo_title'
name    = 'make[seo_title]'
value   = ($oMake) ? $oMake->getSeoTitle() : ''}

{component field template='text'
label   = 'seo_keywords'
name    = 'make[seo_keywords]'
value   = ($oMake) ? $oMake->getSeoKeywords() : ''}

{component field template='text'
label   = 'seo_description'
name    = 'make[seo_description]'
value   = ($oMake) ? $oMake->getSeoDescription() : ''}