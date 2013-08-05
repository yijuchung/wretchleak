#!/usr/bin/perl

# Usage: perl get_user.pl [user ID] [output folder]

# External Call: wget, del (command prompt)

# Output: 
# 1. [user ID].txt in [output folder] 

# Function:
# Use wget to obtain personal infodelation and friend infodelation
# of specified user ID in wretch

# Check if user defined the input file and output folder

# use CGI qw/:standard/;
#
# use encoding "utf-8", STDOUT => "big5";
use URI::Escape::JavaScript qw(escape unescape);
use Encode; 

$sleep = 1;
$replace = 0;
if(-e "update"){
	$replace = 1;
}

$proxy = 0;

if(exists($ARGV[0]) && exists($ARGV[1])){

	# Ensure the server list and output folder is exist
	if(-e $ARGV[1]){

		# set quick flush 
		quick_flush();

	#	print "\n\n::Get WETCH User Infodelation::\n";

		$specified = 0;


		# file name of proxy list
		$user_id = $ARGV[0];

		# output folder
		$folder_out = $ARGV[1];

		# name of temp files
		$file_tmp = $folder_out."/".$user_id."_user";
		
		$file_tmp2 = $folder_out."/".$user_id."_friend";
		

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
		if($user_id ne ""){
			$ID_start = $user_id;
			$visit_count = "";

			# configure the user page and friend page of this ID
			$URL_user = $URL_user_base.$ID_start;
			$URL_friend = $URL_friend_base.$ID_start."&c=1";
	#		$folder_index = index_folder($ID_start);



			# if this ID is not captured yet
			if(1){

				if($replace != 0 && -e $file_tmp){						
					#	system("del $file_tmp");
				}

				if(! (-e $file_tmp) || -z $file_tmp){
					# generate sleep time
					if($sleep || ! -e $file_tmp ||  -z $file_tmp  ||  $replace != 0){
						$time_sleep = int(rand(2)) + 1;
						print "\n\nUser...(sleep = ".$time_sleep.")";
						sleep($time_sleep);
					}

					if($proxy){
						system("wget --load-cookies \"pl-bin/cks2.txt\" -t 1 -T 30 -q -Y on --referer=\"http://www.google.com\" -U \"Mozilla/5.0\" -O $file_tmp \"$URL_user\"");
					}else{
						system("wget --load-cookies \"pl-bin/cks2.txt\" -t 1 -T 30 -q --referer=\"http://www.google.com\" -U \"Mozilla/5.0\" -O $file_tmp \"$URL_user\"");
					}
				}

				if(! (-e $file_tmp) || -z $file_tmp){
	#				print " Server Failed.";

					#die();
				}

					# create info file
					$file_user = $folder_out."/".$ID_start.".info";
		
				if(! (-z $file_tmp) ){
					


					open(F_TMP, "$file_tmp") || die "$file_tmp: [$!]\n";
					open(F_USR, ">$file_user") || die "$file_user: [$!]\n";

					
					# read the captured file (page)
					$con = "";

					while($line=<F_TMP>){

						$con .= $line;

					}

					close(F_TMP);
					
					# delete all &nbsp;
					$con =~ s|&nbsp;||gis;
					
					# print $con;

					# match pattern strings
					$str_match_title = " <td class=\"sidetitle\" align=\"right\">";
					$str_match_title_2 = ">";
					$str_match_title_end = "</td>";

					$str_match_con = "<td class=\"side\"";
					$str_match_con_2 = ">";
					$str_match_con_end = "</td>";



					# search for first match
					$pos = index($con, $str_match_title);
					
					@tmp_title = ();
					@tmp_con = ();

					# if found, we do it!
					# you need to go to the html code to understand the following process

					$i = 0;
					while($pos > -1){
				
						$pos = index($con, $str_match_title_2, $pos + 1);
						$pos += length($str_match_title_2);
						$pos2 = index($con, $str_match_title_end, $pos + 1);
						$tmp_title[$i] = substr($con, $pos, $pos2 - $pos);

						$tmp_title[$i]  = trim($tmp_title[$i]);


						$pos = index($con, $str_match_con, $pos + 1);
						$pos = index($con, $str_match_con_2, $pos + 1);
						$pos += length($str_match_con_2);
						$pos2 = index($con, $str_match_con_end, $pos + 1);
						$tmp_con[$i] = substr($con, $pos, $pos2 - $pos);
						
						$tmp_con[$i]  = trim($tmp_con[$i]);
						$tmp_con[$i] =~ s|<.*?>| |gis;
						$tmp_con[$i] =~ s|\n| |gis;

						chomp $tmp_con[$i];

						print "\n".$tmp_title[$i]."->".encode("Big5", decode("utf8",$tmp_con[$i]));
					#	print "\n".$tmp_title[$i]."\[\|\|\]".$tmp_con[$i];

		
						$pos = index($con, $str_match_title, $pos2);

						$i++;


					}
					
					$posv = index($con, $title_visitor);
					if($posv > -1){
						$lenx = length($title_visitor);
						$posv += $lenx;
						$posv2 = index($con, '</font>', $posv + 1);
						
						if($posv2 > -1){
							$tmpv = substr($con, $posv, $posv2 - $posv);
							$tmpv = trim($tmpv);
							$visit_count = $tmpv;
						}


					}

					if($visit_count ne ""){
						print "\n".$title_visitor."\[\|\|\]".$visit_count;
					}

					# after extracted the user info, we write them to file
					# as not all user fill all blank in user file, we compare the title 
					$j = 0;

					while( $j <= $#title){
						
						print F_USR $title[$j].":";

						$match = 0;
						$k = 0;
						while( $k < $i){

							$pos = index($tmp_title[$k], $title[$j]);

							if($pos > -1){
								print F_USR $tmp_con[$k]."\n";
								$match = 1;
								last;
							}
							
							$k++;
						}
						
						# user have not fill this field
						if($match == 0){
							print F_USR "\n";
						}

						$j++;

					}

					print F_USR $title_visitor.$visit_count."\n";

					close(F_USR);
					if($i == 0){
						print "\n--USR_CLOSED--";
					}


				}else{
					open(F_USR, ">$file_user") || die "$file_user: [$!]\n";
					close(F_USR);					
					print "\n--USR_DIE--";

				}

				print "\n--USR_END--";
			}else{
			#	print "\nAlready Captured.";
			}


			# create friend file
			$file_friend = $folder_out."/".$ID_start.".friend";
			$file_friendx = $folder_out."/".$ID_start.".friendx";
# ----------------------Friends--------------------------
			
			# We check if friends is already captured , if not
			if( 1){

				if($replace != 0 && -e $file_tmp2){
				#	system("del $file_tmp2");
				}
	
				
				if(! (-e $file_tmp2) || -z $file_tmp2){

					if($sleep || ! -e $file_tmp2 ||  -z $file_tmp2  || $replace != 0){
						$time_sleep = int(rand(2)) + 1;
						print "\n\nFriends...(sleep = ".$time_sleep.")";
						sleep($time_sleep);
					}

					if($proxy){
						system("wget --load-cookies \"pl-bin/cks2.txt\" -t 1 -T 30 -q -Y on --referer=\"$URL_user\" -U \"Mozilla/5.0\" -O $file_tmp2 \"$URL_friend\"");
					}else{
						system("wget --load-cookies \"pl-bin/cks2.txt\" -t 1 -T 30 -q --referer=\"$URL_user\" -U \"Mozilla/5.0\" -O $file_tmp2 \"$URL_friend\"");
					}					

				}		
	
				if(! (-z $file_tmp2)){

					# create friend file
					$file_friend = $folder_out."/".$ID_start.".friend";
					open(F_TMP2, "$file_tmp2") || die "$file_tmp2: [$!]\n";

					$con = "";

					while($line=<F_TMP2>){

						$con .= $line;

					}

					close(F_TMP2);

					# match pattern string again = =...
					$str_match_friend = "ddtip(";				
					$str_match_friend_end = ");";

					$str_friend_num = "<div id=\"num_friends\">";
					$str_friend_num2 = "There are ";
					$str_friend_num_end = " friends";

					$tmp_friend_num = 0;

					# get total frn numbers
					$pos = index($con, $str_friend_num);
					if($pos > -1){
						$pos = index($con, $str_friend_num2, $pos + 1);
						if($pos > -1){
							$pos2 = index($con, $str_friend_num_end, $pos + 1);
							if($pos2 > -1){
							#	print $pos.",".$pos2;
								$tmp_friend_num= trim(substr($con, $pos + length($str_friend_num2) , $pos2 - $pos - length($str_friend_num_end) - 1));
							}
						}

					}

				#	print "\nExpected friend: ".$tmp_friend_num;



					@tmp_friend = ();
					@tmp_des = ();
					$first_friend = "";
					$frn_per_page = 0;
					$pos = index($con, $str_match_friend);

					if($pos > -1){

						while($pos > -1){				
							$pos2 = index($con, $str_match_friend_end, $pos + 1);
							$tmp_friendx = substr($con, $pos + length($str_match_friend) + 1, $pos2 - $pos);
							$tmp_friendx =~ s|\\u|\%u|gis;
							@tmp = split(/\",\"/, $tmp_friendx);
							if($total_friend == 0){
								$first_friend = $tmp[0];
							}
							push(@tmp_friend, $tmp[0]);
							push(@tmp_des, $tmp[1]);
							print "\n".@tmp[0]."[||]".@tmp[1];
							$total_friend++;
							$pos = index($con, $str_match_friend , $pos2 + 1);

						}

						# more than one page?
						$frn_per_page = $total_friend;

						$page = 2;
						$URL_friend2 = $URL_friend;
						$URL_friend_old = "";
						while($tmp_friend_num > $total_friend){

							$file_tmp3 = $file_tmp2.$page;
							$URL_friend_old = $URL_friend2;
							$URL_friend2 = $URL_friend."&p=".$page;
							$page++;
		
							if(-e $file_tmp3){
								#	system("del $file_tmp3");
							}

							if(! (-e $file_tmp3) || -z $file_tmp3){
								

								if($page <= 50){
#							if($sleep || ! -e $file_tmp3 ||  -z $file_tmp3  || $replace != 0){
								$time_sleep = int(rand(2)) + 1;
								print "\n\nFriends...(sleep = ".$time_sleep.")";
								sleep($time_sleep);								
#							}

								if($proxy){
									system("wget --load-cookies \"pl-bin/cks2.txt\" -t 1 -T 30 -q -Y on --referer=\"$URL_friend_old\"  -U \"Mozilla/5.0\" -O $file_tmp3 \"$URL_friend2\"");
								}else{
									system("wget --load-cookies \"pl-bin/cks2.txt\" -t 1 -T 30 -q --referer=\"$URL_friend_old\" -U \"Mozilla/5.0\" -O $file_tmp3 \"$URL_friend2\"");
								}
								}

							}		
					
							if(-e $file_tmp3 && ! (-z $file_tmp3)){



								open(F_TMP3, "$file_tmp3") || die "$file_tmp3: [$!]\n";

								$con = "";

								while($line=<F_TMP3>){

									$con .= $line;

								}
								close(F_TMP3);

								$pos = index($con, $str_match_friend);
								if($pos == -1){
									last;
								}
								while($pos > -1){				
									$pos2 = index($con, $str_match_friend_end, $pos + 1);
									$tmp_friendx = substr($con, $pos + length($str_match_friend) + 1, $pos2 - $pos);
									$tmp_friendx =~ s|\\u|\%u|gis;
									@tmp = split(/\",\"/, $tmp_friendx);
									if($total_friend == $frn_per_page){
										if($tmp[0] eq $first_friend){
											print "\n--FRN_ERR--";	
											$tmp_friend_num = $total_friend;
											last;
										}
									}
									push(@tmp_friend, $tmp[0]);
									push(@tmp_des, $tmp[1]);
								#	print "\n".@tmp[0]."[||]".@tmp[1];
									$total_friend++;
									$pos = index($con, $str_match_friend , $pos2 + 1);

								}
							}else{
								last;
							}

						}

						

# Parse Friend-----------------------------------------------

						$n = 0;
						open(F_FRN, ">$file_friend") || die "$file_friend: [$!]\n";
						open(F_FRNX, ">$file_friendx") || die "$file_friendx: [$!]\n";
						binmode(F_FRNX, ":utf8");

						# write to friend file
						while($n <= $#tmp_friend){
							$tmp_friend[$n] = trim($tmp_friend[$n]);
							$tmp_des[$n] = trim($tmp_des[$n]);
					#		print "\n".$tmp_friend[$n]."[||]".$tmp_des[$n];
							print "\n".$tmp_friend[$n].": ".$tmp_des[$n];
						#	print "\n".$tmp_friend[$n].": ".encode("Big5", decode("utf8",$tmp_des[$n]));
						#	print "\n".$tmp_title[$i]."->".encode("Big5", decode("utf8",$tmp_con[$i]));

							print F_FRN $tmp_friend[$n]."\|".$tmp_des[$n]."\n";
							print F_FRNX $tmp_friend[$n]."\[\|\|\]".unescape($tmp_des[$n])."\n";
							$n++;
							
						}

						close(F_FRN);
						close(F_FRNX);

						print "\nTotal Friends: ".$total_friend;
		
						if($total_friend == 0){
							print "\n--FRN_CLOSED--";
						}

					}else{
						print "\n--FRN_CLOSED--";
					}

				}else{
					print "\n--FRN_DIE--";
				}
				print "\n--FRN_END--";
			}else{
				print "\nAlready Captured.";
			#	system ("del ".$folder_out."\\".$ID_start.".toget");

			}



		}

	}else{
		
		print "\nOutput folder Error, please ensure it is available.";

	}

}else{

	print "\n\nUsage: perl get_user.pl [user ID] [output folder] ";

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