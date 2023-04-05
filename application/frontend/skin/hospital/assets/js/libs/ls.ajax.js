var ls = ls || {};
ls.ajax = ls.ajax || {};
ls.ajax.load = function(url, data, success, error){
    data.security_ls_key = LIVESTREET_SECURITY_KEY;
    $.ajax({
        url: url,
        type: 'post',
        dataType: 'json',
        data: data,
        success: function(answ) {
            if (answ.bStateError === true) {
                ls.msg.error(answ.sMsg, answ.sMsgTitle);
                if ($.isFunction( error )) error.apply( this, arguments );
            } else {
                if (answ.sMsg || answ.sMsgTitle) ls.msg.notice(answ.sMsg, answ.sMsgTitle);
                if (typeof success == 'function') {
                    success(answ);
                }
            }
        },
        error: function(answ)
        {
            if (typeof answ.responseJSON != 'undefined') {
                answ = answ.responseJSON;
                ls.msg.error(answ.sMsg, answ.sMsgTitle);
            }
        }
    });
};

ls.ajax.form = function(url, form, callback, more) {
    var form = typeof form == 'string' ? $(form) : form;

    form.on('submit', function (e) {
        ls.ajax.submit(url, form, callback, more);
        e.preventDefault();
    });
};

ls.ajax.submit = function(url, form, callback, more) {
    var more = more || {},
        form = typeof form == 'string' ? $(form) : form,
        buttonSubmit = form.find('[type=submit]').eq(0),
        button = more.submitButton || (buttonSubmit.length && buttonSubmit) || $('button[form=' + form.attr('id') + ']'),
        params = more.params || {},
        lock = typeof more.lock === 'undefined' ? true : more.lock;

    more.showNotices = typeof more.showNotices === 'undefined' ? true : more.showNotices;
    more.showProgress = typeof more.showProgress === 'undefined' ? true : more.showProgress;

    if ( more.showProgress ) {
        NProgress.start();
    }

    if ( typeof LIVESTREET_SECURITY_KEY !== 'undefined' ) params.security_ls_key = LIVESTREET_SECURITY_KEY;

    if (url.indexOf('http://') != 0 && url.indexOf('https://') != 0 && url.indexOf('/') != 0) {
        url = aRouter['ajax'] + url + '/';
    }

    if ($.isFunction(form.parsley)) {
        form.parsley().off('form:validate', ls.ajax.onFormValidate);
        form.parsley().on('form:validate', ls.ajax.onFormValidate);
    }

    var options = {
        type: 'POST',
        url: url,
        dataType: more.dataType || 'json',
        data: params,
        beforeSubmit: function (arr, form, options) {
            if ( lock ) ls.utils.formLock( form );
            button && button.prop('disabled', true).addClass(ls.options.classes.states.loading);

            // Сбрасываем текущие ошибки
            this.clearFieldErrors(form);
        }.bind(this),
        beforeSerialize: function (form, options) {
            if (typeof more.validate == 'undefined' || more.validate === true) {
                var res=form.parsley('validate');
                if (!res) {
                    NProgress.done();
                    if ( $.isFunction( more.onValidateFail ) ) more.onValidateFail.apply( this, arguments );
                }
                return res;
            }

            return true;
        },
        success: function (response, status, xhr, form) {
            if ( response.bStateError ) {
                if ( response.errors ) {
                    this.showFieldErrors(form, response.errors);
                    grecaptcha.reset();
                } else {
                    if ( more.showNotices ) {
                        if ( response.sMsgTitle || response.sMsg )
                            ls.msg.error( response.sMsgTitle, response.sMsg );
                    } else {
                        if ( response.is_form_error && ( response.sMsgTitle || response.sMsg ) )
                            this.showFormAlert(form, response.sMsgTitle, response.sMsg);
                    }
                }

                if ( $.isFunction( more.onError ) ) more.onError.apply( this, arguments );
            } else {
                if ( more.showNotices && ( response.sMsgTitle || response.sMsg ) ) ls.msg.notice( response.sMsgTitle, response.sMsg );
                if ( $.isFunction( callback ) ) callback.apply( this, arguments );
            }

            response.sUrlRedirect && (window.location = response.sUrlRedirect);
            response.bRefresh && (window.location.reload());

            if ( $.isFunction( more.onResponse ) ) more.onResponse.apply( this, arguments );
        }.bind(this),
        error: function(msg){
            if ( $.isFunction( more.onError ) ) more.onError.apply( this, arguments );
        }.bind(this),
        complete: function() {
            NProgress.done();
            button.prop('disabled', false).removeClass(ls.options.classes.states.loading);

            if ( $.isFunction( more.onComplete ) ) more.onComplete.apply( this, arguments );
            if ( lock ) ls.utils.formUnlock( form );
        }.bind(this)
    };

    form.ajaxSubmit(options);

    /**
     *
     */
    this.showFieldErrors = function (form, errors) {
        var fieldsForClearError = [];

        $.each(errors, function(key, field) {
            var input = form.find('[name="' + key + '"]');

            if (input.length && input.parsley()) {
                input.parsley().addError(key, { message: field.join('<br>') });

                // Сохраняем для следующего сброса
                fieldsForClearError.push(key);
            }
        });

        form.data('fieldsForClearError', fieldsForClearError);
    };
};
ls.ajax.clearFieldErrors = function (form) {
    var fieldsForClearError = form.data('fieldsForClearError');

    if (fieldsForClearError && fieldsForClearError.length) {
        $.each(fieldsForClearError, function (k, v) {
            var parsley = form.find('[name="' + v + '"]').parsley();

            if (parsley) parsley.removeError(v);
        });
    }
};
ls.options = {
    selectors: {
        alert: '.js-ajax-form-alert'
    },
    html: {
        alert: function (title, text) {
            return '<div class="ls-alert ls-alert--error js-ajax-form-alert">' +
                (title ? '<h4 class="ls-alert-title">' + title + '</h4>' : '') +
                (text ? '<div class="ls-alert-body">' + text + '</div>' : '') +
                '</div>';
        }
    },
    classes: {
        states: {
            active: 'active',
            loading: 'ls-loading',
            open: 'open'
        }
    }
};
