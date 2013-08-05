
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>無名小站情報分析事務所 - 問卷情報!!</title>
<?php
	
	if($browser == "ie"){
?>
<link href="../style_ie.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="../js-lib/ie.js"></script>
<? }else{	?>
<link href="../style.css" rel="stylesheet" type="text/css" />
<?	}		?>

<style type="text/css">

.bar_back{
	width:100px;
	height:15px;
	border:1px solid #cccccc;
	background-color:#eeeeee;
}

.bar_p{
	height:13px;
	position:absolute; 
	font-size:11px; 
	color:#aaaaaa;
}

.bar_x{
	position:absolute;
	height:15px;
	background-color:#33CC00;
	font-size:11px; 
	color:#ffffff;
	overflow:hidden;
	
}

.bar_x2{
	position:absolute;
	height:15px;
	background-color:#3399DD;
	font-size:11px; 
	color:#ffffff;
	overflow:hidden;
	
}

.bar_x3{
	position:absolute;
	height:15px;
	background-color:#9966DD;
	font-size:11px; 
	color:#ffffff;
	overflow:hidden;
	
}

.bar_txt{
	width:45px;
	padding-left:30px;
	text-align:center;
}

</style>


</head>
<body topmargin="0" marginwidth="0" marginheight="0" >
	<div id="container">
		<div id="content">
			<div id="top_em">
			</div>
			<div id="loading" style="display:none">
				<div id="load_img_contain"><img id="load_img" src="../images/loadg.gif"/></div>
				<div id="load_bar">
					<div id="load_bar_left"></div>
					<div id="load_bar_middle" style="width:0px;height:25px"></div>
					<div id="load_bar_right"></div>
				</div>
				<div id="load_msg"></div>
			</div>
			<div id="msg_info" style="display:none">
				<div class="msg_img_contain"><img  src="../images/msgg.gif"/></div>
				<div id="msg_container">
					<table  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td id="msg_left"></td>
						<td id="msg_content" valign="top"></td>
						<td id="msg_right"></td>
					</tr>
					</table>
				</div>
			</div>
			
			<div id="survey" class="msg_info" style="display:block">
				<div class="msg_img_contain"><img  src="../images/msgg.gif"/></div>
				<div id="msg_container">
					<table  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td class="msg_left"></td>
						<td class="msg_content" valign="top" id="survey_msg"><strong>快來下載 <a href="#">小M</a> 的MSN圖片跟表情符號吧!</strong> 也可以全部下載喔：[ <a href="Mpic.zip">顯示圖片</a> | <a href="Micon.zip">表情符號</a> ] </td>
						<td class="msg_right"></td>
					</tr>
					</table>
				</div>	

			</div>

			<table id="info_content_detail" class="content_block"  style="display:block;padding-left:0px" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7" colspan="4" width="100%"></td></tr>
			   <tr><td align="center" width="100%"><table style="margin:0px auto"><tr>
				<td colspan="6" align="center">MSN 顯示圖片 (右鍵另存新檔)</td>
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="80"  align="center" valign="top"  ></td>					
					<td width="100"  align="center" valign="top"  ><img src="pic/M_ok_blue.jpg" title="不錯! (藍色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_fervent_blue.jpg" title="熱血! (藍色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_happy_blue.jpg" title="呵呵! (藍色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_cool_blue.jpg" title="耍帥! (藍色)"/> </td>
					<td width="80"  align="center" valign="top"  ></td>					
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="80"  align="center" valign="top"  ></td>					
					<td width="100"  align="center" valign="top"  ><img src="pic/M_ok_violet.jpg" title="不錯! (紫色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_fervent_violet.jpg" title="熱血! (紫色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_happy_violet.jpg" title="呵呵! (紫色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_cool_violet.jpg" title="耍帥! (紫色)"/> </td>
					<td width="80"  align="center" valign="top"  ></td>					
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="80"  align="center" valign="top"  ></td>					
					<td width="100"  align="center" valign="top"  ><img src="pic/M_ok_green.jpg" title="不錯! (綠色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_fervent_green.jpg" title="熱血! (綠色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_happy_green.jpg" title="呵呵! (綠色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_cool_green.jpg" title="耍帥! (綠色)"/> </td>
					<td width="80"  align="center" valign="top"  ></td>					
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="80"  align="center" valign="top"  ></td>					
					<td width="100"  align="center" valign="top"  ><img src="pic/M_ok_orange.jpg" title="不錯! (橘色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_fervent_orange.jpg" title="熱血! (橘色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_happy_orange.jpg" title="呵呵! (橘色)"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="pic/M_cool_orange.jpg" title="耍帥! (橘色)"/> </td>
					<td width="80"  align="center" valign="top"  ></td>					
				</tr>		
				</table>
			</table>
			<table id="info_content_detail" class="content_block" style="display:block;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7" colspan="4" width="100%"></td></tr>
			   <tr><td align="center" width="100%"><table style="margin:0px auto"><tr>
				<td colspan="6" align="center">MSN 表情符號 (右鍵另存新檔)</td>
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="180"  align="center" valign="top"  ></td>					
					<td width="100"  align="center" valign="top"  ><img src="icon/m_gogogo.gif" title="熱血!"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/m_hello.gif" title="哈囉!"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/m_comeon.gif" title="來吧!"/> </td>
					<td width="180"  align="center" valign="top"  ></td>					
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="180"  align="center" valign="top"  ></td>					
					<td width="100"  align="center" valign="top"  ><img src="icon/m_cry.gif" title="哭哭"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/m_cool.gif" title="帥!"/> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/m_angry.gif" title="生氣"/> </td>
					<td width="180"  align="center" valign="top"  ></td>					
				</tr>
				</table>
			</table>			

				<table id="info_content_detail" class="content_block" style="display:block;padding-left:30px" border="0" cellpadding="0" cellspacing="0">
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
			   <tr><td height="7"></td></tr>
				<td colspan="5" align="center">MSN 表情符號 Extra (右鍵另存新檔)</td>
				</tr>
				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_sleep.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_hoho.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_pe.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_what2.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_mmm.gif" /> </td>
				</tr>

				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_love.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_nice.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_me.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_thanks.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_haha.gif" /> </td>
				</tr>

				<tr id="tr_bir" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_gogo.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_sad.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_hello.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_what.gif" /> </td>
					<td width="100"  align="center" valign="top"  ><img src="icon/quo_za.gif" /> </td>
				</tr>
			</table>		

			<table id="info_content_detail" class="content_block" style="display:block;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7"></td></tr><table style="margin:0px auto"><tr>
				<td  align="center">使用範例</td></tr>
				</tr><tr>
				<td width="100"  align="center" valign="top"  ><img src="sample.jpg" /> </td>
				</tr>
				<tr>
				<td width="100"  align="center" valign="top"  ><img src="icon/m_hello.gif" /><img src="icon/quo_me.gif" /> </td>
				</tr>
</tr>				
			</table>
			
			<div id="bottom"></div>
			<div id="foot">			
			<a href="../" >[ 無名小站情報分析事務所 ]</a> <a href="../gbook/" >[ 問題 / 建議：事務所留言板 ]</a> <a href="../intro/" >[ 計劃簡介 ]</a>
			</div>

	</div>
	</div>
	</div>
</body>
</html>

