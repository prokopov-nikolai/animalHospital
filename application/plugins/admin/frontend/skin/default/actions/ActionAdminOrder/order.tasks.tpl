{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'order'}
    {$sMenuSelectSub = 'order_tasks'}
{/block}

{block name='layout_head_end'}{/block}

{block name='layout_content'}
    <div class="order-tasks">
        <h1>{$aLang.plugin.admin.menu.order_tasks}</h1>
        {include file="{$aTemplatePathPlugin.admin}order/tasks.filter.tpl"}
        {include file="{$aTemplatePathPlugin.admin}order/tasks.tpl"}
    </div>

    {capture name="scripts"}
        <script>
            $('.task-done').on('click', function(){
                let but = $(this),
                    tr = $(this).parents('tr'),
                    taskId = tr.data('id');
                ls.ajax.load(ADMIN_URL + 'order/ajax/task/done/', { task_id: taskId }, function(){
                    but.after('<span class="checkbox-blue"></span>').remove();
                });
                return false;
            });
        </script>
    {/capture}

    {LS::Append('scripts', $smarty.capture.scripts)}
{/block}

