<?php
session_start();
?>
<html>
<body>
<?php
//if ((isset($_SESSION['mmnet']) && $_SESSION['mmnet']  == "ok") || isset($_SESSION['sid']) && isset($_SESSION['usr2']) && $_SESSION['usr2'] != "" && isset($_SESSION['code']) && $_SESSION['code'] != "" ) {

	$id = "";
	if(isset($_GET['id'])){
		$id = $_GET['id'];
		$id = preg_replace('/[^a-z0-9]/i', '', $id); 
	}
//	if($id != "" && $_SESSION['usr2'] === $id ){
		
		$file_info = "raw/".$id.".info";
		$file_frnx = "raw/".$id.".friendx";
		
		if(file_exists($file_info) && file_exists($file_frnx)){
		echo 1;
			// Read existing user info
			$handle = fopen($file_info, "rb");
			$contents = stream_get_contents($handle);
			fclose($handle);
			$info_list = explode("\n", $contents);
			$i = 0;
			while($i < sizeof($info_list)){
				$tmp_list = explode(":", $info_list[$i], 2);
				if(sizeof($tmp_list) == 2 && $tmp_list[1] != ""){
					echo "\n".$tmp_list[0].":[||]".$tmp_list[1];
				}
				$i++;
			}
			echo "\n--USR_END--\n";

			$handle = fopen($file_frnx, "rb");
			$contents = stream_get_contents($handle);
			fclose($handle);
			$frn_list = explode("\n", $contents);
			echo $contents;
			echo "Total Friends: ".sizeof($contents);
			echo "\n--FRN_END--\n";				
		}else{
		echo 2;
			$temp = "perl pl-bin/get_user.pl ".$id." raw";
			echo exec($temp, $output);
			print_r($output);
			$res = join("\n", $output);
			//print_r($res);
			//echo $res;
		//	$res = str_replace("&", "&amp;", $res);
			echo $res."\n";
		}
	//}
//}
?>
</body>
</html>