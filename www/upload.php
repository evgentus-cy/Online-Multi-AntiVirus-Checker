<?php
session_start();
	require_once('engine/options.php');
	require_once('engine/function.php');

    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        if ($_FILES['file']['size'] > 10485760) {
            $error = 'Файлы больше 10Мб не проверяются';
		} 
		else{
			$url = $_POST['url'];
			$size = 0;
			$ar = '';
			$origname = '';
			$fname = '';
			$md5 = '';
			$sha1 = '';
			if ($_FILES['file']['error'] > 0) {
				$pattern = '/^(?:http|ftp)/';
				if (preg_match($pattern, $url)) {
					$fp = @fopen($url, 'rb') or $error = "Не удается подключиться к $url";
					if ($fp){
						$meta_data = stream_get_meta_data($fp);
						foreach($meta_data['wrapper_data'] as $resp){
							$pattern = '/^Location: (.*)$/';
							if(preg_match($pattern, $resp, $found)){
								$url = $found[1];
							}
							$pattern = '/^Accept-Ranges: (.*)$/';
							if (preg_match($pattern, $resp, $found)){
								$ar = $found[1];
								if ($ar != 'bytes')
								$error = 'Не корректный Accept-Ranges';
							}
							$pattern = '/^Content-Length: (.*)$/';
							if (preg_match($pattern, $resp, $found)){
								$size = (int)$found[1];
								if ($size > 10485760)
									$error = 'Файлы больше 10Мб не проверяются';
							}
						}
						if ($ar != '' && $size != 0 && ! $error) {
							$url_parts = parse_url($url);
							$origname = basename($url_parts['path']);
							if ($origname == '')
								$origname = substr(md5(uniqid('')), 0, 8);
							$fname = md5(uniqid('')) . $origname;
							$fw = fopen($tmp_dir . '/' . $fname, 'wb') or $error = "Не удается создать файл $fname";
							if ($fw) {
								while (!feof($fp))
								fwrite($fw, fread($fp, 8192));
								fclose($fw);
							}
						} 
						else {
							$error = "Чето не так (size=$size $ar): $error";
						}
						fclose($fp);
					}
				}
				else {
					$error = 'Ошибка при загрузке(' . $_FILES['file']['error'] . '): ' . $_FILES['file']['tmp_name'] . ' (' . $_FILES['file']['name'] . ')';
				}
            } 
			else{
				$fname = basename($_FILES['file']['tmp_name']) . $_FILES['file']['name'];
				if (move_uploaded_file($_FILES['file']['tmp_name'], $tmp_dir . '/' . $fname)) {
				} 
				else{
					$error = "Не удается скопировать {$_FILES['file']['name']}";
				}
				$origname = $_FILES['file']['name'];
				$size = (int)$_FILES['file']['size'];
				if ($size <= 0)
					$error = "Файл пуст (file: $origname, size: $size)";
			}
		}
        if (!$error) {
			
            $md5 = md5_file($tmp_dir . '/' . $fname);
            $sha1 = sha1_file($tmp_dir . '/' . $fname);
			$origname = mysql_real_escape_string($origname);
			$fname = mysql_real_escape_string($fname);
            $sql = "INSERT INTO `{$db['prefix']}files` (`owner_id`, `name`, `tmpname`, `md5`, `sha1`, `size`) VALUES('{$_SESSION[id]}', '{$origname}', '{$fname}', '{$md5}', '{$sha1}', '{$size}');";
           
		   if (! mysql_query($sql)){
        	    $error = 'MySQL error: ' . mysql_error();
            }
		}
		if ($error)
			$_SESSION['error'] = $error;
		else
			$_SESSION['report'] = 1;
    }
    header("Location: /index.php");
?>
