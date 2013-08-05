<? 
/*-----------------------------------------------------
COPYRIGHT NOTICE
Copyright (c) 2001 - 2008, Ketut Aryadana
All Rights Reserved

Script name : ArdGuest
Version : 1.8
Website : http://www.promosi-web.com/script/guestbook/
Email : aryasmail@yahoo.com.au
Download URL : 
   - http://www.promosi-web.com/script/guestbook/download/
   - http://www.9sites.net/download/ardguest_1.8.zip

This code is provided As Is with no warranty expressed or implied. 
I am not liable for anything that results from your use of this code.
------------------------------------------------------*/

//--Change the following variables

//Title of your guestbook
  $title = "無名小站情報分析事務所";
//Change "admin" with your own password. It's required when you delete an entry
  $admin_password = "mmnetmmnetmmnet407";
//Enter your email here
  $admin_email = "iengfat@iis.sinica.edu.tw";
//Your website URL
  $home = "http://mmnet.iis.sinica.edu.tw/proj/wretchinfo/";
//Send you an email when someone add your guestbook, YES or NO
  $notify = "NO";
//Your Operating System
//For Windows/NT user : WIN
//For Linux/Unix user : UNIX
  $os = "UNIX";
//Maximum entry per page when you view your guestbook
  $max_entry_per_page = 10;
//Name of file used to store your entry, change it if necessary
  $data_file = "wretchinmessage.dat";
//Maximum entry stored in data file
  $max_record_in_data_file = 300;
//Maximum entries allowed per session, to prevent multiple entries made by one visitor
  $max_entry_per_session = 10;
//Enable Image verification code, set the value to NO if your web server doesn't support GD lib
  $imgcode = "YES";
//Color & font setting
  $background = "#FFFFFF";
  $table_top = "#ffffff";
  $table_content_1a = "#FEFEFE";
  $table_content_1b = "#FEFEFE";
  $table_content_2a = "#FFFFFF";
  $table_content_2b = "#FFFFFF";
  $table_bottom = "#eeeeee";
  $table_border = "#FFFFFF";
  $title_color = "#666666";
  $font_face = "verdana";
  $message_font_face = "arial";
  $message_font_size = "2";

//-- Don't change bellow this line unless you know what you're doing

$do = isset($_REQUEST['do']) ? trim($_REQUEST['do']) : "";
$id = isset($_GET['id']) ? trim($_GET['id']) : "";
$page = isset($_GET['page']) ? $_GET['page'] : 1;
$self = $_SERVER['PHP_SELF'];



if (!file_exists($data_file)) {
    echo "<b>Error !!</b> Can't find data file : $data_file.<br>";
	exit;
} else {
	if ($max_record_in_data_file != "0") {
		$f = file($data_file);
		rsort($f);
		$j = count($f);
		if ($j > $max_record_in_data_file) {
			$rf = fopen($data_file,"w");
            if (strtoupper($os) == "UNIX") {
	           if (flock($rf,LOCK_EX)) {
                  for ($i=0; $i<$max_record_in_data_file; $i++) {
                      fwrite($rf,$f[$i]);	     
			      }
                  flock($rf,LOCK_UN);
	           }
            } else {
               for ($i=0; $i<$max_record_in_data_file; $i++) {
                  fwrite($rf,$f[$i]);	     
	           }
	        }
			fclose($rf);
		}
	}
}
session_start();
$newline = (strtoupper($os) == "WIN") ? "\r\n" : "\n";
switch ($do) {
case "":
   $record = file($data_file);
   rsort($record);
   $jmlrec = count($record);
?>
   <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
   <html>
   <head>
   <title><?=$title?></title>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="../styleg.css" rel="stylesheet" type="text/css" />
   </head>
   <body bgcolor="<?=$background?>"  topmargin="0" marginwidth="0" marginheight="0" >
   <div id="maindiv2">
	<div id="topx"></div>
	<div id="msg_info" style="display:block">
		<div class="msg_img_contain"><img  src="../images/msggg.gif"/></div>
		<div id="msg_container">
			<table  border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td id="msg_left"></td>
				<td id="msg_content" valign="top"> 感謝大家的棒場, 請多多 <a href="<?="$self?do=add_form&page=$page"?>">給予我們建議</a> 喔 ^_^~!!</td>
				<td id="msg_right"></td>
				<td width="210"></td>			
				<td align="right">
					<font size="2" color="#dddddd"><a href="<?="$self?do=add_form&page=$page"?>"><img src="../images/btn_newpo.gif" border="0" title="新的留言"/></a> </font>
					<!-- <a href="../"><img src="../images/btn_newbk.gif" border="0" title="返回事務所"/></a> -->
				</td>				
			</tr>
			</table>
		</div>
		</div>

	<div class="content_block2">
       <table  border="0" cellspacing="3" cellpadding="2" >
      <tr>
	    <td  colspan="3" >
<?
			if(isset($_SESSION['login']) && $_SESSION['login'] == "OK!"){
				echo "| <a href=\"$self?do=logout\">Logout</a>";
			}
?>
	   

        </td>
	  </tr>
<?
      $jml_page = ceil($jmlrec/$max_entry_per_page);
	  $nomrec = $page * $max_entry_per_page - $max_entry_per_page;
	  $no = $page*$max_entry_per_page-$max_entry_per_page;
      //$no = ($jmlrec - $page * $max_entry_per_page) + $max_entry_per_page + 1;
      if ($jmlrec == 0) {
		  echo '<tr><td colspan="3" bgcolor="#ffffff" align="center"><font size="3">沒有任何留言</font></td></tr>';
	  }
		$w = 0; //--Color
        for ($i=0; $i<$max_entry_per_page; $i++) {
			$nomrec++;
			$no++;
		    //$no--;
		    $recno = $nomrec-1;
		    if (isset($record[$recno])) {
		       $row = explode("|~|",$record[$recno]);
			   if ($w==0) { 
				   $warna = $table_content_1a;
				   $warna2 = $table_content_1b;
				   $color_time = "#ba8842";
				   $w=1;
			   } else { 
				   $warna = $table_content_2a;
				   $warna2 = $table_content_2b;
				   $color_time = "#ba8842";
				   $w=0;
			   }
			   echo "<tr >
			           <td bgcolor=\"$warna2\" align=\"center\" valign=\"top\" width=\"15\" style=\"border-bottom:1px solid #FFFFFF\" >
					     <font size=\"2\"><image style=\"border:2px solid #ffffff\" src=\"../images/mt$row[8].gif\"/></font>
					   </td>
					   <td bgcolor=\"$warna\" width=\"570\" valign=\"top\" style=\"border-bottom:1px solid #FFFFFF\" align=\"right\">
					   <table border=\"0\" width=\"489\"  cellpadding=\"0\" cellspacing=\"0\" class=\"msgp\">
					   <tr >
						<td width=\"20\">
						<div class=\"msgcon\">
						</div>
					   </td>
					    <td style=\"border-top: 1px solid #ffcb3e;\">
							<div style=\"margin:5px;\">
						 <font size=\"3\" color=\"#c76301\"><b>$row[3]</b></font>
						 <font size=\"1\" color=\"$color_time\">$row[2]</font>
						 </div>
						</td>
					";
               echo "<td align=\"right\" valign=\"top\">";
						if (trim($row[4]) != "") {
							echo "<a href=\"mailto:$row[4]\"><img src=\"imgs/email.gif\" border=\"0\" alt=\"$row[4]\"></a>";
						}
			            if (trim($row[6]) != "" && trim($row[6]) != "http://") {
                           if (ereg("^http://", trim($row[6]))) echo " <a href=\"$row[6]\" target=\"_blank\"><img src=\"imgs/homepage.gif\" border=\"0\" alt=\"$row[6]\"></a>";
                           else echo " <a href=\"http://$row[6]\" target=\"_blank\"><img src=\"imgs/homepage.gif\" border=\"0\" alt=\"$row[6]\"></a>";
			            }
			   echo '</td></tr></table>';
			   echo "<table border=\"0\" width=\"475\" cellpadding=\"5\" class=\"msgc\">
			         <tr>
					 <td bgcolor=\"#fefaed\">
					<div style=\"padding:10px;\">
			         <font size=\"2\" face=\"$message_font_face\" color=\"#666666\" size=\"$message_font_size\">".stripslashes($row[5])."</font>					 
					 </div>
					 </td></tr>
                     </table>
			        ";
			   echo '</td>';

				if(isset($_SESSION['login']) && $_SESSION['login'] == "OK!"){
							   echo "<td valign=\"top\" bgcolor=\"$warna2\" align=\"center\" width=\"15\">
									 <a href=\"$self?do=del&id=$row[1]&page=$page\">
									 <img src=\"imgs/del.gif\" alt=\"Delete entry # $no\" border=0 align=\"center\"></a>
									 </td>";
				}

				echo	 "</tr>";

			} //--end if		
        } //--end for
      echo "<tr><td id=\"tbottom\" colspan=\"3\" style=\"border-top: 1px dashed #e7e7e7\" align=\"center\" ><font size=\"2\">";	  	  
      if ($jml_page > 1) {	   
		  if ($page != 1) echo "[<a href=\"$self?page=1\">最前頁</a>] "; else echo '[最前頁] ';
	      echo ' ';
          if ($jml_page > 10) {
	 	      if ($page < 5) {
		          $start = 1;
			      $stop = 10;
		      } elseif ($jml_page - $page < 5) {
		          $start = $jml_page - 9;
			      $stop = $jml_page;
		      } else {
		          $start = $page-4;
			      $stop = $page+5;
			  }
		      if ($start != 1) echo '... ';
              for ($p=$start; $p<=$stop; $p++) {
				  if ($p == $page) echo "<font color=\"$active_link\"><b>$p</b></font>&nbsp;&nbsp;";
				  else echo "<a href=\"$self?page=$p\">$p</a>&nbsp;&nbsp;";
              }
		      if ($stop != $jml_page) echo '... ';		 		 
		      echo "頁, 共 $jml_page 頁";
          } else {
              for ($p=1; $p<=$jml_page; $p++) {
	              if ($p == $page) echo "<font color=\"$active_link\"><b>$p</b></font>&nbsp;&nbsp;";
			      else echo "<a href=\"$self?page=$p\">$p</a>&nbsp;&nbsp;";
              }
	      }	   
          if ($page != $jml_page) echo "[<a href=\"$self?page=$jml_page\">最後頁</a>]";
		  else echo '[最後頁]'; 
      } else echo '第 1 頁';
	  echo '</font></td></tr>';
?>
        </table>  </div>      

   <div id="bottom">
	</div>
   </div>
		<div id="note">
		<a href="../" >[ 無名小站情報分析事務所 ]</a> <a href="../intro/" target="">[ 計劃簡介 ]</a> <a href="../msn/" target="">[ MSN小圖下載!! ]<img src="../images/hot.gif" border="0"/></a>
		</div>
	<br/><br/>
   </body>
   </html>
<?
break;
case "add_form":
$_SESSION['secc'] = strtoupper(substr(sha1(time().$admin_email),0,4));
if (!isset($_SESSION['add'])) $_SESSION['add'] = 0;

if (!isset($_SESSION['name'])) $_SESSION['name'] = "";
if (!isset($_SESSION['email'])) $_SESSION['email'] = "";
if (!isset($_SESSION['url'])) $_SESSION['url'] = "http://";
if (!isset($_SESSION['comment'])) $_SESSION['comment'] = "";
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title><?=$title?></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../styleg.css" rel="stylesheet" type="text/css" />
<script>
function update_image(){
	var vid =  document.getElementById('imgsel');
	if(vid != null){
		var vid2 =  document.getElementById('imgpic');
		if(vid2 != null){
			vid2.src = "../images/mt" + vid.value + ".gif";
		}
	}
}
</script>
</head>

<body bgcolor="<?=$background?>" style="font-family:<?=$font_face?>" topmargin="0" marginwidth="0" marginheight="0" >
   <div id="maindiv2" align="center">
	<div id="topx">
   </div>  

  <form method="post" action="<?=$self?>" name="postform" style="margin:0px">
  <input type="hidden" name="do" value="add">
        <div align="center" class="content_block">
            <table  width="100%" border="0" cellspacing="3" cellpadding="2" >
				<tr  onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
                <td width="28%" > 
                  <div align="right"><font size="2">* <img src="../images/g_nick.gif" alt="暱稱" title="暱稱"/> </font></div>
                </td>
                <td width="72%"> 
                  <input type="text" name="vname" size="30" maxlength="70" value="<?=$_SESSION['name']?>">
                </td>
              </tr>
				<tr  onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
                <td width="28%" valign="top"> 
                  <div align="right" ><font size="2"><img src="../images/g_pic.gif" alt="大頭貼" title="大頭貼"/></font></div>
                </td>
                <td width="72%" style="padding-bottom:15px" valign="top"> &nbsp;&nbsp;&nbsp;
					<select id="imgsel" onchange="update_image()" name="vpic">
					  <option value="1">講話(藍色)</option>
					  <option value="5">講話(橘色)</option>
					  <option value="9">講話(綠色)</option>
					  <option value="13">講話(紫色)</option>
					  <option value="2">耍帥(藍色)</option>
					  <option value="6">耍帥(橘色)</option>
					  <option value="10">耍帥(綠色)</option>
					  <option value="14">耍帥(紫色)</option>
					  <option value="3">自信(藍色)</option>
					  <option value="7">自信(橘色)</option>
					  <option value="11">自信(綠色)</option>
					  <option value="15">自信(紫色)</option>
					  <option value="4">熱血(藍色)</option>
					  <option value="8">熱血(橘色)</option>
					  <option value="12">熱血(綠色)</option>
					  <option value="16">熱血(紫色)</option>
					</select><br/>				
					<image id="imgpic" style="vertical-align:middle;border: 2px solid #FFFFFF" src="../images/mt1.gif"/>
                </td>
              </tr>
				<tr  onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
                <td valign="top" width="28%"> 
                  <div align="right"><font size="2">* <img src="../images/g_msg.gif" alt="留言內容" title="留言內容"/> </font></div>
                </td>
                <td width="72%" valign="top"> 
                  <textarea name="vcomment" cols="40" rows="7" wrap="virtual"><?=$_SESSION['comment']?></textarea>
				  <br><font size="2">* 為必填項目</font>
                </td>
              </tr>
			  <?if (strtoupper($imgcode) == "YES") {?>
				<tr  onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
                <td width="28%" valign="top"> 
                  <div align="right" ><font size="2"><img src="../images/g_code.gif" alt="認證碼" title="認證碼"/></font></div>
                </td>
                <td width="72%"> 
                  <font size="2">請輸入方塊內的認證碼 :</font><br>
				  <input size="1" align="center" value='<?=$_SESSION['secc']?>'> 
				  <input type="text" name="vsecc" size="4" maxlength="4">
                </td>
              </tr>
			  <?}?>
				<tr  onmouseover="this.className = 'tbs2'" onmouseout="this.className = 'tbs'">
 
                <td colspan="2" > 
                  <div align="center">
                    <font size="6" >
						<img style="border:0px;"  onmouseover="this.src='../images/btn_ok2.jpg'" onmouseout="this.src='../images/btn_ok.jpg'" src="../images/btn_ok.jpg" onclick="document.postform.submit();" border="0" alt="SUBMIT!" /> 
						<img style="border:0px;"  onmouseover="this.src='../images/btn_back2.jpg'" onmouseout="this.src='../images/btn_back.jpg'" src="../images/btn_back.jpg" border="0"  onclick="window.location='index.php'" /> 
                    </font>
				   </div>
                </td>
              </tr>
            </table>
        </div>
   <div id="bottom" ></div>
   </div>
   </form>
		<div id="note">
		</div>
</body>
</html>
<!-- End of entry form -->
<?
break;
case "add":
   $vname = isset($_POST['vname']) ? trim($_POST['vname']) : "";
   $vemail = isset($_POST['vemail']) ? trim($_POST['vemail']) : "";
   $vurl = isset($_POST['vurl']) ? trim($_POST['vurl']) : "";
   $vcomment = isset($_POST['vcomment']) ? trim($_POST['vcomment']) : "";
   $vsecc = isset($_POST['vsecc']) ? strtoupper($_POST['vsecc']) : "";
   $vpic = isset($_POST['vpic']) ? strtoupper($_POST['vpic']) : "";


   if (strlen($vname) > 70) $vname = substr($vname,0,70);
   if (strlen($vemail) > 100) $vemail = substr($vemail,0,100);
   if (strlen($vurl) > 150) $vurl = substr($vurl,0,150);

   $_SESSION['name'] = $vname;
   $_SESSION['email'] = $vemail;
   $_SESSION['url'] = $vurl;
   $_SESSION['comment'] = stripslashes($vcomment);

   if ($vname == "" || $vcomment == "") {
	   input_err("有些欄位沒有填喔!!");
   }

   if ($vemail != "" && !preg_match("/([\w\.\-]+)(\@[\w\.\-]+)(\.[a-z]{2,4})+/i", $vemail)) {
	   input_err("Invalid email address.");
   }

   if ($vurl != "" && strtolower($vurl) != "http://") {
       if (!preg_match ("#^http://[_a-z0-9-]+\\.[_a-z0-9-]+#i", $vurl)) {
		   input_err("Invalid URL format.");
       }
   }

   $test_comment = preg_split("/[\s]+/",$vcomment);
   $jmltest = count($test_comment);
   for ($t=0; $t<$jmltest; $t++) {
      if (0 && strlen(trim($test_comment[$t])) > 70) {
		  input_err("有奇怪的字? : ".stripslashes($test_comment[$t]));
	  }
   }

   if (isset($_SESSION['add']) && $_SESSION['add'] >= $max_entry_per_session) {
	   input_err("抱歉, 每次 只能發 $max_entry_per_session 個留言喔.",false);
   } elseif (!isset($_SESSION['add'])) {
	   exit;
   }

   if ($vsecc != $_SESSION['secc'] && strtoupper($imgcode) == "YES") {
	   input_err("認證碼錯誤...");
   }
   //--only 2000 characters allowed for comment, change this value if necessary
   $maxchar = 2000;
   if (strlen($vcomment) > $maxchar) $vcomment = substr($vcomment,0,$maxchar)."...";

   $idx = date("YmdHis");
   $tgl = date("F d, Y - h:i A");

   $vname = str_replace("<","&lt;",$vname);
   $vname = str_replace(">","&gt;",$vname);
   $vname = str_replace("~","-",$vname);
   $vname = str_replace("\"","&quot;",$vname);
   $vcomment = str_replace("<","&lt;",$vcomment);
   $vcomment = str_replace(">","&gt;",$vcomment);
   $vcomment = str_replace("|","",$vcomment);
   $vcomment = str_replace("\"","&quot;",$vcomment);
   $vurl = str_replace("<","",$vurl);
   $vurl = str_replace(">","",$vurl);
   $vurl = str_replace("|","",$vurl);
   $vemail = str_replace("<","",$vemail);
   $vemail = str_replace(">","",$vemail);
   $vemail = str_replace("|","",$vemail);

   if (strtoupper($os) == "WIN") {
	   $vcomment = str_replace($newline,"<br>",$vcomment);
	   $vcomment = str_replace("\r","",$vcomment);
	   $vcomment = str_replace("\n","",$vcomment);
   } else {
	   $vcomment = str_replace($newline,"<br>",$vcomment);
	   $vcomment = str_replace("\r","",$vcomment);
   }

   if (isset($_SERVER['HTTP_X_FORWARDED_FOR']) && eregi("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$",$_SERVER['HTTP_X_FORWARDED_FOR'])) {
       $ipnum = $_SERVER['HTTP_X_FORWARDED_FOR'];
   } else {
       $ipnum = getenv("REMOTE_ADDR");
   }

   $newdata = "|~|$idx|~|$tgl|~|$vname|~|$vemail|~|$vcomment|~|$vurl|~|$ipnum|~|$vpic|~|";
   $newdata = stripslashes($newdata);
   $newdata .= $newline;

   if (!is_spam($newdata)) {
		$tambah = fopen($data_file,"a");
		if (strtoupper($os)=="UNIX") {
			if (flock($tambah,LOCK_EX)) {
				fwrite($tambah,$newdata);
				flock($tambah,LOCK_UN);
			}
		} else {
			fwrite($tambah,$newdata);
		}
		fclose($tambah);

		//--send mail
		if (strtoupper($notify) == "YES") {
			$msgtitle = "Someone signed your guestbook";
			$vcomment = str_replace("&quot;","\"",$vcomment);   
			$vcomment = stripslashes($vcomment);
			$vcomment = str_replace("<br>","\n",$vcomment);
			$msgcontent = "Local time : $tgl\n\nThe addition from $vname :\n----------------------------\n\n$vcomment\n\n-----End Message-----";
	//		@mail($admin_email,$msgtitle,$msgcontent,"From: $vemail\n");
		}
		//--clear session
		$_SESSION['name'] = "";
		$_SESSION['email'] = "";
		$_SESSION['url'] = "http://";
		$_SESSION['comment'] = "";
		$_SESSION['add']++;
		$_SESSION['secc'] = "";
		redir($self,"感謝你, 已經新增你的留言.");
	} else {
		redir($self,"抱歉, 留言失敗...");
	}
break;

case "del":
   $record = file($data_file);
   $jmlrec = count($record);
   for ($i=0; $i<$jmlrec; $i++) {
       $row = explode("|~|",$record[$i]);
	   if ($id == $row[1]) {
	      ?>
		  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
		  <html>
		  <head>
		  <title>Delete record</title>
		  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		  <link href="../styleg.css" rel="stylesheet" type="text/css" />
		  </head>
		  <body bgcolor="<?=$background?>" style="font-family:<?=$font_face?>">
		  <div align="center">
		  <font size="4" color="<?=$title_color?>">Delete Confirmation</font>
		  <br><br>
		  <table border="0" cellpadding="5" cellspacing="1" width="450">
			<tr>
			<td bgcolor="<?=$table_top?>" >
            <font size="2" color="#ffffff">
			<font size="1" color="#dddddd"><b><?=$row[2]?></font><br><?=$row[3]?></b> - <a href="mailto:<?=$row[4]?>"><?=$row[4]?></a>
			<br><br><?=$row[5]?>
			<br><br><font size="1">IP : <?=$row[7]?></font>
			</font> 
			</td>
			</tr>
		  </table>
		  <form action="<?=$self?>" method="post">
			  <input type="hidden" name="do" value="del2">
			  <input type="hidden" name="id" value="<?=$id?>">
			  <input type="hidden" name="page" value="<?=$page?>">
			  <font color="<?=$title_color?>" size="2"><b>Admin password : </b></font> <input type="password" name="pwd">
			  <br><br>
			  <font size="2" color="<?=$title_color?>"><b>&raquo;</b><input type="checkbox" name="byip" value="<?=$row[7]?>"> Delete all records that using this IP : <?=$row[7]?></font>
			  <br><br>
			  <input type="submit" value="Delete"> <input type="button" value="Cancel" onclick="window.location='<?="$self?page=$page"?>'">
		  </form>
		  </div>
		  </body>
		  </html>
		  <?
	   }
   }      
break;


case "login":
?>
		  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
		  <html>
		  <head>
		  <title>Delete record</title>
		  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		  <link href="../styleg.css" rel="stylesheet" type="text/css" />
		  </head>
		  <body bgcolor="<?=$background?>" style="font-family:<?=$font_face?>">
		  <div align="center">
		  <font size="4" color="<?=$title_color?>">Admin login</font>
		  <br><br>

		  <form action="<?=$self?>" method="post">
			  <input type="hidden" name="do" value="login2">
			  <font color="<?=$title_color?>" size="2"><b>Admin password : </b></font> <input type="password" name="pwd">
			  <br><br>
			  <font size="2" color="<?=$title_color?>"><b>&raquo;</b> Login to gain more rights</font>
			  <br><br>
			  <input type="submit" value="Login"> <input type="button" value="Cancel" onclick="window.location='<?="$self?page=$page"?>'">
		  </form>
		  </div>
		  </body>
		  </html>
		  <?
    
break;

case "login2":
   $pwd = isset($_POST['pwd']) ? trim($_POST['pwd']) : "";
   if ($pwd != $admin_password) {
	     redir("$self?page=$page","密碼錯誤 !");
   }else{
	   $_SESSION['login'] = "OK!";
   }

    redir("$self?page=$page","登入成功!");

break;

case "logout":
	if(isset($_SESSION['login'])){
	   unset($_SESSION['login']); 
   }
    redir("$self?page=$page","登出成功!");

break;

case "del2":
   $pwd = isset($_POST['pwd']) ? trim($_POST['pwd']) : "";
   $id = isset($_POST['id']) ? trim($_POST['id']) : "";
   $page = isset($_POST['page']) ? $_POST['page'] : 1;
   $byip = isset($_POST['byip']) ? $_POST['byip'] : "";

   if ($pwd != $admin_password) {
	     redir("$self?page=$page","密碼錯誤 !");
   }

   $record = file($data_file);
   $jmlrec = count($record);
   for ($i=0; $i<$jmlrec; $i++) {
       $row = explode("|~|",$record[$i]);
	   if ($byip == "") {
		   if ($row[1] == $id) {
			   $record[$i] = "";
		       break;
	       }
	   } else {
		   if ($row[7] == $byip) {
			   $record[$i] = "";
		   }
	   }
   }

   $update_data = fopen($data_file,"w");
   if (strtoupper($os) == "UNIX") {
      if (flock($update_data,LOCK_EX)) {
	     for ($j=0; $j<$jmlrec; $j++) {
             if ($record[$j] != "") {
				 fputs($update_data,$record[$j]);
			 }
		 }
		 flock($update_data,LOCK_UN);
	  }
   } else {
	     for ($j=0; $j<$jmlrec; $j++) {
             if ($record[$j] != "") {
				 fputs($update_data,$record[$j]);
			 }
		 }
   }
   fclose($update_data);
   redir("$self?page=$page","已刪除 !");
break;
} //--end switch


function redir($target,$msg) {
global $background,$font_face,$title_color;
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="refresh" content="1; url=<?=$target?>">
</head>
<body bgcolor="<?=$background?>">
<div align="center"><font color="#3c8ed3" face="<?=$font_face?>"><h3><?=$msg?></h3>請稍侯...</font></div>
</body>
</html>
<?
exit;
}

function input_err($err_msg,$linkback=true) {
global $background,$font_face;
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Error !</title>
   <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="../styleg.css" rel="stylesheet" type="text/css" />
</head>
<body bgcolor="<?=$background?>">
<div  align="center">
<br>
<table border="0" bgcolor="#FFFFFF" cellspacing="0" cellpadding="6">
<tr>
	<td aligh="right">
		<image src="../images/mt1.gif" />
	<td/>
	<td id="dialog" align="center">
		<font size="3" color="#da6108" face="<?=$font_face?>"><b><?=$err_msg?></b><br>
		<?if ($linkback) {?>
		<font size="2">請 <a href="javascript:history.back()">返回</a> 修正一下喔~</font>
	    <?}else{?>
		<font size="2"> <a href="index.php">Back</a> to message board.</font>
		<?}?>
		</font>
	</td>
</tr>
</table>

</div>
</body>
</html>
<?
exit;
}

function is_spam($string) {
	$data = "spamwords.dat";
	$is_spam = false;
	if (file_exists($data)) {
		$spamword = file($data);
		$jmlrec = count($spamword);
		for ($i=0; $i<$jmlrec; $i++) {
			$spamword[$i] = trim($spamword[$i]);
			if (eregi($spamword[$i],$string)) {
				$is_spam = true;
				break;
			}
		}
	}
	return $is_spam;
}
?>