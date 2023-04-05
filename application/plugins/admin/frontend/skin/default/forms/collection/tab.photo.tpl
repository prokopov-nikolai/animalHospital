<label for="">Выберите изображения для загрузки</label>
<input type="file" name="photo[]" multiple>
<div class="cl"></div>
<small class="note">Двойной клик на изображение устанавливает главное фото</small>
<div class="dflex sortable">
    {foreach $oCollection->getPhotos() as $oMedia}
        <div class="photo {if $oMedia->getMain()}main{/if}" data-id="{$oMedia->getId()}">
            <img src="{$oMedia->getFileWebPath('300x')}" alt="">
            {component field template='text'
            classes         = 'photo-alt'
            label           = 'Название'
            value           = $oMedia->getAlt()}
            {component field template='select'
            label           = 'Цвет'
            name            = 'color'
            items           = Config::Get('colors')
            isMultiple      = true
            selectedValue   = $oMedia->getColorArray()}
            <div class="ls-field">
                <label for="" class="ls-label">Ширина:</label>
                {$oMedia->getWidth()|number_format:0:',':' '} px
            </div>
            <div class="ls-field">
                <label for="" class="ls-label">Размер:</label>
                {($oMedia->getFileSize()/1000)|ceil|number_format:0:',':' '} kb
            </div>
            <div class="remove"></div>
            <div class="update" data-tooltip="Обновить изображение"></div>
        </div>
    {/foreach}
</div>
<div class="cl" style="height: 50px;"></div>
<input type="file" id="fabric-edit" class="dn">

{capture name='script'}
    <script>
        var bIsBlocked = false,
        iFabricId = 0,
        oPhoto = {};
        $(function () {
            $('.photo input[type="text"]').change(function () {
                var sAlt = $(this).val();
                var iId = $(this).parents('.photo').data('id');
                ls.ajax.load(ADMIN_URL + 'collection/ajax/media/update/', {
                    alt: sAlt,
                    id: iId
                });
            });
            $('.photo select[name="color"]').change(function () {
                var sColor = $(this).val();
                var iId = $(this).parents('.photo').data('id');
                ls.ajax.load(ADMIN_URL + 'collection/ajax/media/update/', {
                    color: sColor,
                    id: iId
                });
            });
            $('.photo').on('dblclick', function () {
                var iId = $(this).data('id');
                ls.ajax.load(ADMIN_URL + 'collection/ajax/media/update/', {
                    main: 1,
                    id: iId,
                    collection_id: iCollectionId
                });
                $(this).parent().find('.main').removeClass('main');
                $(this).addClass('main');
            });
            $('.sortable').sortable({
                stop: function () {
                    if (bIsBlocked) return false;
                    var aPhoto = [];
                    $('.photo').each(function () {
                        aPhoto.push($(this).data('id'));
                    });
                    ls.ajax.load(ADMIN_URL + 'collection/ajax/media/sort/', {
                        sort: aPhoto,
                    });
                }
            });
            $('.photo .remove').on('click', function () {
                if (confirm('Удалить? Уверены?')) {
                    var oPhoto = $(this).parents('.photo');
                    var iMediaId = oPhoto.data('id');
                    ls.ajax.load(ADMIN_URL + 'collection/ajax/media/remove/', {
                        id: iMediaId,
                    }, function () {
                        oPhoto.fadeOut()
                    });
                }
            });

            /**
             * Обновляем изображение
             */
            $('.photo .update').on('click', function () {
                bIsBlocked = true;
                oPhoto = $(this).parents('.photo');
                iFabricId = parseInt(oPhoto.data('id'));
                $('#fabric-edit').trigger('click');
            });
            $('#fabric-edit').change(function (e) {
                handleFileSelect(e, this);
            });

            function handleFileSelect(evt, obj) {
                // $(obj).parent().find('.preloader').remove();
                // var oPreloader = $('<div/>').addClass('preloader').html('<span></span>');
                var files = evt.target.files; // FileList object
                var that = null;
                // var oBut = $(obj).parent().find('button');
                // Loop through the FileList and render image files as thumbnails.
                var f = files[0];
                // oBut.before(oPreloader).hide();
                // oPreloader.fadeIn();
                if (f.type.match('image/jpeg') || f.type.match('image/jpg')) {
                    if (f.size > 2 * 1024 * 1024) {
                        alert('Размер файла больше 2 Мбайт');
                    } else {
                        that = f;
                        $.get('/blank.html', {}, function () {
                            var http = new XMLHttpRequest(); // Создаем объект XHR, через который далее скинем файлы на сервер.
                            // Процесс загрузки
                            if (http.upload && http.upload.addEventListener) {
                                http.onreadystatechange = function () {
                                    // Действия после загрузки файлов
                                    if (this.readyState == 4) { // Считываем только 4 результат, так как их 4 штуки и полная инфа о загрузке находится
                                        bIsBlocked = false;
                                        if (this.status == 200) { // Если все прошло гладко
                                            oAnswer = $.parseJSON(http.responseText);
                                            if (oAnswer.bStateError === false) {
                                                // очистим файлы
                                                evt.target.value = null;
                                                oPhoto.find('img').attr('src', oAnswer.sImgUrlWidth300+'?'+Math.random());
                                                ls.msg.notice(oAnswer.sMsg);
                                            }
                                        } else {
                                            // Сообщаем об ошибке загрузки либо предпринимаем меры.
                                        }
                                    }
                                };
                            }
                            var form = new FormData(); // Создаем объект формы.
                            form.append('iFabricId', iFabricId);
                            form.append('security_ls_key', LIVESTREET_SECURITY_KEY);
                            form.append('photo', f); // Прикрепляем к форме все загружаемые файлы.
                            http.open('POST', ADMIN_URL + 'media/ajax/change/'); // Открываем коннект до сервера.
                            http.send(form); // И отправляем форму, в которой наши файлы. Через XHR.
                        });
                    }
                } else {
                    alert('Выберите фото в формате jpg');
                }

            }
        });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.script)}