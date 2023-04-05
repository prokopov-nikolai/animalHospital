<div class="cl" style="height: 30px"></div>
<div id="option-values" class="option-sortable">
    {foreach $oOption->getValues() as $oOptionValue}
        {include file="{$aTemplatePathPlugin.admin}forms/option/ajax.item.tpl"}
    {/foreach}
</div>
<input type="file" name="option-image" id="option-image" class="dn">
<div class="cl" style="height: 30px"></div>
<span class="ls-button" id="option-add">Добавить значение</span>

{capture name='scripts'}
    <script>
        $(function(){
            let iOptionId = {$oOption->getId()},
                iOptionValueId = null;
            $('#option-add').on('click', function() {
                ls.ajax.load(ADMIN_URL+'option/ajax/value/add/', {
                    id: iOptionId,
                }, function(answ){
                    $('#option-values').append(answ.sHtml);
                    BindOptionValuesUpdate();
                    BindOptionDelete();
                });
            });
            function BindOptionValuesUpdate() {
                $('#option-values input[name="title"]').off('change').on('change', function() {
                    iOptionValueId = $(this).parents('.option-value').data('id'),
                        sTitle = $(this).val();
                    ls.ajax.load(ADMIN_URL+'option/ajax/value/update/', {
                        id: iOptionValueId,
                        title: sTitle
                    }, function(answ){ });
                });
                $('#option-values input[name="margin"]').off('change').on('change', function() {
                    iOptionValueId = $(this).parents('.option-value').data('id'),
                        fMargin = $(this).val();
                    ls.ajax.load(ADMIN_URL+'option/ajax/value/update/', {
                        id: iOptionValueId,
                        margin: fMargin
                    }, function(answ){ });
                });
                $('#option-values .img').off('click').on('click', function() {
                    $('#option-image').trigger('click');
                    iOptionValueId = $(this).parents('.option-value').data('id');
                });
            };
            BindOptionValuesUpdate();
            $('#option-image').on('change', function(){
                let formData = new FormData();
                formData.append('image', $("#option-image")[0].files[0]);
                formData.append('id', iOptionValueId);
                // ls.ajax.load(ADMIN_URL+'option/ajax/value/update/', formData, function(answ){ });
                $.ajax({
                    type: "POST",
                    url: ADMIN_URL+'option/ajax/value/update/',
                    cache: false,
                    contentType: false,
                    processData: false,
                    data: formData,
                    dataType : 'json',
                    success: function(answ){
                        let oImg = $('.option-value[data-id="'+iOptionValueId+'"] .img');
                        if (answ.success == false) {
                            ls.msg.error(answ.sError);
                            oImg.find('img').remove();
                        } else {
                            ls.msg.notice(answ.sMessage);
                            if (oImg.find('img').length) {
                                oImg.find('img').attr('src', answ.sSrc);
                            } else {
                                oImg.html('<img src="'+answ.sSrc+'" alt="">');
                            }
                        }
                    }
                });
            });
            let bIsBlocked = false;
            $('.option-sortable').sortable({
                stop: function () {
                    if (bIsBlocked) return false;
                    var aOption = [];
                    $('.option-value').each(function () {
                        aOption.push($(this).data('id'));
                    });
                    ls.ajax.load(ADMIN_URL + 'option/ajax/value/sort/', {
                        sort: aOption,
                    });
                }
            });
            function BindOptionDelete() {
                $('.option-value .ls-icon-remove').off('click').on('click', function () {
                    let oParent = $(this).parents('.option-value');
                    iOptionValueId = oParent.data('id');
                    ls.ajax.load(ADMIN_URL + 'option/ajax/value/delete/', {
                        id: iOptionValueId
                    }, function () {
                        // nothing todo
                    }, function () {
                        oParent.remove();
                    });
                });
            }
            BindOptionDelete();
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}