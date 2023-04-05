{capture name='sTabMain'}       {include file="{$aTemplatePathPlugin.admin}forms/product/tab.main.tpl"} {/capture}
{capture name='sTabSeo'}        {include file="{$aTemplatePathPlugin.admin}forms/product/tab.seo.tpl"} {/capture}
{capture name='sTabChars'}      {include file="{$aTemplatePathPlugin.admin}forms/product/tab.chars.tpl"}{/capture}
{capture name='sTabPhoto'}      {include file="{$aTemplatePathPlugin.admin}forms/product/tab.photo.tpl"}{/capture}
{capture name='sTabPrice'}      {include file="{$aTemplatePathPlugin.admin}forms/product/tab.price.tpl"}{/capture}
{capture name='sTabFabrics'}    {include file="{$aTemplatePathPlugin.admin}forms/product/tab.fabrics.tpl"}{/capture}
{capture name='sTabGroups'} {include file="{$aTemplatePathPlugin.admin}forms/product/tab.groups.tpl"}{/capture}
{capture name='sTabOptions'}{include file="{$aTemplatePathPlugin.admin}forms/product/tab.options.tpl"}{/capture}
{*{capture name='sTabWorks'}      {include file="{$aTemplatePathPlugin.admin}forms/product/tab.works.tpl"}{/capture}*}
{capture name='sTab3d'}         {include file="{$aTemplatePathPlugin.admin}forms/product/tab.3d.tpl"}{/capture}
{*{capture name='sTabPriceAgents'}{include file="{$aTemplatePathPlugin.admin}forms/product/tab.price.agents.tpl"}{/capture}*}

<div class="ls-clearfix">
    <form action="" method="post" enctype="multipart/form-data" id="product">
        {component 'tabs' classes='' mods='align-top' tabs=[
        [ 'text' => 'Основное',     'body' => $smarty.capture.sTabMain],
        [ 'text' => 'Seo',          'body' => $smarty.capture.sTabSeo],
        [ 'text' => 'Хар-ки',       'body' => $smarty.capture.sTabChars],
        [ 'text' => 'Фото',         'body' => $smarty.capture.sTabPhoto, 'uid' => 'product-photo'],
        [ 'text' => 'Цены и ставки','body' => $smarty.capture.sTabPrice],
        [ 'text' => 'Ткани',        'body' => $smarty.capture.sTabFabrics],
        [ 'text' => 'Группы',       'body' => $smarty.capture.sTabGroups, 'uid' => 'product-groups'],
        [ 'text' => 'Опции',        'body' => $smarty.capture.sTabOptions,'uid' => 'product-options'],
        [ 'text' => '3D',           'body' => $smarty.capture.sTab3d, 'uid' => 'product-3d']
        ]}

{*        [ 'text' => 'Пр-во',        'body' => $smarty.capture.sTabWorks],*}
{*        [ 'text' => 'Скидки',       'body' => $smarty.capture.sTabPriceAgents],*}
        {include file="{$aTemplatePathPlugin.admin}components/field/field.hidden.tpl"
        sName        = 'product[id]'
        sValue       = $oProduct->getId()}

        {component button text='Сохранить' mods='primary'}
        &nbsp;&nbsp;&nbsp; ctrl+s или ctrl+enter - сохранить данные формы

        <a href="{$oProduct->getUrlFull()}" class="ls-button" target="_blank">Просмотр товара</a>
        {if $oProduct->getExternalId()}<span class="ls-button product-chars-update" style="width: auto;" data-id="{$oProduct->getId()}">Обновить хар-ки</span>{/if}
        <a href="{$ADMIN_URL}product/copy/{$oProduct->getId()}/" class="ls-button" target="_blank">Создать копию</a>
        <a href="{$ADMIN_URL}product/delete/{$oProduct->getId()}/" class="ls-button danger" target="_blank">Удалить товар</a>
    </form>
</div>


<div id="modal-upload-from-site" class="ls-modal">
    <div class="ls-modal-close"></div>
    <div class="ls-modal-content">
        <label for="" class="ls-label">Урл страницы с картинками</label>
        <input type="text" name="site_url" placeholder="https://www.mirlachev.ru/divan-zeld.html#12">
        <button class="ls-button--primary ls-button" id="upload-from-site-start">Загрузить</button>
    </div>
</div>

{capture name='script'}
    <script type="text/javascript">
        var iProductId = {$oProduct->getId()};
        $(function () {
            /**
             * Переключение вкладок
             */
            $('.ls-tabs').lsTabs();
            /**
             * Активируем нужную вкладку
             */
            if (window.location.hash != '#') {
                $($('.nav-tabs li a')[parseInt(window.location.hash.substr(1), 10) - 1]).click();
            }

            /**
             * Вставляем цены из буфера
             * @constructor
             */
            $('#paste-from-buffer').on('click', function (e) {
                // Stop data actually being pasted into div
                e.stopPropagation();
                e.preventDefault();

                // Do whatever with pasteddata
                navigator.clipboard.readText()
                    .then(text => {
                        console.log('Pasted content: ', text);
                        let aData = text.split("\t");
                        aData.forEach(function (n, i) {
                            if ($($('input.prices')[i]).length) {
                                log(n.replace(/[^0-9,.]/g, '').replace(',', '.'));
                                $($('input.prices')[i]).val(parseFloat(n.replace(/[^0-9,.]/g, '').replace(',', '.'), 10));
                            }
                        });

                    })
                    .catch(err => {
                        console.error('Failed to read clipboard contents: ', err);
                    });
            });

            /**
             * Цены дихол
             **/
            $('#paste-price-dihall').on('click', function (e) {
                // Stop data actually being pasted into div
                e.stopPropagation();
                e.preventDefault();

                let iPrice = parseInt($('input[name="prices[1]"]').val(),10);
                $('input[name="prices[2]"]').val(Math.round(iPrice*1.15));
                $('input[name="prices[3]"]').val(Math.round(iPrice*1.35));
                $('input[name="prices[4]"]').val(Math.round(iPrice*1.55));
                $('input[name="prices[5]"]').val(Math.round(iPrice*1.70));
            });

            /**
             * Скачать картинки с сайта
             */
            $('#upload-from-site').on('click', function (e) {
                if (!e.clientX && !e.clientY) {
                    e.preventDefault();
                    e.stopPropagation();
                    return false;
                }
                ModalShow($('#modal-upload-from-site'));
                return false;
            });
            $('#upload-from-site-start').on('click', function () {
                if (!$('input[name="site_url"]').val()) {
                    ls.msg.error('Введите урл');
                } else {
                    let oBut = $(this);
                    oBut.addClass('ls-loading');
                    ls.ajax.load(ADMIN_URL + 'product/ajax/upload-from-site/', {
                        url: $('input[name="site_url"]').val()
                    }, function (answ) {
                        oBut.removeClass('ls-loading');
                        if (typeof answ.sHtml != 'undefined') {
                            $('#modal-upload-from-site').css({
                                hight: 600,
                                bottom: 0,
                                top: 0
                            });
                            $('#modal-upload-from-site .ls-modal-content').html(answ.sHtml);
                            $('#load-images').on('click', function () {
                                let aImage = [];
                                $(this).addClass('ls-loading');
                                $('#modal-upload-from-site input[type="checkbox"]').each(function () {
                                    if (this.checked) {
                                        aImage.push(this.value);
                                    }
                                });
                                ls.ajax.load(ADMIN_URL + 'product/ajax/upload-images/', {
                                    images: aImage,
                                    product_id: iProductId
                                }, function (answ) {
                                    window.location.reload(true);
                                });
                            });
                        }
                    });
                }
            });

            $(document).bind('keydown', 'ctrl+s', function (e) {
                if (e.ctrlKey && (e.which == 83 || e.which == 13)) {
                    e.preventDefault();
                    $('#product').submit();
                    return false;
                }
            });
            $('.margin-percent-common').on('change', function (e) {
                log(e);
                e.stopPropagation();
                e.preventDefault();
                $('.margin-percent').val($(this).val());
                $('.margin').each(function () {
                    let iG = $(this).data('group'),
                        iPrice = parseInt($('.price' + iG).val(), 10);
                    fMargin = parseFloat($('.margin-percent' + iG).val(), 10) / 100;
                    $(this).val(iPrice * fMargin);
                });
                RecalPrice();
            });
            $('.discount-percent-common').on('change', function () {
                $('.discount-percent').val($(this).val());
                $('.margin').each(function () {
                    let iG = $(this).data('group'),
                        iPrice = parseInt($('.price' + iG).val(), 10);
                    fMargin = parseFloat($('.margin-percent' + iG).val(), 10) / 100;
                    $(this).val(iPrice * fMargin);
                });
                RecalPrice();
            });
            $('.margin-percent').on('change', function () {
                let iG = $(this).data('group'),
                    fDiscount = parseFloat($('.discount'+iG).val(), 10) / 100,
                    iPrice = parseInt($('.price' + iG).val(), 10),
                    iMargin = parseInt(iPrice * parseFloat($(this).val()) / 100, 10),
                    iSum = Math.ceil((iPrice + iMargin) * (1 - fDiscount));
                $('.margin' + iG).val(iMargin);
                $('.summa' + iG).val(iSum);
                if (iSum < iPrice) {
                    $('.summa' + iG).addClass('red');
                } else {
                    $('.summa' + iG).removeClass('red');
                }
            });

            $('.summa').on('change', function () {
                let iG = $(this).data('group'),
                    fDiscount = parseFloat($('.discount'+iG).val(), 10) / 100,
                    iPrice = parseInt($('.price' + iG).val(), 10),
                    iSum = parseInt($(this).val(), 10),
                    iMargin = parseInt(iSum/(1-fDiscount) - iPrice, 10),
                    fMargin = (parseFloat(iMargin / iPrice) * 100).toFixed(2);
                $('.margin' + iG).val(iMargin);
                $('.margin-percent' + iG).val(fMargin);
                $('.summa' + iG).val(iSum);
                if (iSum < iPrice) {
                    $('.summa' + iG).addClass('red');
                } else {
                    $('.summa' + iG).removeClass('red');
                }
            });

            $('.margin').on('change', function () {
                let iG = $(this).data('group'),
                    fDiscount = parseFloat($('.discount' + iG).val(), 10) / 100,
                    iPrice = parseInt($('.price' + iG).val(), 10),
                    iMargin = parseInt($(this).val(), 10),
                    fMargin = (parseFloat(iMargin / iPrice) * 100).toFixed(2),
                    iSum = Math.ceil((iPrice + iMargin) * (1 - fDiscount));
                $('.margin-percent' + iG).val(fMargin);
                $('.summa' + iG).val(iSum);
                if (iSum < iPrice) {
                    $('.summa' + iG).addClass('red');
                } else {
                    $('.summa' + iG).removeClass('red');
                }
            });
            $('.discount-percent').on('change', function () {
                RecalPrice();
            });

            /**
             * Поиск товара или дизайна для товарных групп в карточке
             * @constructor
             */
            $('.search-item').autocompletePro({
                name: 'items',
                url: '/ajax/search/admin/',
                url_search: '/search/',
                name_search: 'q',
                render: function (obj) {
                    var item =
                        '<div class="row dflex flex-align-items-center" data-id="' + obj.id + '" data-type="' + obj.type + '">' +
                        '<img src="' + obj.image + '" width="50">' +
                        '<span class="name">' + obj.name + '</span> ' +
                        '<span class="price"> ' + GetPrice(obj.price, true, true) + '</span>' +
                        '</div>';
                    return item;
                }
            }, function (obj) {
                obj.product_id = iProductId;
                ls.ajax.load(ADMIN_URL + 'product/ajax/group/add-item/', obj, function (answ) {
                    $('.group-items').append(answ.sHtml);
                    BindGroupActions();
                });
            });

            $('.option-check-all').on('click', function () {
                let iOptionId = $(this).data('id');
                if ($('.option'+iOptionId).find('input').length == $('.option'+iOptionId).find('input:checked').length) {
                    $('.option'+iOptionId).find('input:checked').prop('checked', false);
                } else {
                    $('.option'+iOptionId).find('input').prop('checked', true);
                }
            });

            function RecalPrice() {
                $('.margin').each(function () {
                    let iG = $(this).data('group'),
                        fDiscount = parseFloat($('.discount' + iG).val(), 10) / 100,
                        iPrice = parseInt($('.price' + iG).val(), 10),
                        iMargin = parseInt($('.margin' + iG).val(), 10),
                        iSum = Math.ceil((iPrice + iMargin) * (1 - fDiscount));
                    $('.margin' + iG).val(iMargin);
                    $('.summa' + iG).val(iSum);
                    if (iSum < iPrice) {
                        $('.summa' + iG).addClass('red');
                    } else {
                        $('.summa' + iG).removeClass('red');
                    }
                });
            }
    /**
     * Заполняем цены по метражу
     * @param iFabric
     * @constructor
     */
    function FillPrices(iFabric) {
        var iPriceBase = 0;
        var iGroupStep = 100; // шаг группы в рулях
        $('input[name^=prices]').each(function(i) {
            if (i == 0) {
                iPriceBase = parseInt(this.value, 10);
                if (iPriceBase == 0) {
                    iPriceBase = parseInt($($('input[name^=prices]')[1]).val(), 10);
                    log(iPriceBase);
                    if (iPriceBase == 0) {
                        ls.msg.error('Заполните первое значение цены');
                        return false;
                    }
                    $($('input[name^=prices]')[0]).val(iPriceBase)
                    iPriceBase -= iGroupStep*iFabric;
                }
            } else {
                $(this).val(iPriceBase+i*iGroupStep*iFabric);
            }
        });
    }

            function BindGroupActions() {
                $('.group-items input').off('change').on('change', function () {
                    let iId = parseInt($(this).parents('.item').data('id'), 10),
                        sField = $(this).attr('name'),
                        sValue = $(this).val();
                    ls.ajax.load(ADMIN_URL + 'product/ajax/group/update-item/', {
                        id: iId,
                        field: sField,
                        value: sValue
                    }, function (answ) {

                    });
                });
                $('.group-items .ls-icon-remove').off('click').on('click', function () {
                    let oParent = $(this).parents('.item'),
                        iId = parseInt(oParent.data('id'), 10);
                    ls.ajax.load(ADMIN_URL + 'product/ajax/group/remove-item/', {
                        id: iId
                    }, function (answ) {
                        oParent.remove();
                    });
                });
            }

            BindGroupActions();

            $('.product-chars-update').on('click', function () {
                let oBut = $(this);
                oBut.addClass('processing');
                ls.ajax.load(ADMIN_URL + 'product/import-data/update-chars/', oBut.data(), function (answ) {
                    window.location.reload();
                });
                return false;
            });
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}

<style>
    .prices, .margin, .margin-percent, .margin-percent-common, .summa, .discount-percent {
        font-size: 13px !important;
        padding: 10px !important;
    }

    input.red {
        border-color: #d60000 !important;
    }

    .autocomplete-list .row {
        padding-right: 85px;
        position: relative;
    }

    .autocomplete-list .row .name {
        padding-left: 8px;
    }

    .autocomplete-list .row .price {
        position: absolute;
        right: 0;
        top: 8px;
    }

    .group-items .item input {
        margin-right: 20px !important;
        width: 300px !important;
    }
</style>
