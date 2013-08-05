#!/usr/bin/perl

# Usage: perl queue.pl 
# function monitor the user queue in folder "queue"

@userid = ();
@lock_target = ();
$lock_time = 0;
$num_using = 0;
$num_max = 4;
$old_num_using = 0;
print "\n::Queue Manager::";
$printed = 0;
while(1){
	sleep(1);
	$tmp = "";
	open (PINGTEST, "ls -t queue/ |");
	$locked = 0;
	$num_using = 0;
	@lock_target = ();
	while (<PINGTEST>){
	#	chomp $_;
		$pos = index($_, ".wait");
		$tmp = substr($_, 0, $pos);
		if($pos > -1){
			$total_user++;
			push (@userid, $tmp);
			print "\nWaiting: ".$tmp;
			system("rm queue/".$tmp.".wait");
		}

		$pos2 = index($_, ".lock");
		if($pos2 > -1){
			push(@lock_target, substr($_, 0, $pos2));
			$locked = 1;
			$num_using++;
		}
	}
	close PINGTEST;
	if($num_using < $num_max){
		if($user_id = pop (@userid)){	
			$num_using++;
			$wait_file = "queue/".$user_id.".lock";
			while( ! -e $wait_file){
				open(F_LOCK, ">$wait_file");
				close(F_LOCK);	
			}
			system("chown wwwrun ".$wait_file);
			print "\nLocked to :".$user_id;
	#		$lock_target = $user_id;
			push(@lock_target,$user_id);
		}
	}

	$lock_time++;		
	if($lock_time > 120){
		if(-e "queue/".$lock_target[0].".lock"){
			print "\nForced Unlock to :".$lock_target[0];
			system("rm queue/".$lock_target[0].".lock");
			$printed = 0;
		}
		$lock_time = 0;

	}
	if($num_using != $old_num_using){
		if($num_using == 0){
			print "\nFree...";
		}else{
			print "\nLocks :".join(",", @lock_target);
		}
		$old_num_using = $num_using;
		$lock_time = 0;				
	}

}
