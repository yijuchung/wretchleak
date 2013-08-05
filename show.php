<?php
session_start();
$_SESSION['mmnet']  = "";
$_SESSION['usr2'] = "";
$str_time = time();
$str_date = date("Y-m-d|H:i:s", $str_time);

$myFile = "userlog/userlog.txt";
$fh = fopen($myFile, 'a+');


if (isset($_SESSION['sid']) && isset($_SESSION['usr']) && $_SESSION['usr'] != "" && isset($_SESSION['code']) && $_SESSION['code'] != "" ) {
	if($_SESSION['usr'] === $_GET['user'] && $_SESSION['code'] === $_GET['t']){
		$user_id = $_SESSION['usr'];
		$user_id = preg_replace('/[^a-z0-9]/i', '', $user_id); 
		$_SESSION['usr2'] = $user_id;

		if($fh){
			fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$_GET['user']." USE OKK\n");
		}	
		
	}else{
		if($fh){
			fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$_GET['user']." USE WRG\n");	
		}	
		$_SESSION['usr'] = "";
		$_SESSION['code'] = "";
		header("location:validate.php");
	}
}else if(isset($_GET['setidmmnet']) && $_GET['setidmmnet'] != ""){

		$user_id = $_GET['setidmmnet'];
		
		if($fh){
			fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$user_id." USE SUP\n");	
		}
		
		$user_id = preg_replace('/[^a-z0-9]/i', '', $user_id); 
		$_SESSION['usr2'] = $user_id;
		$_SESSION['mmnet'] = "ok";
		$_SESSION['code'] = "MMNET";

}else{
		if($fh){
			fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$_GET['user']." USE ERR\n");	
		}	

		header("location:validate.php");		
}

if($fh){
	fclose($fh);
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
<title>無名小站情報分析事務所	</title>
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
<body topmargin="0" marginwidth="0" marginheight="0" onload="query('user_id')" >
	<div id="container">
		<div id="content">
			<div id="top">
				<div id="frm">
					<table border="0" width="320" >
					<tr>
					<td align="right">您的無名帳號為：</td>
					<td class="input" align="center" width="150"><?php echo $user_id ?><input type="hidden" name="user_id" id="user_id" value="<?php echo $user_id ?>" readonly="readonly"/></td>
					<td align="right"><input type="button" id="back" class="gogogo" value=" 返回 "  onclick="window.location.href='validate.php'" />
					</td>
					</tr>
					</table>				  
				</div>
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
			<div id="msg_info" style="display:none">
				<div class="msg_img_contain"><img  src="images/msgg.gif"/></div>
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
			
			<div id="survey" class="msg_info" style="display:none">
				<div class="msg_img_contain"><img  src="images/msggg.gif"/></div>
				<div id="msg_container">
					<table  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td class="msg_left"></td>
						<td class="msg_content" valign="top" id="survey_msg"><strong>填問卷抽大獎!</strong> 請 <strong><a href="javascript:toggle_show_div('survey_detail')">填寫問卷</a></strong> 協助我們進行「網際網路非自願性資訊洩露」的研究 <strong><a href="javascript:toggle_show_div('survey_detail')">[ 更多 ]</a></strong</td>
						<td class="msg_right"></td>
					</tr>
					</table>
				</div>	
				<div class="right_con2"><div id="close1" class="collapsx" onclick="hide_survy()"></div></div>

			</div>
			<table id="survey_detail" class="content_block" style="display:none;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7"></td></tr>
			   
				<tr id="tr_sur_info" style="display:block" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top"  >活動說明：</td>
					<td width="400" class="td_2" align="left" valign="top" id="">
						填寫問卷者將可參加抽獎，抽獎獎品為 <strong>全新 4G 隨身碟!!!</strong><br/>抽獎結果將公布於 ptt.cc [Q_ary] 看版</li>
					</td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
			   <tr><td height="7"></td></tr>		
				<tr>
				<td colspan="3" align="center" class="survy_head">------------------------------- 問卷開始 -------------------------------</td>
				</tr>				
			   <tr><td colspan="3">
				<? include("survey_form.php") ?>
			   </td></tr>
			   <tr><td height="7"></td></tr>			   
				<tr>
				<td colspan="3" align="center" class="survy_head">------------------------------- 問卷結束 -------------------------------</td>
				</tr>			
			   <tr><td height="7"></td></tr>
			   <tr>
				<td colspan="3" align="center" >
					<input id="survey_com" type="image" value="submitname" style="border:0px;display:block"  onmouseover="this.src='images/btn_ok2.jpg'" onmouseout="this.src='images/btn_ok.jpg'" onclick="complete_survey()" src="images/btn_ok.jpg" border="0" alt="SUBMIT!" /> 				
					<input id="survey_tran" type="image" value="submitname" style="border:0px;display:none"   src="images/btn_tran.jpg" border="0" /> 				
				</td>
				</tr>			

				
			   <tr><td height="7"></td></tr>
			</table>			
			
			<div id="info" style="display:none">
				<div id="info_img_contain"><img id="info_img" src="images/nohead.gif"/></div>
				<div id="info_content">[ <span id="id_name"></span>&nbsp;] - <span id="nick_name"></span></div>
				<div class="right_con2"><div id="collaps1" class="collaps10" onclick="toggle_collaps(1)">-</div></div>

			</div>

			<table id="info_content_detail" class="content_block" style="display:none;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7"></td></tr>
				<tr id="tr_bir" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_bir.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="bir"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_blo" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_blo.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="blo"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_hei" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_hei.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="hei"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_wei" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_wei.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="wei"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_edu" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_edu.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="edu"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_occ" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_occ.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="occ"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_hob" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_hob.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="hob"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>

				<tr id="tr_fav" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_fav.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="fav"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_dis" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_dis.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top"><div id="dis"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_ema" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_ema.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="ema"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_msn" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_msn.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="msn"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_yah" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_yah.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="yah"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_qqq" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_qqq.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="qqq"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_aim" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_aim.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="aim"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_goo" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_goo.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="goo"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_sky" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_sky.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="sky"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_int" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_int.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="int"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
				<tr id="tr_vis" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_vis.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="vis"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >&nbsp;</td>
				</tr>
			   <tr><td height="7"></td></tr>
			</table>


			<div id="name_result" style="display:none">
				<div class="img_contain"><img  src="images/icon_des.gif"/></div>
				<div id="name_result_des">分析報告 (可用滑鼠選擇名字或標籤)</div>
				<div class="right_con2"><div id="collaps2" onclick="toggle_collaps(2)">-</div></div>
				
			</div>
			<table id="name_result_detail" class="content_block" style="display:none;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7"></td></tr>
				<tr id="tr_rname" style="display:none">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_rname.gif"/></td>
					<td width="517" class="td_2" align="left" valign="top" id="rname"></td>
				</tr>
				<tr id="tr_name3" style="display:none">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_name3.gif"/></td>
					<td width="517" class="td_2" align="left" valign="top" id="name3" ></td>
				</tr>
				<tr id="tr_name2" style="display:none">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_name2.gif"/></td>
					<td width="517" class="td_2" align="left" valign="top" id="name2"></td>
				</tr>
				<tr id="tr_nick" style="display:none">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_nick.gif"/></td>
					<td width="517" class="td_2" align="left" valign="top" id="nick"></td>
				</tr>
				<tr id="tr_tag" style="display:none">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_tag.gif"/></td>
					<td width="517" class="td_2" align="left" valign="top" id="tag" ></td>
				</tr>
				<tr id="tr_tag2" style="display:none">
					<td width="100" class="td_1" align="right" valign="top"  ><img src="images/tit_tag2.gif"/></td>
					<td width="517" class="td_2" align="left" valign="top" id="tag2" ></td>
				</tr>
			   <tr><td height="7"></td></tr>
	
			</table>

			<div id="friend_list" style="display:none">
				<div class="img_contain"><img  src="images/icon_frn.gif"/></div>
				<div id="friend_list_des">來自好友的描述<span id="total_frn"></span></div>
				<div class="right_con">
					<div id="collaps3" onclick="toggle_collaps(3)">-</div>
					<div id="show_frn_mode" class="select_frn_btn" style="display:block" onmouseover="this.className = 'select_frn_btn2'" onmouseout="this.className = 'select_frn_btn'"><a href="javascript:toggle_mode_frn()" title="現在設定：詳細模式" >詳細</a></div>
					<div id="select_frn_ony" class="select_frn_btn" style="display:none" onmouseover="this.className = 'select_frn_btn2'" onmouseout="this.className = 'select_frn_btn'"><a href="javascript:toggle_select_frn()" title="現在設定：顯示全部好友" >全部</a></div>
					
					<div id="select_frn_per" class="select_frn_ok" style="display:none"></div>
					<div id="select_frn_num" class="select_frn_ok" style="display:none"></div>
					<div id="select_frn" class="select_frn_ok2" style="display:none"></div>
				</div>
			</div>
			<div id="frn_pop" style="display:none">
				<table  border="0" cellpadding="0" cellspacing="0">
					<tr><td valign="top">
					<table id="frn_des_pop" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td id="pop_middle" valign="top"></td>
						</tr>
					</table>
					</td><td valign="top"><table  border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td id="pop_right" ></td>
						</tr>
					</table>
					</tr>
				</table>
			</div>
			<table id="friend_list_detail" class="content_block" style="display:none;" border="0" cellpadding="0" cellspacing="0">
			   <tr><td height="7"></td></tr>
				<tr id="tr_frn" style="display:block">
					<td width="600" class="td_frn" align="left" valign="top" id="frnx" ></td>
				</tr>
			</table>

			<div id="bottom"></div>
			<div id="foot">			
			<a href="gbook/" target="_blank">[ 問題 / 建議：事務所留言板 ]</a> <a href="intro/" target="_blank">[ 計劃簡介 ]</a> <a href="msn/" target="_blank">[ MSN小圖下載!! ]<img src="images/hot.gif" border="0"/></a>
			</div>

	</div>
	</div>
	</div>
</body>
</html>

