{if $oPet->getId()}
    <div class="ls-field ls-clearfix">
        <label class="ls-field-label">Зарегистрирован</label>
        <div class="ls-field  pt-8">{$oPet->getDateCreate()|date_format:'d.m.Y'}</div>
    </div>
{/if}

{component 'field' template='file'
label = 'Фото'
name  = 'pet_photo'}

{if $sUrl = $oPet->getPhotoWebPath('100x')}
    <img src="{$sUrl}" alt="">
{/if}

{component 'field' template='text'
label = 'Кличка'
name  = 'pet[nickname]'
value = $oPet->getNickname()}

{component field template='select'
label = 'Вид питомца'
items = $aPetsSpeciesItems
name = 'pet[species]'
selectedValue = $oPet->getSpecies()}

<div class="ls-field ls-clearfix">
    <label for="" class="ls-field-label">Хозяин</label>
    <div class="ls-field-holder pet-user">
        {if $oPet->getUserId()}
            <a href="{$ADMIN_URL}users/{$oPet->getUserId()}/">{$oPet->getUserFio()}</a>
        {elseif $oUser}
            <a href="{$ADMIN_URL}users/{$oUser->getId()}/">{$oUser->getFio()}</a>
            <input type="hidden" name="pet[user_id]" id="pet-user-id" value="{$oUser->getId()}">
        {else}
            <input type="text" class="user autocomplete-pro" value="{$oPet->getUserFio()}">
            <input type="hidden" name="pet[user_id]" id="pet-user-id" value="{$oPet->getUserId()}">
        {/if}

    </div>
</div>

<div class="cl" style="height: 20px;"></div>
{component 'field' template='textarea'
label = 'Комментарий'
name  = 'pet[comment]'
rows  = 5
value = $oPet->getComment()}
