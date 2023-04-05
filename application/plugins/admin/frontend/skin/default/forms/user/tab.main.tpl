{if $oUser->getId()}
    <div class="ls-field ls-clearfix">
        <label class="ls-field-label">Зарегистрирован</label>
        <div class="ls-field  pt-8">{$oUser->getDateCreate()|date_format:'d.m.Y'}</div>
    </div>
{/if}

{component 'field' template='file'
label = 'Фото'
name  = 'user_photo'}

{if $sUrl = $oUser->getPhotoWebPath('100x')}
    <img src="{$sUrl}" alt="">
{/if}

{component 'field' template='text'
label = 'Имя'
name  = 'user[fio]'
value = $oUser->getFio()}

{component 'field' template='text'
label = 'Телефон'
name  = 'user[phone]'
value = $oUser->getPhone()}

{component 'field' template='text'
label = 'Телефон (доп.)'
name  = 'user[phone_dop]'
value = $oUser->getPhoneDop()}

{component 'field' template='text'
label = 'Email'
name  = 'user[email]'
value = $oUser->getEmail()}

{component 'field' template='text'
label = ($oUser->getId()) ? 'Новый пароль' : 'Пароль'
name  = ($oUser->getId()) ? 'new_pass' : 'user[password]'
value = ''}


{component 'field' template='checkbox'
label = 'Администратор'
name = 'user[is_admin]'
checked = $oUser->getIsAdmin()}

{component 'field' template='checkbox'
label = 'Активен'
name = 'user[activate]'
checked = $oUser->getActivate()}



<div class="cl" style="height: 20px;"></div>
{component 'field' template='textarea'
label = 'Комментарий'
name  = 'user[comment]'
rows  = 5
value = $oUser->getComment()}
