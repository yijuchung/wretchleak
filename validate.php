<?php
session_start();
if (empty($_SESSION['sid'])) {
	 $_SESSION['sid'] = time();
}
$useragent = $_SERVER['HTTP_USER_AGENT'];

$browser = "";

if (strstr($useragent,'MSIE')) {
    $browser = "ie";
} 

?>



<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>無名小站情報分析事務所</title>
<?php
	
	if($browser == "ie"){
?>
<link href="style_ie.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js-lib/ie.js"></script>
<? }else{	?>
<link href="style.css" rel="stylesheet" type="text/css" />
<?	}		?>
<script type="text/javascript" src="js-lib/req.js"></script>
<script type="text/javascript" src="js-lib/gx.js"></script>
</head>
<body topmargin="0" marginwidth="0" marginheight="0" >
	<div id="container">
		<div id="content">
			<div id="top_em">
			</div>
			<div id="loading" style="display:none">
				<div id="load_img_contain"><img id="load_img" src="images/loadg.gif"/></div>
				<div id="load_bar">
					<div id="load_bar_left"></div>
					<div id="load_bar_middle" style="width:0px;height:25px"></div>
					<div id="load_bar_right"></div>
				</div>
				<div id="load_msg"></div>
			</div>
			<div id="msg_info" style="display:block">
				<div class="msg_img_contain"><img  src="images/msgg.gif"/></div>
				<div id="msg_container">
					<table  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td id="msg_left"></td>
						<td id="msg_content" valign="top">請輸入您的無名帳號~~第一次來的好友請先看 <a href="tutorial.php">教學頁</a> 喔~!!</td>
						<td id="msg_right"></td>
					</tr>
					</table>
				</div>
			</div>

			<form action="#" onsubmit="return allright()" >
			<table id="id_detail" class="content_block" style="display:block;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7" ></td></tr>
				<tr id="tr_id" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="175" class="td_1" align="right" valign="middle"  ><img src="images/tit_id.gif"/> </td>
					<td width="430" class="td_2" align="left" valign="middle" >
						<input type="text" name="user_id" id="user_id" class="code_field2" maxlength="30" size="30" value=""/>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="image" value="submitname" style="border:0px;"  onmouseover="this.src='images/btn_ok2.jpg'" onmouseout="this.src='images/btn_ok.jpg'" src="images/btn_ok.jpg" border="0" alt="SUBMIT!" name="image"> 
					</td>					

				</tr>
			   <tr><td height="7"></td></tr>
			</table>
			</form>

			<table id="code_detail" class="content_block" style="display:none;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7" ></td></tr>
				<tr id="tr_id2" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="165" class="td_1" align="right" valign="middle"  ><img src="images/tit_id.gif"/></td>
					<td width="340" class="td_2" align="left" valign="middle" >
						<div id="user_id_show" class="id_field"></div>
					</td>
					<td width="160">&nbsp;</td>
				</tr>
				<tr id="tr_code" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="165" class="td_1" align="right" valign="middle"  ><img src="images/tit_code.gif"/></td>
					<td width="340" class="td_2" align="left" valign="middle" >
						<input type="text" id="code_field" class="code_field" maxlength="30" size="30" readonly="readonly" value=""/>
					<td width="160"><input id="boat" type="hidden" value="<? echo $_SESSION['sid'] ?>" /></td>
				</tr>
				<tr >
					<td style="padding-top:10px" colspan="3" align="center"><a href="javascript:query_code()">
					<img border="0" onmouseover="this.src='images/btn_check2.jpg'" alt="驗證" onmouseout="this.src='images/btn_check.jpg'" src="images/btn_check.jpg"/></a> 
					<a href="javascript:backId()">
					<img border="0" onmouseover="this.src='images/btn_back2.jpg'" alt="返回" onmouseout="this.src='images/btn_back.jpg'" src="images/btn_back.jpg"/></a>					

					</td>
				</td>
			   <tr><td height="7"></td></tr>
			</table>

			<table id="gogo_detail" class="content_block" style="display:none;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7" ></td></tr>
				<tr>
					<td width="617" align="center"><img border="0" src="images/ready.jpg"/></td>
				</tr>
				<tr>
					<td width="617" style="padding-top:0px"  align="center"><a id="golink" href=""><img border="0" onmouseover="this.src='images/btn_go2.jpg'" alt="進入!!!" onmouseout="this.src='images/btn_go.jpg'" src="images/btn_go.jpg"/></a>
				</td>
			   <tr><td height="7"></td></tr>
			</table>
	

			<div id="bottom"></div>
			<div style="text-align:center">
			<a href="http://mmnet.iis.sinica.edu.tw/proj/tagart/" target="_blank"><img src="images/tagart.gif"  border="0" /></a>
			</div>
			<div id="foot">			
			<a href="gbook/" target="_blank">[ 問題 / 建議：事務所留言板 ]</a> <a href="intro/" target="_blank">[ 計劃簡介 ]</a> <a href="tutorial.php">[ 使用教學 ]</a> <a href="msn/" target="_blank">[ MSN小圖下載!! ]<img src="images/hot.gif" border="0"/></a>
			</div>

	</div>
	</div>
	</div>
</body>
</html>

