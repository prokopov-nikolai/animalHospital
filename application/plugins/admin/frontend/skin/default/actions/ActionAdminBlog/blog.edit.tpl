{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'blog'}
    {$sMenuSelectSub = 'blog_blogs'}
{/block}

{block name='layout_content'}
    <h2>Редактирование</h2>
    <div class="cl h20"></div>
    {include file="{$aTemplatePathPlugin.admin}forms/blog.tpl"}
{/block}

{block name="scripts" append}
    <script>
        let iTargetId = {$oBlog->getId()};
        let sTargetType = 'blog';
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
