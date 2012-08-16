<?php
session_start();
	require_once('engine/options.php');
	require_once('engine/function.php');

$perpage = 10;

    $files = array();
    $checks = array();

    $sql = "SELECT count(*) as cnt FROM `{$db['prefix']}files` WHERE `owner_id` = '{$_SESSION[id]}' AND `status_id` = '3'";
    $result = mysql_query($sql);
    $checks_count = 0;
    if (!$result)
		$error = 'MySQL query error: ' . mysql_error();
    else{
		$row = mysql_fetch_array($result);
		if ($row)
			$checks_count = $row['cnt'];
    }
    $pages = ceil($checks_count/$perpage);
    $curpage = 0;
    if ($_POST['page']<>'' && preg_match('/^[0-9]+$/', $_POST['page']))
		$curpage = (int)$_POST[page] - 1;
    else if ($_POST[page] == 'last')
		$curpage = $pages - 1;
    if ($curpage < 0)
		$curpage = 0;
    if ($curpage >= $pages)
		$curpage = $pages - 1;
		
    $start = $curpage * $perpage;
    $sql = "SELECT * FROM `{$db[prefix]}files` WHERE `owner_id` = '{$_SESSION[id]}' AND `status_id` = '3' ORDER BY added DESC LIMIT $start,$perpage";
    $curpage++;
    $result = mysql_query($sql);
	
    if (!$result) {
		$error = 'MySQL query error: ' . mysql_error();
    } 
	else{
		$i = 0;
       	while ($row = mysql_fetch_array($result)){
			$files[$i][info] = $row;
			$sql = "SELECT * FROM `{$db['prefix']}checks` WHERE `file_id`='{$row[id]}';";
			$result1 = mysql_query($sql);
			if (!$result){
				$error = 'MySQL query error: ' . mysql_error();
			} 
			else{
				$j = 0;
				$infected = 0;
				while ($row1 = mysql_fetch_array($result1)) {
					$av = $row1[av_name];
					if ($row1[result] <> 'ok')
						$infected++;
					$files[$i][check][$av] = $row1[result];
					$j++;
				}
				$files[$i][result] = "$infected/$j";
			}
			$i++;
		}
    }
    mysql_close($con);
    include('tpl/history.tpl');


?>
