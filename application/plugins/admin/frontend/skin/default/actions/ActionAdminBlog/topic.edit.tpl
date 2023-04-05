{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'blog'}
    {$sMenuSelectSub = 'blog_topic'}
{/block}

{block name='layout_content'}
    <h2>Редактирование</h2>
    <div class="cl h20"></div>
    {include file="{$aTemplatePathPlugin.admin}forms/blog.topic.tpl"}
{/block}

{block name="scripts" append}
    <script>
        let iTargetId = {$oTopic->getId()};
        let sTargetType = 'topic';
        initSample();
        $(function(){
            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#blog-topic').submit();
                    return false;
                }
            });
        });
    </script>
{/block}
