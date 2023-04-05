{**
 * Базовый шаблона e-mail'а
 *}

{$backgroundColor = 'F4F4F4'}           {* Цвет фона *}

{$containerBorderColor = 'D0D6E8'}      {* Цвет границ основного контейнера *}

{$headerBackgroundColor = 'FFFFFF'}     {* Цвет фона шапки *}
{$headerTitleColor = 'FFFFFF'}          {* Цвет заголовка в шапке *}
{$headerDescriptionColor = 'B8C5E1'}    {* Цвет описания в шапке *}

{$contentBackgroundColor = 'FFFFFF'}    {* Цвет фона содержимого письма *}
{$contentTitleColor = '000000'}         {* Цвет заголовка *}
{$contentTextColor = '4f4f4f'}          {* Цвет текста *}

{$footerBackgroundColor = '1B94A6'}     {* Цвет фона футера *}
{$footerTextColor = 'fff'}           {* Цвет текста в футере *}
{$footerLinkColor = 'fff'}           {* Цвет ссылки в футере *}

{* Путь до папки с изображенями *}
{$imagesDir = "{$LS->Component_GetWebPath('email')}/images"}

{component_define_params params=[ 'title', 'content' ]}

{* Фон *}
<table width="100%" align="center" bgcolor="#{$backgroundColor}" cellpadding="0" cellspacing="0" style="border-collapse: collapse;">
    <tr><td>
        <br />
        <br />

        {* Основной контейнер *}
        <table width="573" align="center" cellpadding="0" cellspacing="0" style="border-collapse: collapse; font: normal 13px/1.4em Verdana, Arial; color: #4f4f4f; border: 1px solid #{$containerBorderColor};">
            {* Шапка *}
            <tr>
                <td>
                    <table width="100%" bgcolor="#{$headerBackgroundColor}" cellpadding="50" cellspacing="0" style="border-collapse: collapse;">
                        <tr>
                            <td style="font-size: 11px; line-height: 1em;">
                                <a href="{Config::Get('path.root.web')}">
                                 <img src="{$imagesDir}/logo.png" alt="" style="width: 219px;"/>
                                </a>
                            </td>
                            <td align="right">
                                <a href="tel:{$sPhone|NormalizePhone}" style="display:block; width: 320px; font-size: 26px; color: #000; text-decoration: none; ">{$sPhone}</a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>

            {* Контент *}
            <tr>
                <td>
                    <table width="100%" cellpadding="50" cellspacing="0" bgcolor="#{$contentBackgroundColor}" style="border-collapse: collapse;">
                        <tr>
                            <td valign="top">
                                <table width="100%" cellpadding="0" cellspacing="0" style="border-collapse: collapse; font: normal 13px/1.4em Verdana, Arial; color: #{$contentTextColor};">
                                    {* Заголовок *}
                                    {if $title}
                                        <tr>
                                            <td valign="top">
                                                <span style="font: normal 19px Arial; line-height: 1.3em; color: #{$contentTitleColor}">{$title}</span>
                                            </td>
                                        </tr>
                                        <tr><td height="10"><div style="line-height: 0;"><img src="{$imagesDir}../../../../index.php" width="15" height="15"/></div></td></tr>
                                    {/if}

                                    {* Текст *}
                                    <tr>
                                        <td valign="top">
                                            {block 'content'}{/block}
                                            {$content}
{*                                            <br>*}
{*                                            <br>*}
{*                                            {$aLang.emails.common.regards} <a href="{Router::GetPath('/')}">{Config::Get('view.name')}</a>*}
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    {* Подвал *}
                    <table width="100%" bgcolor="#{$footerBackgroundColor}" cellpadding="20" cellspacing="0" style="border-collapse: collapse; font: normal 11px Verdana, Arial; line-height: 1.3em; color: #{$footerTextColor};">
                        <tr>
                            <td>
                                <a href="{Config::Get('path.root.web')}">
                                    <img src="{$imagesDir}/logo-white.png?v2" alt="" style="width: 200px;"/>
                                </a>
                            </td>
                            <td>
                                <a href="{Config::Get('path.root.web')}/pryamye-divany/" style="color: #fff;">Прямые диваны</a>
                                <br>&nbsp;
                                <br><a href="{Config::Get('path.root.web')}/uglovye-divany/" style="color: #fff;">Угловые диваны</a>

                            </td>
                            <td>
                                <a href="{Config::Get('path.root.web')}/tahty/" style="color: #fff;">Тахты</a>
                                <br>&nbsp;
                                <br><a href="{Config::Get('path.root.web')}/kresla/" style="color: #fff;">Кресла</a>
                            </td>
                            <td>
                                <img src="{$imagesDir}/phone.png" alt="" width="10" style="margin: 0 5px 0 0;"><a href="tel:{$sPhone|NormalizePhone}" style="font-size: 13px; color: #fff; text-decoration: none; ">{$sPhone}</a><br>
                                <br>&nbsp;
                                <img src="{$imagesDir}/email.png" alt="" width="10" style="margin: 0 5px 0 0;"><a href="mailto:zakaz@fisher-store.ru" style="font-size: 13px; color: #fff; text-decoration: none; ">zakaz@fisher-store.ru</a><br>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                © Все права защищены. {$smarty.now|date_format:'Y'} г.
                                &nbsp;&nbsp;&nbsp;
                                <a href="{Config::Get('path.root.web')}/politika/" style="color: #fff;">Политика конфиденциальности</a>
                                &nbsp;&nbsp;&nbsp;
                                Способы оплаты:
                                <img src="{$imagesDir}/visa.png" alt="" width="30" style="margin: 0 0 -12px 0;">
                                <img src="{$imagesDir}/master.png" alt="" width="30" style="margin: 0 0 -12px 0;">

                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        <br />
        <br />
    </td></tr>
</table>
