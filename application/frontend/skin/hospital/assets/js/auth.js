$(function(){
    /* Авторизация */
    $('.js-auth-login-form, .js-auth-login-form-modal').on('submit', function (e) {
        ls.ajax.submit(aRouter.auth + 'ajax-login/', $(this), function ( response ) {
            response.sUrlRedirect && (window.location = response.sUrlRedirect);
        });

        e.preventDefault();
    });

    /* Регистрация */
    $('.js-auth-registration-form, .js-auth-registration-form-modal').on('submit', function (e) {
        ls.ajax.submit(aRouter.auth + 'ajax-register/', $(this), function ( response ) {
            response.sUrlRedirect && (window.location = response.sUrlRedirect);
        });

        e.preventDefault();
    });

    /* Восстановление пароля */
    $('.js-auth-reset-form, .js-auth-reset-form-modal').on('submit', function (e) {
        ls.ajax.submit(aRouter.auth + 'ajax-password-reset/', $(this), function ( response ) {
            response.sUrlRedirect && (window.location = response.sUrlRedirect);
        });

        e.preventDefault();
    });

    /* Восстановление пароля */
    $('.js-auth-reset-password-form, .js-auth-reset-password-form-modal').on('submit', function (e) {
        ls.ajax.submit($(this).attr('action'), $(this), function ( response ) {
            response.sUrlRedirect && (window.location = response.sUrlRedirect);
        });

        e.preventDefault();
    });

    /* Повторный запрос на ссылку активации */
    ls.ajax.form(aRouter.auth + 'ajax-reactivation/', '.js-form-reactivation', function (result, status, xhr, form) {
        form.find('input').val('');
        ls.hook.run('ls_user_reactivation_after', [form, result]);
    });
});