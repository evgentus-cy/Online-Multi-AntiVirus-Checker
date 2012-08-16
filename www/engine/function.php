<?php

$con = mysql_connect($db['host'], $db['user'], $db['password']) or die('Could not connect: ' . mysql_error());
mysql_select_db($db['base']) or die('Could not select db: ' . mysql_error());

$_SESSION['id'] = mysql_real_escape_string($_COOKIE['PHPSESSID']);
?>