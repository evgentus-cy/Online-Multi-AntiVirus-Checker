<span class="close white" onClick="$('#report').fadeOut('slow');">х</span>
<h2 class="white">Отчет</h2>
<ul class="white">
    <li><label>Имя файла:</label><?=htmlspecialchars($file['name']);?></li>
    <li><label>Получен:</label><?=$file['added'];?></li>
    <li><label>Текущий статус:</label><b><?=$status[$file['status_id']];?></b></li>
    <? if ($file['pos']) : ?>
    <li><label>Позиция в очереди:</label><b><?=$file['pos'];?></b></li>
    <? endif; ?>
    <li><label>Результат:</label><?=$infected;?>/<?=$i;?> обнаружили заражение</li>
</ul>
<table align="center" width="95%" border="0">
    <tr><th>Антивирус</th><th>Версия</th><th>Обновление</th><th>Результат</th></tr>
    <? foreach ($av_report as $avr) : ?>
    <tr>
	<td><?=$avr['av_name'];?></td>
	<td><?=$avr['av_ver'];?></td>
	<td><?=$avr['av_update'];?></td>
	<td>
	    <? if ($avr['result'] == 'ok') : ?>
	    <font color="green"><?=$avr['result'];?></font>
	    <? else : ?>
	    <font color="red"><?=$avr['result'];?></font>
	    <? endif; ?>
	</td>
    </tr>
    <? endforeach; ?>
</table>
<h4 class="white">Дополнительная информация:</h4>
<ul class="white">
    <li><label>Размер файла:</label><?=$file['size'];?> байт</li>
    <li><label>MD5 хэш:</label><?=$file['md5'];?></li>
    <li><label>SHA1 хэш:</label><?=$file['sha1'];?></li>
    <? if ($file['packers']) : ?>
    <li><label>Упаковщики:</label><?=$file['packers'];?></li>
    <? endif; ?>
</ul>

