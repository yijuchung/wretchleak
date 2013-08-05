#!/usr/bin/perl

# Usage: perl update_user.pl 
# External Call: get_user_up.pl, get_check_up.pl (command prompt)

# function, backup "raw" folder:
# 1. copy "raw" folder as "raw_[time]" 
# 2. update contents in "raw" folder by refetching all user's personal info and friend
# 3. do it periodically

open(F_LOG, ">>update_log.txt");



($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$start_time = sprintf "%4d-%02d-%02d %02d:%02d:%02d", $year+1900,$mon+1,$mday,$hour,$min,$sec;
print F_LOG "\n>>\nUPDATE ".$start_time;
print "\n\nUPDATE START ".$start_time;

$folder_name = sprintf "raw_%4d-%02d-%02d",$year+1900,$mon+1,$mday;
$uddate = sprintf "%4d-%02d-%02d",$year+1900,$mon+1,$mday;

# backup existing raw folder
#system("cp -R raw ".$folder_name);
$flag_bk = 0;
$flag_log = 0;
$folder_tmp = "raw_tmp";
$folder_log = "update_log";
$folder_raw = "raw";
$folder_backup = "/home/iengfat/wretchinfo/";


# make sure tmp folder is cleared
if(-e $folder_tmp){
	print F_LOG "\nMOVE ".$folder_tmp." ".$folder_tmp."_".$uddate;
	print "\nMove ".$folder_tmp." to ".$folder_tmp."_".$uddate;
	
	system("mv ".$folder_tmp." ".$folder_tmp."_".$uddate);	
	if ($? == -1) {
		print "Failed!!!";
		print F_LOG "FAILED";
	}elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		print F_LOG "FAILED";

	}else {
		if(! -e $folder_tmp){
			printf "->Clear Completed %d", $? >> 8;
			print F_LOG "OK";
			
		}else{
			printf "->Cannot Clear... %d", $? >> 8;
			print F_LOG " ERROR";
		}

	}	
}



if(!-e $folder_tmp){
	print F_LOG "\nCREATE ".$folder_tmp." ";
	print "\nCreate ".$folder_tmp." ";
	system("mkdir ".$folder_tmp);	
	if ($? == -1) {
		print "Failed!!!";
		print F_LOG "FAILED";
	}elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		print F_LOG "FAILED";

	}else {
		if( -e $folder_tmp){
			printf "->Create Completed %d", $? >> 8;
			print F_LOG "OK";
			
		}else{
			printf "->Cannot Create... %d", $? >> 8;
			print F_LOG " ERROR";
		}

	}	
	
}


# Create log folder
print F_LOG "\nCREATE ".$folder_log."/".$uddate." ";
print "\nCreate ".$folder_log."/".$uddate." ";
if(!-e $folder_log."/".$uddate){
	system("mkdir ".$folder_log."/".$uddate );	
	if ($? == -1) {
		print "Failed!!!";
		print F_LOG "FAILED";
	}elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		print F_LOG "FAILED";

	}else {
		if( -e $folder_log."/".$uddate){
			printf "->Create Completed %d", $? >> 8;
			print F_LOG "OK";
			
		}else{
			printf "->Cannot Create... %d", $? >> 8;
			print F_LOG " ERROR";
		}
		$flag_log = 1;
	}	
	
}else{
	printf "->Already exists";
	print F_LOG "EXISTS";
	$flag_log = 1;
}


# Obtain all user in raw folder
@userid = ();
$tmp = "";
#	open (PINGTEST, "dir /B raw |");
open (PINGTEST, "ls -t raw/ |");
$i=1;
while (<PINGTEST>){
#	chomp $_;
	$pos = index($_, ".info");
	$tmp = substr($_, 0, $pos);
	if($pos > -1){
		$total_user++;
		push (@userid, $tmp);
	#	print $tmp."\n";
	}
	$i++;
}
close PINGTEST;
print "\nTotal in queue:".($#userid + 1);

print F_LOG "\nTOTAL ".($#userid+1)." ";


$num_ok = 0;
#update id by id
while($tmp = pop(@userid)){
	print "\n".$tmp." (".($#userid+2).")"."-> ";
	if(-e $folder_tmp."/".$tmp.".inferx"){
			print "Done\n";
	}else{
	
	# check existence of previous 20 days
	#	$cur_time = time();
	#	$exist_day = 0;
	#	for($i = 1; $i <= 14; $i++){			
	#		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime($cur_time - (24 * 3600 * $i));			
	#		$check_time = sprintf "%4d-%02d-%02d", $year+1900,$mon+1,$mday;			
		#	print "\n".$check_time."->";
	#		if(-e $folder_backup."raw_".$check_time."/".$user_id."_user"){
		#		print "Exist";
	#			$exist_day++;
	#		}else{
		#		print "NOT Exist";
	#		}
	#	}
		
	#	if($exist_day == 14){
	#		printf "\nDataset is complete!!";
	#	}	
	
		sleep(1);
		if($flag_log == 1){
		#	system("ls -l > ".$folder_log."/".$uddate."/".$tmp.".glog");
			system("perl pl-bin/get_user_up.pl ".$tmp." ".$folder_tmp." > ".$folder_log."/".$uddate."/".$tmp.".glog");
		}else{
			system("perl pl-bin/get_user_up.pl ".$tmp." ".$folder_tmp);			
		}
		if ($? == -1) {
			print "Failed!!!";
			print F_LOG "\nGET FAILED ".$tmp;
			
		}elsif ($? & 127) {
			print "Failed!!!";
			print F_LOG "\nGET FAILED ".$tmp;
		}else {
		#	printf "Backup Completed %d\n", $? >> 8;
			print "OK";
		
			if(-e $folder_tmp."/".$tmp.".friendx"){
				system("perl pl-bin/get_check.pl ".$folder_tmp."/".$tmp.".friendx "." > ".$folder_log."/".$uddate."/".$tmp.".ilog");
				if(-e $folder_tmp."/".$tmp.".inferx"){
					print " INFERRED";						
				}
			}
			$num_ok++;
		}
	}
}

print F_LOG "\nCOMP ".$num_ok;

#change owner as wwwrun
if(-e $folder_tmp){
	print F_LOG "\nCHOWN ".$folder_tmp." ";
	print "\nChange owner ".$folder_tmp." ";
	system("chown -R wwwrun ".$folder_tmp);	
	if ($? == -1) {
		print "Failed!!!";
		print F_LOG "FAILED";
	}elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		print F_LOG "FAILED";

	}else {
		printf "->Completed %d", $? >> 8;
		print F_LOG "OK";
	}		
}	

# Backup current data
print F_LOG "\nBACKUP ".$folder_name." ";
print "\nBACKUP ".$folder_name." ";
if(! (-e $folder_name)){
#	system("mkdir ".$folder_name);
	system("cp -R raw ".$folder_name);
	if ($? == -1) {
		print "Failed!!!";
		print F_LOG "FAILED";
	}elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		print F_LOG "FAILED";

	}else {
		printf "->Backup Completed %d", $? >> 8;
		print F_LOG "OK";
		$flag_bk = 1;
	}
}else{
	print F_LOG "UP_TO_DATE";
	printf "->UP_TO_DATE";
	$flag_bk = 1;
}

# if backup is done, we swap folders
if(-e $folder_name){
	print F_LOG "\nSWAP ".$folder_raw." ".$folder_tmp." ";
	print "\nSwap ".$folder_raw." ".$folder_tmp;
	system("mv ".$folder_raw." _".$folder_raw);	
	if(!-e $folder_raw){
		system("mv ".$folder_tmp." ".$folder_raw);	
		if(-e $folder_raw){
			printf "-> Completed";
			print F_LOG "OK";

			print F_LOG "\nREMOVE _".$folder_raw." ";
			print "\nRemove _".$folder_raw;		
			system("rm -R  _".$folder_raw);	
			if(! -e "_".$folder_raw){
				printf "-> Completed";
				print F_LOG "OK";				
			}else{
				print "Failed!!!";
				print F_LOG "FAILED";	
			}
        }else{
			print "Failed!!!";
			print F_LOG "FAILED";	
		}		
	}else{
		print "Failed!!!";
		print F_LOG "FAILED";	
	}
	
}

#::::::::::::::::::::::::::::::::::::::::
# Capture Missed Users (During Update)
#::::::::::::::::::::::::::::::::::::::::
# Obtain all user in RAW Folder
$userid_bk = "";
$tmp = "";
open (PINGTEST, "ls -t raw |");
$i=1;
while (<PINGTEST>){
#	chomp $_;
	$pos = index($_, ".info");
	$tmp = substr($_, 0, $pos);
	if($pos > -1){
		$userid_bk .= $tmp.",";
	}
	$i++;
}
close PINGTEST;

# Obtain all user in Backuped Folder
@userid2 = ();
$tmp = "";
open (PINGTEST, "ls -t $folder_name |");
$i=1;
while (<PINGTEST>){
#	chomp $_;
	$pos = index($_, ".info");
	$tmp = substr($_, 0, $pos);
	if($pos > -1){
		$pos = index($userid_bk, $tmp.",");
		if($pos == -1){
			push (@userid2, $tmp);		
		}
	}
	$i++;
}
close PINGTEST;
print F_LOG "\nPATCH ".($#userid2 + 1)." ";
print "\nPATCH ".($#userid2 + 1)." ";

$num_ok = 0;
#update id by id
while($tmp = pop(@userid2)){
	print "\n".$tmp." (".($#userid2+2).")"."-> ";
	if(-e $folder_raw."/".$tmp.".inferx"){
			print "Done\n";
	}else{
		sleep(1);
		if($flag_log == 1){
		#	system("ls -l > ".$folder_log."/".$uddate."/".$tmp.".glog");
			system("perl pl-bin/get_user_up.pl ".$tmp." ".$folder_raw." > ".$folder_log."/".$uddate."/".$tmp.".glog");
		}else{
			system("perl pl-bin/get_user_up.pl ".$tmp." ".$folder_raw);			
		}
		if ($? == -1) {
			print "Failed!!!";
			print F_LOG "\nGET FAILED ".$tmp;
			
		}elsif ($? & 127) {
			print "Failed!!!";
			print F_LOG "\nGET FAILED ".$tmp;
		}else {
		#	printf "Backup Completed %d\n", $? >> 8;
			print "OK";
		
			if(-e $folder_raw."/".$tmp.".friendx"){
				system("perl pl-bin/get_check.pl ".$folder_raw."/".$tmp.".friendx "." > ".$folder_log."/".$uddate."/".$tmp.".ilog");
				if(-e $folder_raw."/".$tmp.".inferx"){
					print " INFERRED";						
				}
			}
			$num_ok++;
		}
	}
}

#moving backup folder to home disk
if(-e $folder_name){
	system("mv ".$folder_name." ".$folder_backup)
}

print F_LOG "\nCOMP ".$num_ok;


# Update Completed
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$end_time = sprintf "%4d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec;
print F_LOG "\nEND ".$end_time;

close F_LOG;
print "\nAll done!\n";