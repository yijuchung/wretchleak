#!/usr/bin/perl

# Usage: perl check_user.pl [user ID] [output folder]

# External Call: wget, del (command prompt)

# Output: 
# 1. [user ID].txt in [output folder] 

# Function:
# Use wget to obtain personal information and friend information
# of specified user ID in wretch

# Check if user defined the input file and output folder

# use CGI qw/:standard/;
#
# use encoding "utf-8", STDOUT => "big5";

use Encode; 

$sleep = 0;
$replace = 1;
$proxy = 1;

if(exists($ARGV[0]) && exists($ARGV[1])){

	# Ensure the server list and output folder is exist
	if(-e $ARGV[1]){

		# set quick flush 
		quick_flush();

	#	print "\n\n::Get WETCH User Information::\n";

		$specified = 0;


		# file name of proxy list
		$user_id = $ARGV[0];

		# output folder
		$folder_out = $ARGV[1];

		# name of temp files
		$file_tmp = $folder_out."/".$user_id.".friend";
		
	

		# URl of user and friend page
		$URL_user_base = "http://www.wretch.cc/user/";
		$URL_friend_base = "http://www.wretch.cc/friend/";
		

	#	print "\nID: ".$user_id;
	#	print "\nOutput to: \"".$folder_out."\"";


		# the title name
		$title[0] = "Nickname";
		$title[1] = "Gender";
		$title[2] = "Birthday";
		$title[3] = "Blood type";
		$title[4] = "Height";
		$title[5] = "Weight";
		$title[6] = "Education";
		$title[7] = "Occupation";
		$title[8] = "Hobby";
		$title[9] = "Favorite";
		$title[10] = "Dislike";
		$title[11] = "E-Mail";
		$title[12] = "MSN";
		$title[13] = "Yahoo Messenger";
		$title[14] = "QQ";
		$title[15] = "AIM";
		$title[16] = "Google Talk";
		$title[17] = "Skype";
		$title[18] = "Introduction";
		$title_visitor = "Total Visitors:";

# --------------- Start Shift the toget (Capture) ---------------------

	#	print "\nGetting User Info...";
		
		# We will continue capture ID until the toget list is empty (quite impossible)
		if($user_id ne "" && ! -e $file_tmp){
			$ID_start = $user_id;
			$visit_count = "";

			# configure the user page and friend page of this ID
			$URL_user = $URL_user_base.$ID_start;
			$URL_friend = $URL_friend_base.$ID_start."&c=1";
	#		$folder_index = index_folder($ID_start);

			# generate sleep time
				$time_sleep = int(rand(5)) + 2;
				sleep($time_sleep);

			# if this ID is not captured yet
			if(1){

				if($replace != 0 && -e $file_tmp){						
						system("rm $file_tmp2");
				}

				$wait_file = "queue/".$user_id.".wait";
				$lock_file = "queue/".$user_id.".lock";
				open(F_LOCK, ">$wait_file");
				close(F_LOCK);
				$wait = 0;

				while(!-e $lock_file && $wait <  30){
					sleep(1);
					$wait++;
				}

				if($proxy){
					system("wget -t 1 -T 30 -q -Y on -U \"Mozilla/2.0\" -O $file_tmp \"$URL_friend\"");
				}else{
					system("wget -t 1 -T 30 -q -U \"Mozilla/2.0\" -O $file_tmp \"$URL_friend\"");
				}

				print "\n--USR_END--";
			}else{
			#	print "\nAlready Captured.";
			}

		}
	}else{
		
		print "\nOutput folder Error, please ensure it is available.";

	}

}else{

	print "\n\nUsage: perl get_user.pl [user ID] [output folder] ";

}

if(-e "queue/".$user_id.".lock"){
	system("rm queue/".$user_id.".lock");
	sleep(1);
}


sub quick_flush{

	$old_handle = select (STDOUT); 
	$| = 1; 
	select ($old_handle);
}

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}


sub index_folder($){
	my $string = shift;

	$txp = substr($string, 0,  2);
	return $txp;
}

# modify it let proxy list work
# random_proxy