{* seo_title *}
{component field template='text'
name        = 'category_filter[seo_title]'
label       = 'seo_title'
value       = $oCategoryFilter->getSeoTitle()}

{* seo_keywords *}
{component field template='text'
name        = 'category_filter[seo_keywords]'
label       = 'seo_keywords'
value       = $oCategoryFilter->getSeoKeywords()}

{* seo_description *}
{component field template='text'
name        = 'category_filter[seo_description]'
label       = 'seo_description'
value       = $oCategoryFilter->getSeoDescription()}