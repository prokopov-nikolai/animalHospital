<form action="">
{$aUserOptionValues = $oOrderProduct->getUserOptionValuesEntity()}
{foreach $oOrderProduct->getProduct()->getOptions() as $oOption}
    {include file="{$sTemplatePathPluginAdmin}product/option.{$oOption->getType()}.tpl" aUserOptionValues=$aUserOptionValues}
{/foreach}
</form>