{**
 * Форма восстановления пароля
 *}

{component_define_params params=[ 'modal' ]}

<form action="{router page='auth'}password-reset/{$code}/" method="post" class="js-form-validate js-auth-reset-password-form{if $modal}-modal{/if}">
    {component 'field' template='text'
    name         = 'password'
    type         = 'password'
    rules        = [ 'required' => true, 'minlength' => '5' ]
    label        = $aLang.auth.labels.password
    inputClasses = 'js-input-password-reg'}

    {* Повторите пароль *}
    {component 'field' template='text'
    name   = 'password_confirm'
    type   = 'password'
    rules  = [ 'required' => true, 'minlength' => '5', 'equalto' => '.js-input-password-reg' ]
    label  = $aLang.auth.registration.form.fields.password_confirm.label}
    <br>
    {component 'button' name='submit_reset' mods='primary' text='Изменить пароль'}
</form>