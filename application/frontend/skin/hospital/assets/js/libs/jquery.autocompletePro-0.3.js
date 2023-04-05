/*
 * @name   Plugin for jquery "AutocompletePro"
 * @author Николай Прокопов
 * @site   http://www.prokopov-nikolai.ru
 * @version v 0.3
 * @date 16.04.2012
 */
var iPad = iPad || /iPad/.test(navigator.userAgent) && !window.MSStream;
(function ($) {
    $.fn.autocompletePro = function (options, callback, callback1) {
        return $(this).each(function () {
            var settings = {
                type: 'post',
                name: null,
                url: null,
                url_search: null, // переадресация на поиск если не выбран элемент
                data: {},
                minLength: 2,
                name_search: 'q',
                render: function (item) {
                    return item;
                }
            };
            if (options) {
                $.extend(settings, options);
            }
            // обернем элемент
            var el = this;
            if (el.autocompleteApplied !== true) {
                this.autocompleteApplied = true;
                $(el).wrap('<div/>');
                el.wrap = $(el).parent();
                el.wrap.css({display: 'inline-block'});
                el.wrap.addClass($(this).attr('name'));
                el.wrap.addClass('autocomplete-wrap');
                // добавим список автокомплита
                el.$list = $('<ul/>');
                el.$list.addClass('autocomplete-list');
                el.$list.css({
                    'background': '#fff',
                    'display': 'none'
                });
                el.wrap.append(el.$list);
                $(el).after(el.$list);
                $(el).attr('autocomplete', 'off');
                if (settings['name'] !== null) {
                    el.name = settings['name'];
                }
                el.$list = $(el).parent().find('ul');
                el.count = el.$list.find('li').length - 1;
                el.current = -1;
                // будем скрывать список при клике не на нем
                $(document.body).click(function (e) {
                    el.$list.hide();
                });
                $(el).click(function (e) {
                    e.stopPropagation();
                });
//				$(el).blur(function (event) {
//					el.$list.hide();
//					return true;
//				});
                $(el).on('keyup.autocomplete', function (event) {
                    var inp = $(this);
                    if (inp.val().length < settings['minLength']) {
                        el.$list.hide();
                        return true;
                    }
                    var $item = '';
                    // если нажата кнопка tab
                    if (event.which == 9) {
                        el.$list.hide();
                        return true;
                    }
                    if (event.keyCode == 38) {
                        // если нажата кнопка вверх
                        --el.current;
                        if (el.current < 0) {
                            el.current = el.count;
                        }
                        $item = el.$list.find('li:eq(' + el.current + ')');
                        el.$list.find('li.active').removeClass('active');
                        $item.addClass('active');
//						if (typeof options.render == 'function') {
//							if (el.$list.find('li.active').html()) {
//								inp.val(el.$list.find('li.active').html().replace(/<[^>]+[>]+/g, ""));
//							}
//						}
                    } else if (event.keyCode == 40) {
                        // если нажата кнопка вниз
                        ++el.current;
                        if (el.current > el.count) {
                            el.current = 0;
                        }

                        $('li.active', el.$list).removeClass('active');
                        $item = $('li:eq(' + el.current + ')', el.$list).first('li').addClass('active');

//						if (typeof options.render == 'function') {
//							if (el.$list.find('li.active').html()) {
//								inp.val(el.$list.find('li.active').html().replace(/<[^>]+[>]+/g, ""));
//							}
//						}
                    } else if (event.keyCode == 13) {
                        if (typeof callback == 'function') {
                            // если нажали ентер
                            //inp.val('');
                            if (el.$list.find('li.active').length)
                            {
                                callback.apply(el, [el.$list.find('li.active')[0].raw_object]);
                            } else {
                                // переадресация на поиск если не выбран элемент
                                log(settings.url_search);
                                window.location.href = settings.url_search+'?search='+encodeURIComponent(el.value);
                            }
                            return false;
                        }
                        el.$list.hide();
                    } else if (inp.val().length >= settings['minLength']) {
                        var type = settings['type'];
                        var url = settings['url'];
                        if (url === null) {
                            url = inp.attr('data-url');
                        }
                        var oData = settings['data'];
                        oData[settings.name_search] = inp.val();
                        oData.security_ls_key = LIVESTREET_SECURITY_KEY;

                        $.ajax({
                            type: type,
                            url: url,
                            data: oData,
                            dataType: 'json',
                            success: function (answ) {
                                el.$list.remove();
                                el.$list = $('<ul/>');
                                el.$list.addClass('autocomplete-list');
                                el.$list.css({
                                    'background': '#fff',
                                    'display': 'none'
                                });
                                el.wrap.append(el.$list);
                                // window.setTimeout(function(){ el.$list.mCustomScrollbar(); }, 50);
                                if (answ[el.name] && answ[el.name].length > 0) {
                                    // рендерим результат
                                    el.$list.css('display', 'block');
                                    for (key in answ[el.name]) {
                                        var li = document.createElement('li');
                                        li.raw_object = answ[el.name][key];
                                        $(li).html(settings['render'](answ[el.name][key]));
                                        el.$list.append(li);
                                    }
                                    el.count = el.$list.find('li').length - 1;
                                    el.current = -1;
                                    el.$list.find('li').bind('mouseenter', function () {
                                        if (iPad) {
                                            if (typeof callback == 'function') {
                                                // если нажали ентер
                                                //inp.val('');
                                                callback.apply(el, [this.raw_object]);
                                            }
                                        }
                                        el.$list.find('li.active').removeClass('active');
                                        $(this).addClass('active');
                                        el.current = $(this).index();
                                    });
                                    el.$list.find('li').bind('mouseleave', function () {
                                        $(this).removeClass('active');
                                        el.current = $(this).index();
                                    });
                                    el.$list.find('li').bind('click', function () {
                                        if (typeof callback == 'function') {
                                            callback.apply(el, [this.raw_object, this]);
                                        }
                                        el.$list.hide();
                                        return false;
                                    });
                                    el.$list.find('.item').bind('click', function (e) {
                                        e.stopPropagation();
                                        if (typeof callback == 'function') {
                                            callback.apply(el, [$(this).parents('li')[0].raw_object, this]);
                                        }
                                        el.$list.hide();
                                        return false;
                                    });


                                    // el.$list.find('li .item').bind('click', function () {
                                    //     if (typeof callback1 == 'function') {
                                    //         //inp.val('');
                                    //         callback.apply(el, [this.raw_object, this]);
                                    //     }
                                    //     el.$list.hide();
                                    // });
                                } else {
                                    el.$list.css('display', 'none');
                                }
                            }
                        });
                    }
                    return true;
                });
            }
            return true;
        });
    };
})(jQuery);

