<?php

// Данные для подключения к БД
$db['host'] = 'localhost';
$db['user'] = 'root';
$db['password'] = '';
$db['base'] = 'checker';
$db['prefix'] = 'checker_';

// Статус проверки
$status[0] = 'в очереди';
$status[1] = 'ожидание';
$status[2] = 'сканирование';
$status[3] = 'проверено';

// TMP директория
$tmp_dir = '/tmp';

// Лицензии к АВ
$avs = array(
    'avast' => array('key' => ''),
    'drweb' => array('key' => ''),
    'clamav' => array('key' => ''),
    'mcafee' => array('key' => ''),
);

?>
