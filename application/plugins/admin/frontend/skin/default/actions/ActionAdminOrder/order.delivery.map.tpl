{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$bHideMenu = true}
    {$sBodyClasses = 'delivery-map'}
{/block}

{block name='layout_head_end'} {/block}

{block name='layout_content'}
    <h2>Доставка{if $sDate}  {$sDate} {/if}</h2>
    <div id="delivery-map"></div>
{/block}



{block name='scripts' append}
    {foreach $aOrder as $oOrder}

    {/foreach}
    <script src="//api-maps.yandex.ru/2.1/?lang=ru_RU&apikey=a2e77dc2-db83-44ed-aeaa-0078eaa591dc"></script>
    <script>
        if (typeof ymaps != 'undefined') {
            ymaps.ready(init);
            let myMap,
                myPlacemark;

            function init() {
                let myMap = new ymaps.Map("delivery-map", {
                        center: [55.76, 37.64],
                        zoom: 12,
                        controls: ['zoomControl', 'searchControl', 'fullscreenControl', 'geolocationControl']
                    }),
                    objectManager = new ymaps.ObjectManager({
                        // Чтобы метки начали кластеризоваться, выставляем опцию.
                        clusterize: true,
                        // ObjectManager принимает те же опции, что и кластеризатор.
                        gridSize: 32,
                        clusterDisableClickZoom: true
                    });

                // Чтобы задать опции одиночным объектам и кластерам,
                // обратимся к дочерним коллекциям ObjectManager.
                objectManager.clusters.options.set('preset', 'islands#redClusterIcons');
                objectManager.objects.options.set('preset', 'islands#redDotIcon');
                objectManager.objects.events.add('click', function (e) {
                    let oInt = window.setInterval(function () {
                        if ($('.ajax-save').length > 0) {
                            clearInterval(oInt);
                            log('clearInterval oInt');
                            $('.ajax-save').on('change', function () {
                                let oData = {
                                    iOrderId: $(this).data('order_id'),
                                    sField: $(this).data('field'),
                                    sValue: $(this).val().toString()
                                };
                                let sTextConfirm = $(this).data('confirm');
                                let bReturn = false;
                                if (sTextConfirm) {
                                    bReturn = !confirm(sTextConfirm + ' ' + sValue);
                                }
                                if (!bReturn) {
                                    ls.ajax.load(ADMIN_URL + 'order/ajax/change/', oData);
                                }
                            });
                        }
                    }, 300);
                });

                // objectManager.objects.options.set('iconLayout', 'default#image');
                // objectManager.objects.options.set('iconImageHref', 'http://www.magnit-info.ru/bitrix/templates/magnit_new/img/mm-logo.svg');

                log({$aPoint|json_encode});
                // objectManager.objects.options.iconImageSize(10,10);
                myMap.geoObjects.add(objectManager);
                objectManager.add({$aPoint|json_encode});
            }
        }
    </script>
    <script>
        $(function () {

        });
    </script>
{/block}