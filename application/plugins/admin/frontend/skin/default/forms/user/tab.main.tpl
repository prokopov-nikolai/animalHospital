<div class="ls-field ls-clearfix">
    <label class="ls-field-label">Зарегистрирован</label>
    <div class="ls-field  pt-8">{$oUser->getDateCreate()|date_format:'d.m.Y'}</div>
</div>

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
label = 'Новый пароль'
name  = 'new_pass'
value = ''}

<div class="ls-field  ls-clearfix">
    <label class="ls-field-label" for="">Telegram chat id</label>
    <div class="ls-field pt-8">{($oUser->getTelegramChatId()) ? $oUser->getTelegramChatId() : 0}</div>
</div>


{component 'field' template='checkbox'
label = 'Администратор'
name = 'user[is_admin]'
checked = $oUser->getIsAdmin()}

{component 'field' template='checkbox'
label = 'Агент'
name = 'user[is_agent]'
checked = $oUser->getIsAgent()}

{component 'field' template='checkbox'
label = 'Менеджер'
name = 'user[is_manager]'
checked = $oUser->getIsManager()}

{component 'field' template='checkbox'
label = 'Активен'
name = 'user[activate]'
checked = $oUser->getActivate()}

{if LS::HasRight('19_user_public_key')}
    <div class="cl h20"></div>
{component 'field' template='text'
label = 'public_key'
name  = 'user[public_key]'
value = $oUser->getPublicKey()}
{/if}
{if LS::HasRight('19_user_public_key')}
    {component 'field' template='text'
    label = 'Сайт'
    name  = 'user[site]'
    value = $oUser->getSite()
    note  = 'По названию сайта ищется вотемарк в папке watermark'}
{/if}

<div class="cl" style="height: 20px;"></div>
{component 'field' template='textarea'
label = 'Комментарий'
name  = 'user[comment]'
rows  = 5
value = $oUser->getComment()}
