<? include('tpl/header.tpl'); ?>
<link href="css/ui.tabs.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" language="javascript" src="js/ui.accordion.js"></script>
<script type="text/javascript" language="javascript" src="js/ui.tabs.pack.js"></script>
<script type="text/javascript" language="javascript" src="js/jquery.field.js"></script>
<script type="text/javascript" language="JavaScript">
function showPage(num) {$('#load').html(' <img src="img/loading.gif"/> Loading...');$('#history').load('/history.php', {page: num});}function onTop(p) {if (p == 1) {$('#report').css('z-index', 11);$('#history').css('z-index', 10);} else {$('#report').css('z-index', 10);$('#history').css('z-index', 11);}}function onAjaxSuccess(data) {if (data == 0) {document.forms['fileupload'].submit();} else {var err = "Ошибка: " + data;$('#error').append(err);}}function onReportUpdate(data) {if (data == '') {} else {}}function onHistoryUpdate(data) {if (data == '') {$('#history').hide();} else {}}function checkReport() {if ($('#report').css('display') != 'none')$('#report').load('/report.php', onReportUpdate);setTimeout("checkReport();", 5000);}$(document).ready(function(){$("#tabs > ol").tabs({ fx: { height: 'toggle' }<? if($tab) : ?>, selected: <?=$tab?><? endif; ?> });$("#tabs").show();$("#report").load("/report.php", onReportUpdate);checkReport();$("#history").load("/history.php", onHistoryUpdate).hide();});
</script>
<span class="error"><? if ($error): ?><?=$error;?><? endif; ?></span>
	<div id="tabs" class="page" style="display:none;">
		<? include('tpl/checktab.tpl'); ?>
    </div>
<div id="history" onClick="onTop(0);"></div>
<div id="report" onClick="onTop(1);"></div>
<? if($_SESSION['report'] == 1): ?>
<script>
    $('#report').show();
</script>
<? unset($_SESSION['report']); ?>
<? endif; ?>
<? include('tpl/footer.tpl'); ?>
