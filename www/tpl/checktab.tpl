<div id="check" class="ui-tabs-panel">
    <div id="box">
	<div><b>Проверка файла</b></div>
	<div class="middle">
	    <form id="fileupload" name="fileupload" action="/upload.php" method="post" enctype="multipart/form-data">
		<table border="0" cellpadding="7" cellspacing="0" width="100%" style="padding-right:10px;">
		    <tr>
			<td>Файл</td>
			<td width="200px"><input name="file" type="file" id="file" size="30" /></td>
		    </tr>
		    <tr><td colspan="2">или укажите ссылку на файл</td></tr>
		    <tr>
			<td>Ссылка</td>
			<td width="200px"><input name="url" type="test" id="url" size="30" /></td>
		    </tr>
		    <tr><td colspan="2" align="right"><input type="submit" class="forma2" value="проверить" /></td></tr>
		</table>
	    </form>
	</div>
	<span onClick="onTop(1);$('#report').fadeIn('slow');" alt="Статистика последней проверки" title="Статистика последней проверки">
            <img src="img/report.png" /> Отчет о последней проверке
	</span><br/>
	<span onClick="onTop(0);$('#history').fadeIn('slow');" alt="История проверок" title="История проверок">
	    <img src="img/history.png" /> Журнал проверок
	</span>
    </div>
</div>
