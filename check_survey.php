<?php
session_start();
?>
<html>
<body>
<?php
if ((isset($_SESSION['usr2']) && $_SESSION['usr2'] != "" && $_SESSION['usr2'] == $_POST['uid'] && (isset($_SESSION['mmnet']) && $_SESSION['mmnet']  == "ok")) || (isset($_SESSION['sid']) && isset($_SESSION['usr2']) && $_SESSION['usr2'] != "" && isset($_SESSION['code']) && $_SESSION['code'] != "" && $_SESSION['usr2'] == $_POST['uid'])) {
	$uid =  $_POST['uid'];

	$id = "wrinfo";
	$pwd = "wretchmmnet123";
	$db = "wretch";
	$db_selected = 0;

	$con = mysql_connect("localhost", $id, $pwd);

	if($con){

		$db_selected = mysql_select_db($db);

		if($db_selected){
			$sql = "select * from survey where user_id='$uid'";
			$result = mysql_query($sql);
			if($result){
				$numx = mysql_num_rows($result);
				if($numx == 0){
					echo "\n--OKOK--\n";
				}else{
					echo "\n--DONE--\n";
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