#! c:/perl/perl/exe

# Usage: perl wa.pl 
# External Call: 

# function: read user friend file and inferred:

use File::stat;
use Time::localtime;

# Function:::::::::::::::::::::::::::::::::::::::::::::::::
#----------------------------------------------------------

# function readFolder(foldername, mode, verbose)
# Mode is the parameters
# if verbose is set, list show the files found
sub readFolder
{
	my ($path, $pattern, $mode, $verbose, $trash) = @_;
	my $funcName = "readFolder";
	my @filelist = ();
	if(-e $path){
		my $tmp = "";
	    if($mode ne ""){
			open (PINGTEST, "ls -1 ".$mode." ".$path."/".$pattern." |");
		}else{
			open (PINGTEST, "ls -1  ".$path."/".$pattern." |");
		}
		while (<PINGTEST>){
			$tmp =  $_;
			chomp $tmp;
			if($mode eq "d" && ($tmp eq "." || $tmp eq "..")){
				next;
			}
			if($verbose == 1){
				print($_);
			}
			push(@filelist, $tmp);
		}
		close PINGTEST;
		if($verbose == 1){
			print "Total :".($#filelist + 1)."\n";	
		}
	}else{
		if($verbose == 1){
			errMsg($funcName, $path, 0);
		}
	}

	return(@filelist);	
}

# function readFile(path, verbose)
sub readFile
{
	my ($path, $verbose, $trash) = @_;
	my $funcName = "readFile";
	my @fileline = ();	
	if(-e $path){
		open(F_R, $path);
		my $tmp = "";
		while(<F_R>){
			$tmp = $_;
			chomp $tmp;		
			if($tmp ne ''){
				if($verbose == 1){
					print $_;
				}
				push(@fileline, $tmp);
			}
		}

	}else{
		if($verbose == 1){
			errMsg($funcName, $path, 0);
		}
	}
	
	return(@fileline);
}


sub errMsg{
	my ($funcName, $path, $code, $trash) = @_;
	
	# 0 -> file not exists
	if($code == 0){	
		print("\n".$funcName.": Specified path \"".$path."\" is not exists.\n");
	}

}

# Declaration::::::::::::::::::::::::::::::::::::::::::::::
#----------------------------------------------------------

my $ext_friend = ".friendx";
my $ext_infer = ".inferx";
my $ext_info = ".info";

my $raw_folder = "";
my $raw_file = "";
my $pos = 0;
my $tmp = "";
my $pure_file_name = "";

my $user_id = "";
my $raw_date = "";
my $num_day = 0;

my $num_frn = 0;
my $num_frn_des = 0;

my $num_frn_n2 = 0;
my $num_frn_n3 = 0;
my $num_frn_n = 0;

my $max_freq_n2 = 0;
my $max_freq_n3 = 0;

my $num_n2 = 0;
my $num_n3 = 0;
my $num_tag = 0;
my $num_tag2 = 0;
my $num_nick = 0;

my $have_num_real = 0;

my $name_real = "";
my @name_2 = ();
my @name_3 = ();
my @freq_name_2 = ();
my @freq_name_3 = ();
my @frn_des = ();

my @nick = ();
my @freq_nick = ();
my @tag = ();
my @tag2 = ();
my @freq_tag = ();
my @freq_tag2 = ();


my %user_day = ();
my @raw_folder_list = ();
my @raw_file_list = ();
my @file_line = ();
my @tmp_ary = ();

# MAIN:::::::::::::::::::::::::::::::::::::::::::::::::::::
#----------------------------------------------------------
@raw_folder_list = readFolder("..",  "raw*", "-d -t", 0);
print "user_id,raw_date,num_day,num_frn,num_frn_des,num_frn_n2,num_frn_n3,num_frn_n,max_freq_n2,max_freq_n3,num_n2,num_n3,num_tag,num_tag2,num_nick,frn_ok";
while($raw_folder = pop(@raw_folder_list)){
	@raw_file_list = ();
	@raw_file_list = readFolder($raw_folder,  "*".$ext_info, "", 0);
	@tmp_ary = split(/\_/, $raw_folder);
	$raw_date = $tmp_ary[1];
	$raw_file = "";
  while($raw_file = pop(@raw_file_list)){
	$pos = index($raw_file, ".info");
	$pure_file_name = substr($raw_file, 0, $pos);	
	@tmp_ary = split(/\//, $pure_file_name);
	$user_id = $tmp_ary[2];

	print "\n".$user_id;
	
	# check day
	if(exists  $user_day{$user_id}){
		$user_day{$user_id}++;
	}else{
		$user_day{$user_id} = 0;
	}


	# initialize
	$num_day = 0;
	$num_frn = 0;
	$num_frn_des = 0;
	$num_frn_n2 = 0;
	$num_frn_n3 = 0;
	$num_frn_n = 0;
	$max_freq_n2 = 0;
	$max_freq_n3 = 0;
	$num_n2 = 0;
	$num_n3 = 0;
	$num_tag = 0;
	$num_tag2 = 0;
	$num_nick = 0;
	$have_num_real = 0;
	$name_real = "";
	$frn_ok = 0;
	@name_2 = ();
	@name_3 = ();
	@freq_name_2 = ();
	@freq_name_3 = ();
	@nick = ();
	@freq_nick = ();
	@tag = ();
	@tag2 = ();
	@freq_tag = ();
	@freq_tag2 = ();
	
	@frn_des = ();	
	@tmp_ary = ();	

	
	if(-e $pure_file_name.$ext_friend){
		$frn_ok = 1;
		@file_line = ();
		@file_line = readFile($pure_file_name.$ext_friend, 0);	
		$num_frn = $#file_line + 1;
		while($tmp = pop(@file_line)){
			@tmp_ary = split(/\[\|\|\]/, $tmp);
			# have description
			if($#tmp_ary == 1 && $tmp_ary[1] ne ""){
				push(@frn_des, $tmp_ary[1]);
				$num_frn_des++;
			}
		}
		
		if(-e $pure_file_name.$ext_infer){
			@file_line = ();		
			@file_line = readFile($pure_file_name.$ext_infer, 0);	
			while($tmp = shift(@file_line)){
				@tmp_ary = split(/=/, $tmp);
				# have description
				if($#tmp_ary == 1){
					# Need to check [0] for head, then add up the name candidates
					if($tmp_ary[0] eq "REAL_FIN"){
						if($tmp_ary[1] ne ""){
							$have_num_real = 1;
							$name_real = $tmp_ary[1];
						#	print ("\n".$tmp_ary[1].",".$have_num_real."\n");
						}
						
					}elsif($tmp_ary[0] eq "REAL2"){
						#print $tmp_ary[1];
						@tmp_ary2 = split(/:/, $tmp_ary[1]);
						@name_2 = split(/\|/, $tmp_ary2[0]);
						@freq_name_2 = split(/\|/, $tmp_ary2[1]);
						
						# check the max frequency of exposed name
						$i = 0;
						while($i <= $#name_2){
							# let's recount
							$freq_name_2[$i] = 0;
							$j = 0;
							while($j <= $#frn_des){
								$pos = index($frn_des[$j], $name_2[$i]);
								while($pos > -1){
									$freq_name_2[$i]++;
									$pos = index($frn_des[$j], $name_2[$i], $pos+1);									
								}
								$j++;
							}						
							$i++;
						}
						#sort
						@freq_name_2 = sort { $a <=> $b } @freq_name_2;
						$max_freq_n2 = $freq_name_2[$#freq_name_2];
						
						# check how may friend exposed at least one name
						$j = 0;
						while($j <= $#frn_des){
							$i = 0;
							while($i <= $#name_2){
								$pos = index($frn_des[$j], $name_2[$i]);
								if($pos > -1){
									$num_frn_n2++;
									last;
								}
								$i++;
							}
							$j++;
						}
						
						$num_n2 = $#name_2 + 1;
						
					}elsif($tmp_ary[0] eq "REAL3"){
						@tmp_ary2 = split(/:/, $tmp_ary[1]);
						@name_3 = split(/\|/, $tmp_ary2[0]);
						@freq_name_3 = split(/\|/, $tmp_ary2[1]);	

						# check of "final name" is in name3, if not, add it
						if($have_num_real == 1){

							$dup = 0;
							$i = 0;
							while($i <= $#name_3){
								if($name_real eq $name_3[$i]){
									$dup = 1;
									last;
								}
								$i++;
							}															
							if($dup == 0){
								push(@name_3, $name_real);
							}
						}
												
						
						# check the max frequency of exposed full name
						$i = 0;
						while($i <= $#name_3){
							# let's recount
							$freq_name_3[$i] = 0;
							$j = 0;
							while($j <= $#frn_des){
								$pos = index($frn_des[$j], $name_3[$i]);
								while($pos > -1){
									$freq_name_3[$i]++;
									$pos = index($frn_des[$j], $name_3[$i], $pos+1);									
								}
								$j++;
							}						
							$i++;
						}
						#sort
						@freq_name_3 = sort { $a <=> $b } @freq_name_3;
						$max_freq_n3 = $freq_name_3[$#freq_name_3];						
						

						# check how may friend exposed at least one full name
						$i = 0;
						$j = 0;
						while($j <= $#frn_des){
							$i = 0;
							while($i <= $#name_3){
								$pos = index($frn_des[$j], $name_3[$i]);
								if($pos > -1){
									$num_frn_n3++;
									$got = 1;
									last;
								}
								$i++;
							}						
							$j++;
						}						
						$num_n3 = $#name_3 + 1;
					}elsif($tmp_ary[0] eq "NICK"){
						@tmp_ary2 = split(/:/, $tmp_ary[1]);
						@nick = split(/\|/, $tmp_ary2[0]);
						@freq_nick = split(/\|/, $tmp_ary2[1]);						
						$num_nick = $#nick + 1;
					}elsif($tmp_ary[0] eq "TAG"){
						@tmp_ary2 = split(/:/, $tmp_ary[1]);
						@tag = split(/\|/, $tmp_ary2[0]);
						@freq_tag = split(/\|/, $tmp_ary2[1]);	
						$num_tag = $#tag + 1;
					}elsif($tmp_ary[0] eq "TAG2"){
						@tmp_ary2 = split(/:/, $tmp_ary[1]);
						@tag2 = split(/\|/, $tmp_ary2[0]);
						@freq_tag2 = split(/\|/, $tmp_ary2[1]);						
						$num_tag2 = $#tag2 + 1;
					}					
				}
			}
			
			# how many friends at least exposed one name / fname?
			if($#name_3 > -1 && $#name_2 > -1){
				$i = 0;
				$j = 0;
				while($j <= $#frn_des){
					$i = 0;
					$got = 0;
					while($i <= $#name_3){
						$pos = index($frn_des[$j], $name_3[$i]);
						if($pos > -1){
							$num_frn_n++;
							$got = 1;
							last;
						}
						$i++;
					}
					
					if($got == 0){
						$i = 0;
						while($i <= $#name_2){
							$pos = index($frn_des[$j], $name_2[$i]);
							if($pos > -1){
								$num_frn_n++;
								last;
							}
							$i++;
						}							
					}
					$j++;
				}				
			}else{
				if($#name_3 > -1){
					$num_frn_n = $num_frn_n3;
				}else{
					$num_frn_n = $num_frn_n2;
				}
			}
		}
	}	

	print ",".$raw_date.",".$user_day{$user_id}.",".$num_frn.",".$num_frn_des.",".$num_frn_n2.",".$num_frn_n3.",".$num_frn_n.",".$max_freq_n2.",".$max_freq_n3.",".$num_n2.",".$num_n3.",".$num_tag.",".$num_tag2.",".$num_nick.",".$frn_ok;
  }
#  print $raw_folder.",".($#raw_file_list + 1)."\n";  
}

print "\n";

