<?php
if (!function_exists('pr')) {
    /**
     * Функции для дебажинга
     * @param $array
     * @param bool $return
     * @return bool|string
     */
    function pr($array, $return = false)
    {
        if ($return === false) {
            ob_start();
            echo '<pre style="display: block; overflow: hidden; line-height: 30px;text-align: left;">';
            print_r($array);
            echo '</pre>';
            return false;
        } else {
            ob_start();
            echo '<pre>';
            print_r($array);
            echo '</pre>';
            return ob_get_clean();
        }
    }

    function prex($array)
    {
        pr($array);
        exit;
    }
}

if (!function_exists('Translit')) {
    /**
     * Транслитирируем слово в латиницу для урлов
     * @param $sTitle
     * @return string
     */
    function Translit($sTitle)
    {
        $rus = array('а', 'б', 'в', 'г', 'д', 'е', 'ё', 'ж', 'з', 'и', 'й', 'к', 'л', 'м', 'н', 'о', 'п', 'р', 'с', 'т', 'у', 'ф', 'х', 'ц', 'ч', 'ш', 'щ', 'ъ', 'ы', 'ь', 'э', 'ю', 'я', '&', ' ', '+', '_', '.');
        $eng = array('a', 'b', 'v', 'g', 'd', 'e', 'jo', 'zh', 'z', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'f', 'h', 'c', 'ch', 'sh', 'sh', 'j', 'y', '', 'e', 'yu', 'ya', '-', '-', '-', '-', '-');
        $sTitle = str_replace($rus, $eng, mb_strtolower(trim($sTitle)));
        preg_match_all('/[a-z0-9-_]+/', $sTitle, $aM, PREG_SET_ORDER);
        $sTitle = '';
        if (count($aM)) {
            foreach ($aM as $iK => $aV) {
                $sTitle .= $aV[0];
            }
        }
        return $sTitle;
    }
}

if (!function_exists('CutText')) {
    /**
     * Обрезаем текст по количеству символов, не обрезая слова
     * @param $sText
     * @param int $iCount
     * @return string
     */
    function CutText($sText, $iCount = 220)
    {
        $aText = explode(' ', $sText);
        $sResult = '';
        $i = 0;
        while (strlen($sResult) < $iCount) {
            if (!isset($aText[$i])) break;
            $sResult .= ' ' . $aText[$i];
            ++$i;
        }
        return trim($sResult) ? $sResult . ' ...' : $sResult;
    }
}

if (!function_exists('Sklonenie')) {
    /**
     * Склоняем слово по словоформам
     * @param $iCount
     * @param $aSklonenie
     * @return mixed
     */
    function Sklonenie($iCount, $aSklonenie)
    {
        return $iCount % 10 == 1 && $iCount % 100 != 11 ? $aSklonenie[0] : ($iCount % 10 >= 2 && $iCount % 10 <= 4 && ($iCount % 100 < 10 || $iCount % 100 >= 20) ? $aSklonenie[1] : $aSklonenie[2]);
    }
}

if (!function_exists('GetPrice')) {
    /**
     * Обрабатываем цену и возвращаем в форматированном виде
     * @param $iPrice
     * @param bool $bNumberFormat
     * @param bool $bWithCurrency
     * @return string
     */
    function GetPrice($iPrice, $bNumberFormat = false, $bWithCurrency = false)
    {
        if ($bNumberFormat) {
            $iPrice = number_format($iPrice, 0, ',', ' ');
        }
        return $bWithCurrency ? $iPrice . ' руб.' : $iPrice;
    }
}

if (!function_exists('SizeClass')) {
    /**
     * В зависимости от пропорций фото возвращает вертикальный или горизонтальный классс
     * @param $sImgUrl
     * @param $iWidth
     * @param $iHeight
     * @return string
     */
    function SizeClass($sImgUrl, $iWidth, $iHeight)
    {
        $aImg = getimagesize($sImgUrl);
        $iImgWidth = $aImg[0];
        $iImgHeight = $aImg[1];
        return $iImgWidth / $iImgHeight < $iWidth / $iHeight ? 'vertical' : 'horizontal';
    }
}

if (!function_exists('ClearPhone')) {
    /**
     * Удаляет все лишние символы из телефона
     * @param $sUserPhone
     * @return string
     */
    function ClearPhone($sUserPhone)
    {
        return trim(str_replace(array('(', ')', ' ', '+', '-'), '', $sUserPhone));
    }
}

if (!function_exists('Short')) {
    /**
     * @param $sText
     * @param int $iCount
     * @return string
     */
    function Short($sText, $iCount = 220)
    {
        $aText = explode(' ', $sText);
        $sResult = '';
        $i = 0;
        while (strlen($sResult) < $iCount) {
            $sResult .= ' ' . $aText[$i];
            ++$i;
        }
        return trim($sResult) ? $sResult . ' ...' : $sResult;
    }
}

if (!function_exists('NormalizePhone')) {
    /**
     * @param $sText
     * @param int $iCount
     * @return string
     */
    function NormalizePhone($sPhone)
    {
        preg_match_all('/^\+?(7|8)?(\d\d\d\d\d\d\d\d\d\d)$/', ClearPhone($sPhone), $aM, PREG_SET_ORDER);
        if (isset($aM[0][2]))
            return '7' . $aM[0][2];
        else
            ClearPhone($sPhone);
    }
}

if (!function_exists('FormatPhone')){
    /***
     * Форматируем телефон
     * @param $sPhone
     * @return bool|string
     */
    function FormatPhone($sPhone){
    $sArea = substr($sPhone, 1,3);
    $sPrefix = substr($sPhone,4,3);
    $sNumber = substr($sPhone,7,2);
    $sNumber1 = substr($sPhone,9,2);
    $sPhone = "+7 (".$sArea.") ".$sPrefix."-".$sNumber."-".$sNumber1;
    return($sPhone);
}
}

if (!function_exists('lat2rus')) {
    /**
     * @param $sText
     * @param int $iCount
     * @return string
     */
    function lat2rus($sText)
    {
        return strtr($sText, [
            'q' => 'й', 'w' => 'ц', 'e' => 'у', 'r' => 'к', 't' => 'е', 'y' => 'н', 'u' => 'г', 'i' => 'ш', 'o' => 'щ', 'p' => 'з', '[' => 'х', ']' => 'ъ',
            'a' => 'ф', 's' => 'ы', 'd' => 'в', 'f' => 'а', 'g' => 'п', 'h' => 'р', 'j' => 'о', 'k' => 'л', 'l' => 'д', ';' => 'ж', "'" => 'э',
            'z' => 'я', 'x' => 'ч', 'c' => 'с', 'v' => 'м', 'b' => 'и', 'n' => 'т', 'm' => 'ь', ',' => 'б', '.' => 'ю',
            'Q' => 'й', 'W' => 'ц', 'E' => 'у', 'R' => 'к', 'T' => 'е', 'Y' => 'н', 'U' => 'г', 'I' => 'ш', 'O' => 'щ', 'P' => 'з', '[' => 'х', ']' => 'ъ',
            'A' => 'ф', 'S' => 'ы', 'D' => 'в', 'F' => 'а', 'G' => 'п', 'H' => 'р', 'J' => 'о', 'K' => 'л', 'L' => 'д', ';' => 'ж', "'" => 'э',
            'Z' => 'я', 'X' => 'ч', 'C' => 'с', 'V' => 'м', 'B' => 'и', 'N' => 'т', 'M' => 'ь', ',' => 'б', '.' => 'ю'
        ]);
    }
}
if (!function_exists('rus2lat')) {
    /**
     * @param $sText
     * @param int $iCount
     * @return string
     */
    function rus2lat($sText)
    {
        return strtr($sText, array_flip([
            'q' => 'й', 'w' => 'ц', 'e' => 'у', 'r' => 'к', 't' => 'е', 'y' => 'н', 'u' => 'г', 'i' => 'ш', 'o' => 'щ', 'p' => 'з', '[' => 'х', ']' => 'ъ',
            'a' => 'ф', 's' => 'ы', 'd' => 'в', 'f' => 'а', 'g' => 'п', 'h' => 'р', 'j' => 'о', 'k' => 'л', 'l' => 'д', ';' => 'ж', "'" => 'э',
            'z' => 'я', 'x' => 'ч', 'c' => 'с', 'v' => 'м', 'b' => 'и', 'n' => 'т', 'm' => 'ь', ',' => 'б', '.' => 'ю',
            'Q' => 'й', 'W' => 'ц', 'E' => 'у', 'R' => 'к', 'T' => 'е', 'Y' => 'н', 'U' => 'г', 'I' => 'ш', 'O' => 'щ', 'P' => 'з', '[' => 'х', ']' => 'ъ',
            'A' => 'ф', 'S' => 'ы', 'D' => 'в', 'F' => 'а', 'G' => 'п', 'H' => 'р', 'J' => 'о', 'K' => 'л', 'L' => 'д', ';' => 'ж', "'" => 'э',
            'Z' => 'я', 'X' => 'ч', 'C' => 'с', 'V' => 'м', 'B' => 'и', 'N' => 'т', 'M' => 'ь', ',' => 'б', '.' => 'ю'
        ]));
    }
}

if (!function_exists('time_format')) {
    /**
     * @param $sText
     * @param int $iCount
     * @return string
     */
    function time_format($iSeconds)
    {
        return str_pad(floor($iSeconds / 3600), 2, '0', STR_PAD_LEFT)
            . ':' . str_pad(floor($iSeconds / 60), 2, '0', STR_PAD_LEFT)
            . ':' . str_pad($iSeconds % 60, 2, '0', STR_PAD_LEFT);
    }
}

function GetSelectText($sValue, $sConfig){
    foreach(Config::Get($sConfig) as $aS) {
//        pr("{$aS['value']} == {$sValue}");
//        pr($aS['value'] == $sValue);
        if ($aS['value'] === $sValue) return $aS['text'];
    }
}

function GetSelectValueByText($sText, $sConfig){
    foreach(Config::Get($sConfig) as $aS) {
//        pr("{$aS['value']} == {$sValue}");
//        pr($aS['value'] == $sValue);
        if ($aS['text'] === $sText) return $aS['value'];
    }
}

function ExistsSelectValue($sValue, $sConfig){
    foreach(Config::Get($sConfig) as $aS) {
        if ($aS['value'] == $sValue) return true;
    }
    false;
}

function GetQRCodeImagePath($sData){
    //set it to writable location, a place for temp generated PNG files
    $PNG_TEMP_DIR = Config::Get('path.root.server').'/uploads/qrcode/';
    if (!file_exists($PNG_TEMP_DIR)) mkdir($PNG_TEMP_DIR);

    //html PNG location prefix
    $PNG_WEB_DIR = '/uploads/qrcode/';


    //processing form input
    //remember to sanitize user input in real-life solution !!!
    $errorCorrectionLevel = 'L';
    if (isset($_REQUEST['level']) && in_array($_REQUEST['level'], array('L','M','Q','H')))
        $errorCorrectionLevel = $_REQUEST['level'];

    $matrixPointSize = 4;
    if (isset($_REQUEST['size']))
        $matrixPointSize = min(max((int)$_REQUEST['size'], 1), 10);


    //it's very important!
    if (trim($sData) == '')
        die('data cannot be empty! <a href="?">back</a>');

    // user data
    $filename = $PNG_TEMP_DIR.md5($sData.'|'.$errorCorrectionLevel.'|'.$matrixPointSize).'.png';
    QRcode::png($sData, $filename, $errorCorrectionLevel, $matrixPointSize, 2);
    return $PNG_WEB_DIR.basename($filename);
}
