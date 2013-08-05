<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>好友描述分析器</title>
<link href="style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="js-lib/req.js"></script>
<script type="text/javascript" src="js-lib/gx.js"></script>
</head>
<body topmargin="0" marginwidth="0" marginheight="0" >
	<div id="container">
		<div id="content">
			<div id="top">
				<div id="frm">
					<form action="javascript:query('user_id')" method="post" name="formx" id="formx">
						<table border="0" >
						<tr>
						<td >請輸入無名帳號：</td>
						<td> <input type="text" name="user_id" id="user_id" value="v280096"/></td>
						<td> <input type="submit" name="submit" id="gogogo" value="分析"  class="button" /></td>
						</tr>
						</table>				  
					</form>
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
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_blo" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_blo.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="blo"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_hei" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_hei.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="hei"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_wei" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_wei.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="wei"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_edu" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_edu.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="edu"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_occ" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_occ.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="occ"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_hob" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_hob.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="hob"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>

				<tr id="tr_fav" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_fav.gif"/> </td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="fav"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_dis" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_dis.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top"><div id="dis"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_ema" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_ema.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="ema"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_msn" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_msn.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="msn"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_yah" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_yah.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="yah"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_qqq" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_qqq.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="qqq"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_aim" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_aim.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="aim"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_goo" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_goo.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="goo"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_sky" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_sky.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="sky"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_int" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_int.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="int"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
				<tr id="tr_vis" style="display:none" onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
					<td width="100" class="td_1" align="right" valign="top" ><img src="images/tit_vis.gif"/></td>
					<td width="400" class="td_2" align="left" valign="top" ><div id="vis"></div></td>
					<td width="117" class="td_3" align="left" valign="top" >(建議)</td>
				</tr>
			   <tr><td height="7"></td></tr>
			</table>


			<div id="name_result" style="display:none">
				<div class="img_contain"><img  src="images/icon_des.gif"/></div>
				<div id="name_result_des">好友描述分析結果</div>
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
				<div id="friend_list_des">加我好友列表<span id="total_frn"></span></div>
				<div class="right_con">
					<div id="collaps3" onclick="toggle_collaps(3)">-</div>
					<div id="select_frn_ony" class="select_frn_btn" style="display:none" onmouseover="this.className = 'select_frn_btn2'" onmouseout="this.className = 'select_frn_btn'"><a href="javascript:toggle_select_frn()" title="只顯示相關好友" >相關</a></div>
					
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
			<div id="foot">2009 MMNet Lab, IIS, Academia Sinica</div>

	</div>
<div id="res3" style="display:none;background-color:#F2FEFF;color:#0A5358;"></div>
<div id="res2" style="display:block;background-color:#F2FEFF;color:#0A5358;"></div>
<div id="res" style="display:block;background-color:#FFF2FC;color:#6E0B58;"></div>
		</div>
	</div>
</body>
</html>

