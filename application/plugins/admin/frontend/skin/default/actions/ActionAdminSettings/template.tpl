{extends file="{$aTemplatePathPlugin.admin}layouts/layout.base.tpl"}

{block name='layout_options'}
    {$sMenuSelect = 'settings'}
    {$sMenuSelectSub = 'settings_template'}
{/block}

{block name='layout_content'}
    <h1>Настройки шаблона</h1>
    <form action="" method="post">

        {component field template='text'
        name    ='template[phone]'
        label   ='Номер телефона'
        value   = (isset($aTemplate['phone'])) ? $aTemplate['phone'] : ''
        classes = 'w3'}

        {component field template='text'
        name    ='template[work_time]'
        label   ='График работы'
        value   = (isset($aTemplate['work_time'])) ? $aTemplate['work_time'] : ''
        classes = 'w3'}

        {component field template='email'
        name    ='template[email]'
        label   ='Email'
        value   = (isset($aTemplate['email'])) ? $aTemplate['email'] : ''
        classes = 'w3'}
        {component button text='Сохранить'}
    </form>
{/block}