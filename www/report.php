<?php
	session_start();
	require_once('engine/options.php');
	require_once('engine/function.php');

    $file = array();
    $av_report = array();

    $sql = "SELECT * FROM `{$db['prefix']}" . "files` WHERE `owner_id` = '{$_SESSION['id']}' AND `status_id` < '3' ORDER BY added LIMIT 1;";
	
    $result = mysql_query($sql);
	
    if (!$result) {
		$error = 'MySQL query error: ' . mysql_error();
    } 
	elseif ($row = mysql_fetch_array($result)) {
		$file = $row;
		if ($file[status_id] == 0) {
			$sql = "SELECT count(*) as pos FROM `{$db['prefix']}files` WHERE `status_id` < '3' AND `added` < '{$file['added']}';";
			$result = mysql_query($sql);
			if (!$result)
			$error = 'MySQL query error: ' . mysql_error();
			if ($result && $row = mysql_fetch_array($result))
			$file[pos] = (int)$row[pos] + 1;
		}
    } 
	else {
		$sql = "SELECT * FROM `{$db['prefix']}files` WHERE `owner_id` = '{$_SESSION['id']}' ORDER BY added DESC LIMIT 1;";
		$result = mysql_query($sql);
		if (!$result) {
			$error = 'MySQL query error: ' . mysql_error();
		} elseif ($row = mysql_fetch_array($result)) {
			$file = $row;
		} else {

		}
    }
    if (!$error) {
		$sql = "SELECT * FROM `{$db['prefix']}" . "checks` WHERE `file_id` = '{$file['id']}' ORDER BY modified";
		$result = mysql_query($sql);
		if (!$result) {
			$error = 'MySQL query error: ' . mysql_error();
		} else {
			$i = 0;
			$infected = 0;
			$all = 0;
			while ($row = mysql_fetch_array($result)) {
			$av_report[$i] = $row;
			if ($row[result] <> 'ok')
				$infected++;
			if ($row[packers] <> '')
				$file[packers] = $row[packers];
			$i++;
			}
			if ($_POST[oldid])
				$file[old_status_id] = $_POST[oldid];
				include('tpl/report.tpl');
		}
    } 
	else{
		echo $error;
	}

?>
