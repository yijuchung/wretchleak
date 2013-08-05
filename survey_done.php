<?php
session_start();
?>
<html>
<body>
<?php
if ((isset($_SESSION['usr2']) && $_SESSION['usr2'] != "" && $_SESSION['usr2'] == $_POST['uid'] && (isset($_SESSION['mmnet']) && $_SESSION['mmnet']  == "ok")) || (isset($_SESSION['sid']) && isset($_SESSION['usr2']) && $_SESSION['usr2'] != "" && isset($_SESSION['code']) && $_SESSION['code'] != "" && $_SESSION['usr2'] == $_POST['uid'])) {
	$uid =  $_POST['uid'];
	$sc = $_POST['sc'];
	$mc =  $_POST['mc'];
	$mc2 =  $_POST['mc2'];	
	$ft = $_POST['ft'];
	$ft2 = $_POST['ft2'];	
	$ptt = $_POST['ptt'];
	$email =  $_POST['email'];
	
	$res_sc = split(",", $sc);
	

	$id = "wrinfo";
	$pwd = "wretchmmnet123";
	$db = "wretch";
	$db_selected = 0;

	$con = mysql_connect("localhost", $id, $pwd);

	if($con){

		$db_selected = mysql_select_db($db);

		if($db_selected){
			$sql = "insert into survey values('$uid', '$res_sc[0]', '$res_sc[1]', '$res_sc[2]','$res_sc[3]','$res_sc[4]','$res_sc[5]','$res_sc[6]','$res_sc[7]', NULL, NULL, '$mc','$mc2',NULL, '$ft', '$ft2', NULL, '$ptt', '$email', NULL)";
			$result = mysql_query($sql);
			if($result){
				echo "\n--OKOK--\n";

				$str_time = time();
				$str_date = date("Y-m-d|H:i:s", $str_time);				
				$myFile = "userlog/userlog.txt";
				$fh = fopen($myFile, 'a+');
				if($fh){
					fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$uid." SUR ".$sc.",".$mc.",".$ft.",".$ptt.",".$email."\n");	
					fclose($fh);
				}				
			}else{
				echo "\n--SQLERR--\n";
			}
		}
		
	}
	
	
}else{
	echo "\n--ERR--\n";
}
?>
</body>
</html>