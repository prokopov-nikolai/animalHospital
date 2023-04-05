<script type="text/javascript">
    $(function () {
        {if !$oCategoryCurrent}
        $('#submit-{$bAction}-category').bind('click', function () {
            $('#form-{$bAction}-category .dn').slideToggle();
            $('#submit-{$bAction}-category').unbind('click');
            return false;
        });
        {/if}
        $(document).bind('keydown', 'ctrl+s', function (e) {
            if (e.ctrlKey && (e.which == 83)) {
                e.preventDefault();
                $('#form-update-category').submit();
                return false;
            }
        });
    });
</script>

{* Подключение редактора *}
{*{if $bRedactorInit === true}*}
{*{include 'components/editor/editor.tpl'*}
{*{include 'components/editor/editor.tpl'*}
{*sName            = 'topic[topic_text_source]'*}
{*sValue           = (( $topic ) ? $topic->getTextSource() : '')|escape*}
{*sLabel           = $aLang.topic.add.fields.text.label*}
{*sEntityField	 = 'topic_text_source'*}
{*sEntity			 = 'ModuleTopic_EntityTopic'*}
{*sMediaTargetType = 'category'}*}
{*{include 'forms/editor.init.tpl' sEditorSelector='text-add, .text-update' sMediaTargetType='category'}*}
{*{/if}*}

<div class="cl" style="height: 20px;"></div>
<form action="" method="post" enctype="multipart/form-data" id="form-{$bAction}-category">
    <div class="{if !$oCategoryCurrent}dn{/if}">
        <ul class="nav nav-tabs" data-type="tabs">
            <li class="nav-item active" data-type="tab" data-tab-target="tab1-{$bAction}"><a href="#tab1-{$bAction}">Описание</a>
            </li>
            <li class="nav-item" data-type="tab" data-tab-target="tab2-{$bAction}"><a href="#tab2-{$bAction}">Seo</a>
            </li>
            <li class="nav-item" data-type="tab" data-tab-target="tab3-{$bAction}"><a
                        href="#tab3-{$bAction}">Харк-ки</a></li>
            <li class="nav-item" data-type="tab" data-tab-target="tab4-{$bAction}"><a href="#tab4-{$bAction}">Дополнительно</a>
            </li>
        </ul>
        <div data-type="tab-panes">
            <div class="tab-pane active" id="tab1-{$bAction}" data-type="tab-pane">

                <div class="cl" style="height: 220px;"></div>
            </div>
            <div class="tab-pane" id="tab2-{$bAction}" data-type="tab-pane">
            </div>
            <div class="tab-pane" id="tab3-{$bAction}" data-type="tab-pane">

                <br>
            </div>
            <div class="tab-pane" id="tab4-{$bAction}" data-type="tab-pane">
                {* Наценка *}
                {include file='components/field/field.text.tpl'
                sName        = 'category[margin]'
                sLabel       = 'Наценка'
                sValue       = {($oCategoryCurrent && $oCategoryCurrent->getMargin()) ? $oCategoryCurrent->getMargin() : '30.00'}}

                {* Сортировка *}
                {include file='components/field/field.text.tpl'
                sName        = 'category[sort]'
                sLabel       = 'Сортировка'
                sValue       = {($oCategoryCurrent && $oCategoryCurrent->getSort()>-1) ? $oCategoryCurrent->getSort() : 1}}

                {* Ставка Яндекс Маркет *}
                {include file='components/field/field.text.tpl'
                sName        = 'category[bid]'
                sLabel       = 'Ставка Яндекс Маркет'
                sValue       = {($oCategoryCurrent && $oCategoryCurrent->getBid()) ? $oCategoryCurrent->getBid() : '10'}}
            </div>
        </div>
    </div>
    <div class="cl" style="height: 20px;"></div>

</form>
<div class="cl" style="height: 20px;"></div>
