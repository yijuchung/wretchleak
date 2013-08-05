<html>
<body>
<?php


if(isset($_POST['aeroplane']) && $_POST['aeroplane'] != ""){
	$str_time = time();
	$str_date = date("Y-m-d|H:i:s", $str_time);
	$phase = $_POST['aeroplane'];
	$ip = $_SERVER['REMOTE_ADDR']; 
	
	exec('perl pl-bin/check_friend.pl '.$phase.' first', $output );
	
	
	// Log it to log file
	$myFile = "userlog/userlog.txt";
	$fh = fopen($myFile, 'a+');
	if($fh){
		fwrite($fh, $str_time." ".$str_date." ".$_SERVER['REMOTE_ADDR']." ".$phase." GEN\n");
		fclose($fh);
	}
	
	
	echo "\nVC|".hash('md5', $ip.'無名小站'.$phase)."\n";
}
?>
</body>
</html>

