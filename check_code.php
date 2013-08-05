<?php
session_start();
?>
<html>
<body>
<?php
$id = "";
if(isset($_SESSION['sid']) && isset($_POST['boat']) && $_SESSION['sid'] != "" && $_SESSION['sid'] == $_POST['boat']  && isset($_POST['tank']) && $_POST['tank'] != "" && isset($_POST['aeroplane']) && $_POST['aeroplane'] != "" ){
	$str_time = time();
	$str_date = date("Y-m-d|H:i:s", $str_time);
	$user_id = $_POST['aeroplane'];
	$code_id = $_POST['tank'];

//	echo $user_id." ".$code_id;
	exec('perl pl-bin/check_user.pl '.$user_id.' raw', $output );
	echo join("\n", $output);
	$i = 0;
	$found = 0;
	while($i < sizeof($output)){
		if(strpos($output[$i], $code_id) === false){
		}else{
			$found = 1;
			break;
		}

		$i++;
	}
	
	// Log it to log file
	$myFile = "userlog/userlog.txt";
	$fh = fopen($myFile, 'a+');
	if($fh){
		fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$user_id." VER ");
	}	

	if($found == 1){
		$_SESSION['usr'] = $user_id;
		$_SESSION['code'] = $code_id;
		echo "\nRES|PASSED\n";
		if($fh){
			fwrite($fh, "1\n");
		}			
	}else{
		$_SESSION['usr'] = "";
		$_SESSION['code'] = "";
		echo "\nRES|FAILED\n";
		if($fh){
			fwrite($fh, "0\n");
		}			
	}

	if($fh){
		fclose($fh);
	}	
	
	
}

?>
</body>
</html>