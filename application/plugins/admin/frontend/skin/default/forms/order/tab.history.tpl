<span class="ls-button show-all-comments">Только примечания</span>
<table class="table history">
    <tbody>
    {foreach $oOrder->getComments() as $oComment}
        {include file="{$aTemplatePathPlugin.admin}forms/order/tab.history.table.tr.tpl"}
    {/foreach}
    </tbody>
</table>

{capture name="scripts"}
    <script>
        $('.show-all-comments').on('click', function(){
            $('.table.history .system').toggleClass('hide');
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}