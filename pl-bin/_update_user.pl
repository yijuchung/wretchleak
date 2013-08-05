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
print F_LOG "UPDATE ".$start_time."\n";

$folder_name = sprintf "raw_%4d-%02d-%02d",$year+1900,$mon+1,$mday;
print F_LOG "BACKUP ".$folder_name;

# backup existing raw folder
#system("cp -R raw ".$folder_name);
$flag_bk = 0;
if(! (-e $folder_name)){
	system("mkdir ".$folder_name);
	if(-e $folder_name){
		system("xcopy /S /Y /Q raw ".$folder_name);
	}
	if ($? == -1) {
		print "Failed!!!";
		print F_LOG "FAILED";
	}elsif ($? & 127) {
		printf "child died with signal %d, %s coredump\n",
		($? & 127),  ($? & 128) ? 'with' : 'without';
		print F_LOG "FAILED";

	}else {
		printf "Backup Completed %d\n", $? >> 8;
		print F_LOG " OK\n";
		$flag_bk = 1;
	}
}else{
	print F_LOG " UP_TO_DATE\n";
	$flag_bk = 1;
}

if($flag_bk == 1){
	# Obtain all user in raw folder
	@userid = ();
	$tmp = "";
	open (PINGTEST, "dir /B raw |");
#	open (PINGTEST, "ls -t raw/ |");
	$i=1;
	while (<PINGTEST>){
	#	chomp $_;
		$pos = index($_, ".info");
		$tmp = substr($_, 0, $pos);
		if($pos > -1){
			$total_user++;
			push (@userid, $tmp);
	#		print $tmp."\n";
		}
		$i++;
	}
	close PINGTEST;
	print "\nTotal in queue:".$#userid."\n";

	print F_LOG "TOTAL ".$#userid." ";

	$num_ok = 0;
	#update id by id
	while($tmp = pop(@userid)){
		print "\n".$tmp." (".$#userid.")".": ";
		if(-e "raw_tmp/".$tmp.".friend"){
				print "Done\n";
		}else{
			sleep(1);
			system("perl pl-bin/get_user_up.pl ".$tmp." raw_tmp ");
			if ($? == -1) {
				print "Failed!!!\n";
			}elsif ($? & 127) {
				print "Failed!!!\n";
			}else {
			#	printf "Backup Completed %d\n", $? >> 8;
				print " OK\n";
				$num_ok++;
			}
		}
	}

	print F_LOG "COMP ".$num_ok."\n";
}

# Update Completed
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
$end_time = sprintf "%4d-%02d-%02d %02d:%02d:%02d\n", $year+1900,$mon+1,$mday,$hour,$min,$sec;
print F_LOG "END ".$end_time."\n";

close F_LOG;
print "\nAll done!\n";