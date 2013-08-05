<?php
session_start();
?>
<html>
<body>
<?php
if ((isset($_SESSION['mmnet']) && $_SESSION['mmnet']  == "ok") || isset($_SESSION['sid']) && isset($_SESSION['usr2']) && $_SESSION['usr2'] != "" && isset($_SESSION['code']) && $_SESSION['code'] != "" ) {

	$msg = "";
	$id = "";
	if(isset($_POST['id'])  && isset($_POST['msg'])){
		$id = $_POST['id'];
		$msg = $_POST['msg'];


		if($id != "" && $msg != "" && $id == $_SESSION['usr2']){
						
			$handle = fopen("raw/".$id.".friendx", "w+");
			$wlen = fwrite($handle,$msg);
			fclose ($handle);

		//	echo $msg;
			$file_infer = "raw/".$id.".inferx";
			if(file_exists($file_infer)){
				$handle = fopen($file_infer, "rb");
				$contents = stream_get_contents($handle);
				fclose($handle);
				echo "\n--COMPLETE--";	
				echo $contents;
				echo "\n";
			}else{
				if($wlen == strlen($msg)){
					exec('perl pl-bin/get_check.pl raw/'.$id.'.friendx', $output );
					$res = join("\n", $output);
					echo $res."\n";
				}
			}
		}

	}
}
?>
</body>
</html>