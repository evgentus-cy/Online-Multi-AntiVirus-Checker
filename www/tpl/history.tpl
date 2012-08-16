<span class="close white" onClick="$('#history').fadeOut('slow');">х</span>
<h2 class="white">Журнал проверок(<span class="white" onClick="showPage(1);">обновить</span>)</h2>
<span id="load"></span>
<p class="white">Вы проверили <?=$checks_count;?> файл(ов)</p>
<table align="center" width="95%" border="0">
    <tr><th>Имя файла</th><th width="20%">Дата</th><th width="15%">Размер</th><th width="15%">Результат</th></tr>
</table>
<dl id="acc" style="display: none;">
    <? foreach ($files as $file) : ?>
        <dt class="acchead">
	<table align="center" border="0" width="95%"><tr>
	    <td><?=htmlspecialchars($file['info']['name']);?></td>
	    <td width="20%"><?=$file['info']['added'];?></td>
	    <td width="15%"><?=$file['info']['size'];?></td>
	    <td width="15%"><?=$file['result'];?></td>
	    </tr></table>
        </dt>
	<dd>
            <? foreach ($file['check'] as $av => $result) : ?>
	    <p style="margin:0;padding:0 0 0 5em;"><?=$av;?>: <? if($result == 'ok') : ?><font color="green"><? else : ?><font color="red"><? endif; ?><?=$result;?></font></p>
            <? endforeach; ?>
        </dd>
    <? endforeach; ?>
</dl>
<p class="white">
Страницы: <span alt="начало" title="начало" class="link" onClick="showPage(1);">в начало</span> <span alt="пред" title="пред" class="link" onClick="showPage(<?=$curpage-1;?>);">назад</span> 
<?
$np = 10;
if ($pages <= $np) {
    for($i=1; $i<=$pages; $i++)
        if($i == $curpage)
	    echo "$i ";
	else
	    echo "<span class=\"link\" onClick=\"showPage($i);\">$i</span> ";
} else {
    $flag = 0;
    for($i=1; $i<=$np; $i++) {
        if($i == $curpage) {
            echo "$i ";
	    $flag = 1;
	} else
	    echo "<span class=\"link\" onClick=\"showPage($i);\">$i</span> ";
    }
    echo "... ";
    if ($flag == 0) {
        if ($curpage <> $pages)
            echo "$curpage ... ";
    }
    echo "<span class=\"link\" onClick=\"showPage($pages);\">$pages</span> ";
}
?>
<span class="link" alt="след" title="след" onClick="showPage(<?=$curpage+1;?>);">дальше</span> <span alt="конец" title="конец" class="link" onClick="showPage('last');">в конец</span>
</p>
<script type="text/javascript">
    $("#acc").accordion({
        header: "dt.acchead",
        active: "accpanel",
	alwaysOpen: false
	}).show();
    
</script>
