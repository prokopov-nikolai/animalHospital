{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_head_end'}
    <style>
        @media print {
            @page {
                size:landscape;
            }
        }
    </style>
{/block}

{block name='layout_options'}
    {$sMenuSelect = 'report'}
{/block}

{block name='layout_content'}
    <h1>Отчеты</h1>
    {if (LS::HasRight('24_report_costs'))}
        <a href="{$ADMIN_URL}report/costs/">{$aLang.plugin.admin.menu.report_costs}</a><br>&nbsp;<br>
    {/if}
    {if (LS::HasRight('41_report_summary'))}
        <a href="{$ADMIN_URL}report/summary/">{$aLang.plugin.admin.menu.report_summary}</a><br>&nbsp;<br>
    {/if}
    {if (LS::HasRight('25_report_agent'))}
        <a href="{$ADMIN_URL}report/agent/">{$aLang.plugin.admin.menu.report_agent}</a><br>&nbsp;<br>
    {/if}
    {if (LS::HasRight('3_report_salary'))}
        <a href="{$ADMIN_URL}report/salary/">{$aLang.plugin.admin.menu.report_salary}</a><br>&nbsp;<br>
    {/if}
    {if (LS::HasRight('4_report_delivery'))}
        <a href="{$ADMIN_URL}report/delivery/">{$aLang.plugin.admin.menu.report_delivery}</a><br>&nbsp;<br>
    {/if}
    {if (LS::HasRight('37_report_failure'))}
        <a href="{$ADMIN_URL}report/failure/">{$aLang.plugin.admin.menu.report_failure}</a><br>&nbsp;<br>
    {/if}
{/block}

{block name='scripts' append}
    <script>
        $(function () {

        });
    </script>
{/block}