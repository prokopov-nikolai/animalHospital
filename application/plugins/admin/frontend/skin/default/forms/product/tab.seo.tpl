{component field template='text'
label   = 'seo_title'
name    = 'product[seo_title]'
value   = ($oProduct) ? $oProduct->getSeoTitle() : ''}

{component field template='text'
label   = 'seo_keywords'
name    = 'product[seo_keywords]'
value   = ($oProduct) ? $oProduct->getSeoKeywords() : ''}

{component field template='text'
label   = 'seo_description'
name    = 'product[seo_description]'
value   = ($oProduct) ? $oProduct->getSeoDescription() : ''}