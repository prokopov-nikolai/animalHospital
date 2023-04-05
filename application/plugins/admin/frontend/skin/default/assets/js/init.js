/**
 * Урл админки
 */
jQuery.browser = {};
$(function () {
    jQuery.browser.msie = false;
    jQuery.browser.version = 0;
    if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
        jQuery.browser.msie = true;
        jQuery.browser.version = RegExp.$1;
    }

    /**
     * Авторизация/регистрация
     */
    ls.auth ? ls.auth.init() : '';
    /**
     * Вкладки
     */
    $('.ls-tabs').lsTabs();

    /**
     * Редактор
     */
    var aEditor = [];
    $('textarea.ace-redactor').each(function () {
        var $this = $(this);
        var editor = ace.edit($this.data('redactor-id'));
        document.getElementById($this.data('redactor-id')).style.fontSize = '16px';
        editor.session.setMode("ace/mode/html");
        // enable emmet on the current editor
        editor.setOption("enableEmmet", true);
        editor.insert($this.val());
        editor.getSession().on('change', function (e) {
            $this.val(editor.getValue());
        });
        aEditor.push(editor);
    });

//	$('.js-editor-default').lsEditor();
    window.setTimeout(function () {
        $('.ls-alert').each(function(){
            if ($(this).find('.js-ls-alert-close').length == 0)$(this).slideToggle();
        });
    }, 3000);
    $('.ls-alert .js-ls-alert-close').on('click', function(){
        $(this).parents('.ls-alert').slideToggle();
    });

    $('.ls-tab').bind('click.tab', function () {
        window.location.hash = '#tab' + $(this).index();
    });

    var at = window.location.hash.match(/tab(\d+)/);
    if (at) {
        window.setTimeout(function () {
            $($('.ls-tab')[at[1]]).click();
        }, 100);
    }

    /**
     * Календарь
     * @type {*|{}}
     */
    $('.ls-field--date input').each(function(){
        var field = this;
        var oPicker = new Pikaday({
            field: field,
            defaultDate : moment(field).format("DD.MMM.YYYYY"),
            format: 'DD.MM.YYYY',
            yearRange: [2020,2024],
            firstDay: 1,
            i18n: window.PikadayConfig.i18n.ru
        });
    });
    // $('.ls-field--datetime input').datetimepicker({
    //     format:'d.m.Y H:i',
    //     inline:false,
    //     dayOfWeekStart: 1,
    // });

    // $('.ls-field--datetime input').datepicker({
    //     changeMonth           : true,
    //     changeYear            : true,
    //     firstDay              : 1,
    //     changeFirstDay        : false,
    //     navigationAsDateFormat: false,
    //     duration              : 0,
    //     onSelect              : function () {
    //         datepickerYaproSetTime();
    //     }
    //
    // }).click(function () {
    //     $(".datepickerYaproSelected").removeClass("datepickerYaproSelected");
    //     $(this).addClass("datepickerYaproSelected");
    //     datepickerYaproSetClockSelect();
    // });

    $('.menu-show ').on('click', function(){
        $('body').toggleClass('aside-hide');
        $('body').toggleClass('menu-fixed');
        $('section').toggleClass('opened');
        $(this).toggleClass('hided');
    });

});

if (typeof log !== 'function') {
    function log(a) {
        window.console.log(a);
    }
}
