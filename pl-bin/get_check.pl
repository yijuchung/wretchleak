#!/usr/bin/perl

# Usage: perl get_check.pl [description file]

# [split file] -> prepare manually

# External Call: del (command prompt)

# Function
# 1. read split character from [split file]
# 2. query user_id from table user though DBI 
# 3. query description from table friend for this user_id by user's friends
# 4. extract tokens and insert into table guess
# Random select from user id start from a to z 

# use DBI for DB connection.

use Encode; 

# ensure we have split file
if(exists($ARGV[0])){


	if(-e $ARGV[0] && ! -z $ARGV[0]){

		quick_flush();

		# all pattern files name
		$file_split = "pl-bin/split.txt";
		$file_name3 = "pl-bin/list_names_3.txt";
		$file_name2 = "pl-bin/list_names_2.txt";
		$file_family = "pl-bin/list_family.txt";
		$file_related = "pl-bin/list_related.txt";
		$file_merge = "pl-bin/list_merge.txt";
		$file_general_nick = "pl-bin/list_general_nick.txt";
		$file_general_word = "pl-bin/list_general_word.txt";

		$file_frnx = $ARGV[0];
		$path = "";
		$inid = "";
		$file_inferx = "";
		@tmp = split(/\//, $file_frnx);
		if($tmp[1] ne ""){
			$path  = $tmp[0];
			@tmp = split(/\./, $tmp[1]);
			if($tmp[0] ne ""){
				$inid = $tmp[0];
				$file_inferx = $path."/".$inid.".inferx";
			#	print $file_inferx."\n";
			}
		}
		
		


#		print "\n\n::Extract token from Friend's Nickname::\n";
		
		# for generating random index
		@char = ('q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm');

		# array to save split characters
		@list_split_char = ();
		@list_name3 = ();
		@list_name2 = ();
		@list_family = ();
		@list_related = ();
		@list_merge = ();
		@list_general_nick = ();
		@list_general_word = ();
		@friend_list = ();
		@friend_desc = ();


# ---------------- Read all pattern list into memory


	#	print "\nReading Friend Info...";

		# open split list
		open(FI, "$ARGV[0]")|| die " [$!]\n";

		# read all split char to array
		while($split_char = <FI>){
		#	print $split_char;
			chomp $split_char;
			@frn_info = split(/\[\|\|\]/, $split_char);
		#	print $frn_info[0]." ".$frn_info[1]."\n";

			push(@friend_list, $frn_info[0]);
			push(@friend_desc, $frn_info[1]);
		}

		close(FI);
	#	print "Done.";

	#	print "\nReading Split List...";

		# open split list
		open(FI, "$file_split")|| die " [$!]\n";

		$total_split = 0;

		# read all split char to array
		while($split_char = <FI>){
			chomp $split_char;

			$list_split_char[$total_split] = $split_char;
		#	print "\n".encode("Big5", decode("utf8", $list_split_char[$total_split]));

			$total_split++;
		}

		close(FI);
	#	print "Done.";


	#	print "\nReading Name 3 List...";

		# open split list
		open(FI, "$file_name3")|| die " [$!]\n";

		# read all split char to array
		while($tmp_line = <FI>){
			chomp $tmp_line;

			push(@list_name3, $tmp_line);
		#	print "\n".encode("Big5", decode("utf8",$tmp_line));

		}

		$str_name3 = join(",", @list_name3);


		close(FI);
	#	print "Done.";
		#system("pause");


	#	print "\nReading Name 2 List...";

		# open split list
		open(FI, "$file_name2")|| die " [$!]\n";

		# read all split char to array
		while($tmp_line = <FI>){
			chomp $tmp_line;

			push(@list_name2, $tmp_line);
		#	print "\n".encode("Big5", decode("utf8",$tmp_line));
			
		}

		close(FI);
		$str_name2 = join(",", @list_name2);
	#	print "Done.";


	#	print "\nReading Family List...";

		# open split list
		open(FI, "$file_family")|| die " [$!]\n";

		# read all split char to array
		while($tmp_line = <FI>){
			chomp $tmp_line;

			push(@list_family, $tmp_line);
		#	print "\n".encode("Big5", decode("utf8",$tmp_line));
			
		}

		close(FI);
	#	print "Done.";


	#	print "\nReading Related List...";

		# open split list
		open(FI, "$file_related")|| die " [$!]\n";

		# read all split char to array
		while($tmp_line = <FI>){
			chomp $tmp_line;
			if($tmp_line ne ''){
				push(@list_related, $tmp_line);
			#	print "\n".encode("Big5", decode("utf8",$tmp_line));
			}
			
		}

		close(FI);

	#	print "Done.";

	#	print "\nReading Merge List...";

		open(FI, "$file_merge")|| die " [$!]\n";

		while($tmp_line = <FI>){
			chomp $tmp_line;
			push(@list_merge, $tmp_line);
		#	print "\n".encode("Big5", decode("utf8",$tmp_line));

			
		}

		close(FI);
	#	print "Done.\n";


	#	print "\nReading General Nickname List...";

		open(FI, "$file_general_nick")|| die " [$!]\n";

		while($tmp_line = <FI>){
			chomp $tmp_line;
			push(@list_general_nick, $tmp_line);
		#	print "\n".encode("Big5", decode("utf8",$tmp_line));

			
		}

		close(FI);
	#	print "Done.\n";


	#	print "\nReading General Word List...";

		open(FI, "$file_general_word")|| die " [$!]\n";

		while($tmp_line = <FI>){
			chomp $tmp_line;
			push(@list_general_word, $tmp_line);
#			print "\n".encode("Big5", decode("utf8",$tmp_line));

			
		}

		close(FI);

	#	print "Done.\n";

		#system("pause");

		$char_selected = "";
		
			# if problem is happened
					# friend description array
				

					# friend group array
					@friend_group = ();

					# who set this user_id as friend
					@friend_set_id = ();

					# token array
					@friend_desc_token = ();

					$name_final_string = "";
					$real_name_string = "";
					$real_name_string_1 = "";
					$real_name_string_2 = "";
					$real_name_string_3 = "";
					$real_name_string_4 = "";
					$real_name_string_5 = "";

					
					# for final output, each step will have real name and TF array.
					@real_name = ();
					@tf_real_name = ();

					@real_name_1 = ();
					@tf_real_name_1 = ();

					@real_name_2 = ();
					@tf_real_name_2 = ();

					@real_name_3 = ();
					@tf_real_name_3 = ();

					@real_name_4 = ();
					@tf_real_name_4 = ();

					@real_name_5 = ();
					@tf_real_name_5 = ();


					@nick_name = ();
					@tf_nick_name = ();

					@tag = ();
					@tf_tag = ();
					
					@tag2 = ();
					@tf_tag2 = ();

					@token_2 = ();
					@tf_token_2 = ();
					@token_3 = ();
					@tf_token_3 = ();

					@token_2_no_merge = ();
					@token_3_no_merge = ();
					@tf_token_2_no_merge = ();
					@tf_token_3_no_merge = ();

					$final_real_name = "";


						#	print "\nAdding Friend Token...";

							$k = 0;
							
							# save all description tokens
							$friend_desc_string = "";

							@final = ();
							@name_candidate = ();
							@tf_name_candidate = ();

							# friend number
							$total_friend = $#friend_desc + 1;

							# how much friend have description
							$total_friend_desc = 0;

							# nick name is found 
							$got_nickname = 0;

							# 2-char length name is found
							$got_name2 = 0;

							# 3-char length name is found
							$got_name3 = 0;

							# how much description contains 2-char name
							$num_name2_desc = 0;

							# how much description contains 3-char name
							$num_name3_desc = 0;

							$success_step = 0;

							# split token by split characters
							while($k <= $#friend_desc){


								$a = $friend_desc[$k];
								chomp $a;
			

								# if not empty string
								if($a ne ''){

									$total_friend_desc++;
									
									# replace all matched split patterns into ,
									$a =~ s/ /,/gs;
									$i = 0;
									while($i < $total_split){
										# print "\n".$list_split_char[$i];

										# replace as ,
										$a =~ s/$list_split_char[$i]/,/gs;

										# print " > ".$a;
										$i++;
									}

									# replace all matched related patterns into ,
									$i = 0;
									while($i <= $#list_related){
										# print "\n".$list_split_char[$i];

										# replace as ,
										if(index($a, $list_related[$i]) > -1){
											$a =~ s/$list_related[$i]/,/sg;
											if(length($list_related[$i]) > 3){
												$j = 0;
												$got_tag = 0;
												while($j <= $#tag2){
													if($list_related[$i] eq $tag2[$j]){
														$tf_tag2[$j] ++;
														$got_tag = 1;
														last;
													}
													$j++;
												}
												if($got_tag == 0){
													push(@tag2, $list_related[$i]);
													push(@tf_tag2, 1);
												}
											}
										}
										# print " > ".$a;
										$i++;
									}
									
									#  replace symbol as ,
									$a =~ s/[\|\/\+)({}\#!\"=<>\[\]@~^?:\\;%_\$\*-.\'\`\^\/&]/,/sg;

									# so as other html related syntax
									 $a =~ s/[a-z]//sig;
									 $a =~ s/[0-9]//sg;
									 $a =~ s/quot//sg;
									 $a =~ s/amp//sg;
									 $a =~ s/lt//sg;
									 $a =~ s/gt//sg;
									

							#		print "\n$friend_list[$k] ->";
									
									# split into array by ,
									@token =  split(/,/, $a);
									$friend_desc_token[$k] = "";

									# chop out blank token, label name candidate
									foreach(@token){
										if($_ ne ''){
											$friend_desc_token[$k] .= $_.",";
											$leng_token = length($_);
											$str_print = $_;					
										#	print encode("Big5",decode("utf8", $str_print));
								#			print $str_print;
											
											if($leng_token == 6 || $leng_token == 9){
								#				print "(NC)";
												push(@name_candidate, $_);
											}
								#			print ",";
										}
									}
								}

								$k++;

							}
							

							# make name candidate unique
							undef %saw;
							@out = grep(!$saw{$_}++, @name_candidate);

							@name_candidate = @out;
							$p = 0;

							# initialize
							while($p <= $#name_candidate){			
								$tf_name_candidate[$p] = 0;
								$p++;
							}

							$j = 0;

							# calculate Term frequency of each candidate

							@friend_nc = ();
							@friend_token_dup = ();
							@token_num2_desc = ();
							@token_num3_desc = ();

							while($j < $k){
								$p = 0;

								$friend_nc[$j] = "";
								$friend_token_dup[$j] = 0;
								$token_num2_desc[$j] = 0;
								$token_num3_desc[$j] = 0;

								# check how much description contains same name candidate
								while($p <= $#name_candidate){
									if(index($friend_desc_token[$j], $name_candidate[$p]) > -1){
										$tf_name_candidate[$p]++;
										$friend_nc[$j] .= "[".$p."] ";
									}

									$p++;
								}

								$j++;
							}
							
							$p  = 0;

							@name_final = ();
							@tf_final = ();
							while($p <= $#name_candidate){			
							#	print encode("Big5", decode("utf8","\n$name_candidate[$p] : $tf_name_candidate[$p]"));
								if($tf_name_candidate[$p] > 0){
									push(@name_final, $name_candidate[$p]);
									push(@tf_final, $tf_name_candidate[$p]);
									
									$j = 0;
									if($tf_name_candidate[$p] > 1){
										while($j < $k){
											if(index($friend_nc[$j], "[".$p."]") > -1){
												$friend_token_dup[$j] = 1;
											}
					
											$j++;
										}
									}
								}
								$p++;
							}

							$j = 0;
							$total_friend_dup = 0;
							while($j < $k){
								if($friend_token_dup[$j] > 0){
									$total_friend_dup++;
								}
		
								$j++;
							}

							if($#tf_final == -1){
								$tf_final[0] = 0;
							}else{

								# we sort the name final by tf final
								@idx = sort {$tf_final[$b] <=> $tf_final[$a]}0..$#tf_final;
								@name_final = @name_final[@idx];
								@tf_final = @tf_final[@idx];
							}



						#	print "\nGuess Name: ";

							# print out all name candidate
							if($#name_final > -1){

						#		$p = 0;
						#		while($p <= $#name_final){

								#	print encode("Big5", decode("utf8",$name_final[$p])).",";
						#			print $name_final[$p].",";

						#			$name_final_string .= $name_final[$p].",".$tf_final[$p].",";

						#			$p++;
						#		}

						#		print "\n>> Guess REAL Name...\n";

								
								# seperate all name candidate into 2-char and 3-char token array
								$p = 0;
								while($p <= $#name_final){

								#	print "\n".encode("Big5", decode("utf8",$name_final[$p]))." -> ";				
						#			print "\n".$name_final[$p]." -> ";				

									if(length($name_final[$p]) == 6){

										print $tf_final[$p];
										push(@token_2, $name_final[$p]);
										push(@tf_token_2, $tf_final[$p]);


									}elsif(length($name_final[$p]) == 9){

									#	print $tf_final[$p];
										push(@token_3, $name_final[$p]);
										push(@tf_token_3, $tf_final[$p]);



									}else{

									#	print "ERROR";

									}
									$p++;
								}	

# ----------------------------------- STEP 1
# check if any 2-char token is in the position 2 of 3-char token

								$flag_realname = 0;
								$flag_step1 = 0;
						#		print "\n\nSTEP 1 (Token 2 in Token 3)...";

								# require: need both 2-char token and 3-char token exists
								if($#token_2 > -1 && $#token_3 > -1){
									$flag_step1 = 1;
									$i = 0;

									# for each 3-char token
									while($i <= $#token_3){
										$j = 0;

										# check if any 2-char token is in
										while($j <= $#token_2){
											
											# if found
											if(index($token_3[$i], $token_2[$j]) == 3){
											#	print "\n".encode("Big5", decode("utf8",$token_3[$i]))."  /  ".encode("Big5", decode("utf8",$token_2[$j]));			
												$tmp = $token_3[$i];
												
												$name_ok = 1;
												
												# check the "name" part, should not in merge pattern
												$k = 0;
												#print "\n".$tf_token_2[$j];
												while($k <= $#list_merge){
														if(index($tmp ,$list_merge[$k]) > -1){
															$name_ok = 0;
												#			print " In Merge!";
															last;
														}
														$k++;
													}
												
												$tmp =~ s/$token_2[$j]//sg;
											#	print " -> ".encode("Big5", decode("utf8",$tmp ));
												# the "family name" part, should be in family list
												$family_ok = 0;

												$k = 0;
												if($tf_token_2[$j] > 1){
													while($k <= $#list_family){
														if($tmp eq $list_family[$k]){
															$family_ok = 1;
															last;
														}
														$k++;
													}
												}

												# if all passed, we added into final result

												if($family_ok == 1 && $name_ok == 1){
													
													push(@real_name_1, $token_3[$i]);
													push(@tf_real_name_1, $tf_token_3[$i]);

													if($tf_token_2[$j] + $tf_token_3[$i] >=  6){
														$final_real_name = $token_3[$i];
													}
													$flag_realname = 1;
													$got_name3 = 1;
													$success_step = 1;

													$k = 0;
													while($k <= $#friend_desc){
														if(index($friend_desc[$k], $token_3[$i]) > -1){
															$token_num3_desc[$k] = 1;
														}

														$k++;
													}
												}

											}

											$j++;
										}

										$i++;
									}

								}else{
							#		print "Do not match requirement";
								}


								if($flag_realname == 0){
									if($flag_step1){
							#			print "NO RESULT";
									}
								}else{
							#		print "Got Real Name!";
							#		print "\n>> Real Name : ";

									# sort the real name result by TF
									@idx_1 = sort {$tf_real_name_1[$b] <=> $tf_real_name_1[$a]}0..$#tf_real_name_1;
									@real_name_1 = @real_name_1[@idx_1];
									@tf_real_name_1 = @tf_real_name_1[@idx_1];

									$real_name_string_1 = join(',', @real_name_1);

								#	print encode("Big5", decode("utf8",$real_name_string_1))."\n";
								#	print $real_name_string_1."\n";
								}



#----------------------------------- STEP2
# check the token with name list, if it is in name list , we count it as realname
									
								$flag_step2 = 0;
								$flag_realname = 0;

							#	print "\nSTEP 2 (List Name2 and List Name3)...";
								
								# check if any token3 is in $str_name3
								if($#token_3 > -1){
									$flag_step2 = 1;
								#	print "\nMatch token3 with Name 3...";

									$i = 0;
									while($i <= $#token_3){
										if(index($str_name3, $token_3[$i]) > -1){
											push(@real_name_2, $token_3[$i]);
											push(@tf_real_name_2, $tf_token_3[$i]);
											$flag_realname = 1;
											$got_name3 = 1;
											$success_step = 2;
										
											$k = 0;
											while($k <= $#friend_desc){
												if(index($friend_desc[$k], $token_3[$i]) > -1){
													$token_num3_desc[$k] = 1;
												}

												$k++;
											}
										}
										$i++;
									}



								#	print "Done.";

								}

								# check if any token2 is in $str_name2
								if($#token_2 > -1){
									$flag_step2 = 1;
								#	print "\nMatch token2 with Name 2...";
									$i = 0;
									while($i <= $#token_2){
										if($tf_token_2[$i] > 1 && index($str_name2, $token_2[$i]) > -1){
											push(@real_name_2, $token_2[$i]);
											push(@tf_real_name_2, $tf_token_2[$i]);

											$flag_realname = 1;
											$got_name2 = 1;
											$success_step = 2;
										
											$k = 0;
											while($k <= $#friend_desc){
												if(index($friend_desc[$k], $token_2[$i]) > -1){
													$token_num2_desc[$k] = 1;
												}

												$k++;
											}
										}
										$i++;
									}

							#		print "Done.";

								}

				
								if($flag_realname == 0){
									if($flag_step2){
								#		print "NO RESULT";
									}

								}else{
								#	print "Got Real Name!";

								}

								if($flag_realname){
								#	print "\n>> Real Name : ";

									@idx_2 = sort {$tf_real_name_2[$b] <=> $tf_real_name_2[$a]}0..$#tf_real_name_2;
									@real_name_2 = @real_name_2[@idx_2];
									@tf_real_name_2 = @tf_real_name_2[@idx_2];

									$real_name_string_2 = join(',', @real_name_2);

								#	print encode("Big5", decode("utf8",$real_name_string_2))."\n";
								#	print $real_name_string_2."\n";

								}

#----------------------------------- STEP3
# check 3-char token, if the first char is in family list.

									$flag_step3 = 0;
									$flag_realname = 0;

								#	print "\nSTEP 3 (List Family)...";
									if($#token_3 > -1){
										$flag_step3 = 1;


										$i = 0;
										while($i <= $#token_3){

											$j = 0;
											while($j <= $#list_family){
												if($tf_token_3[$i] > 1 && index($token_3[$i], $list_family[$j]) == 0){
													push(@real_name_3, $token_3[$i]);
													push(@tf_real_name_3, $tf_token_3[$i]);

													$flag_realname = 1;
													$got_name3 = 1;
													$success_step = 3;

													$k = 0;
													while($k <= $#friend_desc){
														if(index($friend_desc[$k], $token_3[$i]) > -1){
															$token_num3_desc[$k] = 1;
														}

														$k++;
													}
												}
												$j++;
											}
											$i++;
										}


									}else{
								#		print "Do not match requirement";

									}

								}


								if($flag_realname == 0){
									if($flag_step3){
								#		print "NO RESULT";
									}

								}else{
								 #	print "Got Real Name!";
								#	print "\n>> Real Name : ";

									@idx_3 = sort {$tf_real_name_3[$b] <=> $tf_real_name_3[$a]}0..$#tf_real_name_3;
									@real_name_3 = @real_name_3[@idx_3];
									@tf_real_name_3 = @tf_real_name_3[@idx_3];

									$real_name_string_3 = join(',', @real_name_3);

								#	print encode("Big5", decode("utf8",$real_name_string_3))."\n";
								#	print $real_name_string_3."\n";
								}


#----------------------------------- STEP4
# check merge list, if token contains merge list, then we use (token - merge_char)
# if other token contains (token - merge_char), we assume that it is a real name

								$flag_realname = 0;
								$flag_step4 = 0;
								
							#	print "\nSTEP 4 (Merge Words)...";


								if($#token_2 > -1){
									$flag_step4 = 1;
									
									$i = 0;
									
									@merge_part = ();
									@merge_pos = ();

									while($i <= $#token_2){
										$j = 0;
										$match_merge = 0;

										while($j < $#list_merge){
											
											# if contain merge word
											if(index($token_2[$i], $list_merge[$j]) > -1){
												push(@nick_name, $token_2[$i]);
												push(@tf_nick_name,  $tf_token_2[$i]);

												# we delete the merge word part
												$tmp = $token_2[$i];
												$tmp =~ s/$list_merge[$j]//sg;
											#	print "\nMerge: ".encode("Big5", decode("utf8",$token_2[$i]));
											#	print "\nMerge: ".$token_2[$i]."-> ".$list_merge[$j];
												$got_nickname = 1;
												$match_merge = 1;
												#save the left part
												push(@merge_part, $tmp);
												push(@merge_pos, $i);
												last;
											}

											$j++;
										}

										if($match_merge == 0 ){
										#	print "\nNo Merge: ".$token_2[$i];
											push(@token_2_no_merge, $token_2[$i]);
											push(@tf_token_2_no_merge, $tf_token_2[$i]);

										}


										$i++;
										
									}
									
									$i = 0;
									
									#check if any other token contains merge part, only once.
									while($i <= $#token_2_no_merge){
										$j = 0;
										$found = 0;
										while($j <= $#merge_part){
											
											if($merge_pos[$j] != $i){
												$pos = index($token_2_no_merge[$i], $merge_part[$j]);
												if($pos > -1){
													$pos2 = index($token_2_no_merge[$i], $merge_part[$j], $pos + 1);

													# ensure it is not duplicated merga like "旺旺" with merge word "旺"
													if($pos2 == -1 && $tf_token_2_no_merge[$i] > 1){
														push(@real_name_4, $token_2_no_merge[$i]);
														push(@tf_real_name_4, $tf_token_2_no_merge[$i]);

														$flag_realname = 1;
														$got_name2 = 1;
														$success_step = 4;

														$k = 0;
														while($k <= $#friend_desc){
															if(index($friend_desc[$k], $token_2_no_merge[$i]) > -1){
																$token_num2_desc[$k] = 1;
															}
															$k++;
														}
														$found = 1;	
														last;
													}
												}
											}

											$j++;
										}


											
										$i++;
										
									}
								}

								# the same way with token-3
								if($#token_3 > -1){


									$i = 0;
									$flag_step4 = 1;
				
									@merge_part = ();
									@merge_pos = ();
									while($i <= $#token_3){
										$j = 0;
										$match_merge = 0;

										while($j < $#list_merge){
											$pos_mer = index($token_3[$i], $list_merge[$j]);
											if($pos_mer == 0 || $pos_mer == 3 || $pos_mer == 6){
												push(@nick_name, $token_3[$i]);
												push(@tf_nick_name,  $tf_token_3[$i]);
												$tmp = $token_3[$i];
												$tmp =~ s/$list_merge[$j]//sg;
											#	print "\nMerge: ".encode("Big5", decode("utf8",$token_3[$i]));
											#	print "\nMerge: ".$token_3[$i]."-> ".$list_merge[$j];
												$got_nickname = 1;
												$match_merge = 1;
												push(@merge_part, $tmp);
												push(@merge_pos, $i);
												last;
											}
											$j++;
										}

										if($match_merge == 0 ){
										#	print "\nPush: ".$token_3[$i];
										#	print "\nNo Merge: ".$token_3[$i];
											push(@token_3_no_merge, $token_3[$i]);
											push(@tf_token_3_no_merge, $tf_token_3[$i]);

										}

										$i++;
										
									}

									$i = 0;
									while($i <= $#token_3_no_merge){
										$j = 0;
										$found = 0;
										while($j <= $#merge_part){
											
											if($merge_pos[$j] != $i){
												$pos = index($token_3_no_merge[$i], $merge_part[$j]);
												if( $pos > -1){
													$pos2 = index($token_3_no_merge[$i], $merge_part[$j], $pos + 1);

													if($pos2 == -1 && $tf_token_3_no_merge[$i] > 1){
														push(@real_name_4, $token_3_no_merge[$i]);
														push(@tf_real_name_4, $tf_token_3_no_merge[$i]);

														$flag_realname = 1;
														$got_name3 = 1;
														$success_step = 4;

														$k = 0;
														while($k <= $#friend_desc){
															if(index($friend_desc[$k], $token_3_no_merge[$i]) > -1){
																$token_num3_desc[$k] = 1;
															}

															$k++;
														}
														$found = 1;	
														last;
													}
												}
											}

											$j++;
										}


										$i++;
										
									}
			
								}
								if($flag_step4 == 0){
								
								#	print "Do not match requirement";
									@token_3_no_merge = @token_3;
									@tf_token_3_no_merge = @tf_token_3;


								}			
								
								if($flag_realname == 0){
									if($flag_step4){
								#		print "NO RESULT";
									}
								}else{
								#	print "Got Real Name!";
								#	print "\n>> Real Name : ";

									@idx_4 = sort {$tf_real_name_4[$b] <=> $tf_real_name_4[$a]}0..$#tf_real_name_4;
									@real_name_4 = @real_name_4[@idx_4];
									@tf_real_name_4 = @tf_real_name_4[@idx_4];

									$real_name_string_4 = join(',', @real_name_4);

								#	print encode("Big5", decode("utf8",$real_name_string_4))."\n";
								#	print $real_name_string_4."\n";
								}

							
								
#----------------------------------- STEP5
# we will use the token with no merge pattern (delete token used in step 4)
# all left tokens will compare with "common word" list (nickname part and general word)
# if not in common word list
# the token is assumed as real name.

								$flag_realname = 0;
								$flag_step5 = 0;

								$general_nick = "";
								$general_word = "";

								@token_2_final = ();
								@token_3_final = ();
								@tf_token_2_final = ();
								@tf_token_3_final = ();


							#	print "\nSTEP 5 (General Words)...";

								# requirement, the list of no merged token (created in step4)
								if($#token_3_no_merge > -1 || $#token_2_no_merge > -1){
									$flag_step5 = 1;

									$i = 0;
									while($i <= $#token_2_no_merge){
										$match_general = 0;
										
										$j = 0;
										while($j <= $#list_general_word){
											if(index($list_general_word[$j], $token_2_no_merge[$i]) > -1){
												$match_general = 1;
												$general_word .= $token_2_no_merge[$i].",";
												last;
											}
											$j++;
										}



										if($match_general == 0 && $tf_token_2_no_merge[$i] > 1){
											push(@token_2_final, $token_2_no_merge[$i]);
											push(@tf_token_2_final, $tf_token_2_no_merge[$i]);

										}else{
											push(@tag, $token_2_no_merge[$i]);
											push(@tf_tag, $tf_token_2_no_merge[$i]);
										}

										$i++;
									}

#-------------------------------------------

									$i = 0;
									while($i <= $#token_3_no_merge){
										$match_general = 0;

								#		print "\n".$token_3_no_merge[$i];
										$j = 0;
										while($j <= $#list_general_word){
											if(index($token_3_no_merge[$i], $list_general_word[$j] ) > -1){
												$match_general = 1;
												$general_word .= $token_3_no_merge[$i].",";
												last;

											}
											$j++;
										}

										if($match_general == 0){
											push(@token_3_final, $token_3_no_merge[$i]);
											push(@tf_token_3_final, $tf_token_3_no_merge[$i]);
										}else{
											push(@tag, $token_3_no_merge[$i]);
											push(@tf_tag, $tf_token_3_no_merge[$i]);

										}

										$i++;
									}
									
									if($general_nick ne ''){
									#	print "\nGeneral Nick: ".encode("Big5", decode("utf8", $general_nick));
									#	print "\nGeneral Nick: ".$general_nick;
									}

									if($general_word ne ''){
									#	print "\nGeneral Word: ".encode("Big5", decode("utf8", $general_word));
									#	print "\nGeneral Word: ".$general_word;
									}



									if($#token_3_final > -1){
										$i = 0;
										while($i <= $#token_3_final){

											$k = 0;
											while($k <= $#friend_desc){
												if(index($friend_desc[$k], $token_3_final[$i]) > -1){
													$token_num3_desc[$k] = 1;
												}

												$k++;
											}
											
											if($tf_token_3_final[$i] > 1){
												push(@real_name_5, $token_3_final[$i]);
												push(@tf_real_name_5, $tf_token_3_final[$i]);
											}else{
												push(@tag, $token_3_final[$i]);
												push(@tf_tag, $tf_token_3_final[$i]);
											}
								
											$flag_realname = 1;
											$got_name3 = 1;
											$success_step = 5;

											$i++;
										}

									}

									if($#token_2_final > -1){
										$i = 0;
										while($i <= $#token_2_final){
											$k = 0;
											while($k <= $#friend_desc){
												if(index($friend_desc[$k], $token_2_final[$i]) > -1){
													$token_num2_desc[$k] = 1;
												}

												$k++;
											}
											push(@real_name_5, $token_2_final[$i]);
											push(@tf_real_name_5, $tf_token_2_final[$i]);


											$flag_realname = 1;
											$got_name2 = 1;
											$success_step = 5;
	
										$i++;
										}
									}


								}else{
						#			print "Do not match requirement";

								}


								

								if($flag_realname == 0){
									if($flag_step5){
							#			print "NO RESULT";
									}
								}else{
							#		print "Got Real Name!";
							#		print "\n>> Real Name : ";

									@idx_5 = sort {$tf_real_name_5[$b] <=> $tf_real_name_5[$a]}0..$#tf_real_name_5;
									@real_name_5 = @real_name_5[@idx_5];
									@tf_real_name_5 = @tf_real_name_5[@idx_5];

									$real_name_string_5 = join(',', @real_name_5);

								#	print encode("Big5", decode("utf8",$real_name_string_5))."\n";
							#		print $real_name_string_5."\n";
								}


# -------------------------------------- STEPS END

								if($got_nickname){
							#		print "\n>> Nick Name : ";

									@idx_6 = sort {$tf_nick_name[$b] <=> $tf_nick_name[$a]}0..$#tf_nick_name;
									@nick_name = @nick_name[@idx_6];
									@tf_nick_name = @tf_nick_name[@idx_6];

									$nick_name_string = join(',', @nick_name);

								#	print encode("Big5", decode("utf8",$real_name_string_5))."\n";
								#	print $nick_name_string."\n";
								}


							$k = 0;
							while($k <= $#friend_desc){
								if($token_num3_desc[$k] == 1){
									$num_name3_desc++;
								}

								if($token_num2_desc[$k] == 1){
									$num_name2_desc++;
								}
								$k++;
							}


						#	print "\nTop Token Num: ".$tf_final[0];
						#	print "\nTotal Friend Dup: ".$total_friend_dup;
						#	print "\nGot: ";

							if($got_nickname){
						#		print "Nickname, ";
							}

							if($got_name2){
						#		print "2-Char ";
						#		print "($num_name2_desc), ";
							}

							if($got_name3){
						#		print "3-Char ";
						#		print "($num_name3_desc)";

							}


							if($success_step){
								#print "\nSuccess Step: ".$success_step;
							}

							print "\n--COMPLETE--";
						#	system("pause");
							
#---------------------Merge all results----------------------------


				@real_name = (@real_name_1,@real_name_2,@real_name_3,@real_name_4,@real_name_5);
				@tf_real_name = (@tf_real_name_1,@tf_real_name_2,@tf_real_name_3,@tf_real_name_4,@tf_real_name_5);


				@idx_7 = sort {$real_name[$b] cmp $real_name[$a]}0..$#real_name;
				@real_name = @real_name[@idx_7];
				@tf_real_name = @tf_real_name[@idx_7];



				@real_name_final_2 = ();
				@tf_real_name_final_2 = ();

				@real_name_final_3 = ();
				@tf_real_name_final_3 = ();



				$i = 0;
				while($i <= $#real_name){
					$plen = length($real_name[$i]);
					if($plen == 6){
						if($i == 0 || $real_name[$i] ne $real_name_final_2[$#real_name_final_2]){
							push(@real_name_final_2, $real_name[$i]);
							push(@tf_real_name_final_2, $tf_real_name[$i]);
						}
					}elsif($plen == 9){
						if(($i == 0 || $real_name[$i] ne $real_name_final_3[$#real_name_final_3]) && $real_name[$i] ne $final_real_name){
							push(@real_name_final_3, $real_name[$i]);
							push(@tf_real_name_final_3, $tf_real_name[$i]);
						}
					}
					$i++;
				}

				@idx_8 = sort {$tf_real_name_final_2[$b] <=> $tf_real_name_final_2[$a]}0..$#tf_real_name_final_2;
				@real_name_final_2 = @real_name_final_2[@idx_8];
				@tf_real_name_final_2 = @tf_real_name_final_2[@idx_8];

				@idx_8 = sort {$tf_real_name_final_3[$b] <=> $tf_real_name_final_3[$a]}0..$#tf_real_name_final_3;
				@real_name_final_3 = @real_name_final_3[@idx_8];
				@tf_real_name_final_3 = @tf_real_name_final_3[@idx_8];

				@idx_9 = sort {$tf_tag2[$b] <=> $tf_tag2[$a]}0..$#tf_tag2;
				@tag2 = @tag2[@idx_9];
				@tf_tag2 = @tf_tag2[@idx_9];

				@idx_9 = sort {$tf_tag[$b] <=> $tf_tag[$a]}0..$#tf_tag;
				@tag = @tag[@idx_9];
				@tf_tag = @tf_tag[@idx_9];

				@tagx = ();
				@tf_tagx = ();
				$i = 0;
				while($i <= $#tag){
					$j = 0;
					$duped = 0;
					while($j < $i){
						if($tagx[$j] eq $tag[$i]){
							$duped = 1;
							last;
						}
						$j++;
					}
					if($duped == 0){
						push(@tagx, $tag[$i]);
						push(@tf_tagx, $tf_tag[$i]);
					}
					$i++;
				}

				
				if($file_inferx ne ""){
					open(F_INF, ">$file_inferx") || die "$file_inferx: [$!]\n";					
				}				

				if($final_real_name ne ""){
					print "\nREAL_FIN=".$final_real_name;
					if($file_inferx ne ""){
						print F_INF "\nREAL_FIN=".$final_real_name;
					}					
				}

				if($#real_name_final_2 > -1){
					print "\nREAL2=";
					print join("\|", @real_name_final_2).":".join("\|", @tf_real_name_final_2);
					if($file_inferx ne ""){
						print F_INF "\nREAL2=";
						print F_INF join("\|", @real_name_final_2).":".join("\|", @tf_real_name_final_2);						
					}						
				}
#				$i = 0;
#				while($i <= $#real_name_final_2){
#					print $real_name_final_2[$i].":".$tf_real_name_final_2[$i]."\|";
#					$i++;
#				}

				if($#real_name_final_3 > -1){
					print "\nREAL3=";
					print join("\|", @real_name_final_3).":".join("\|", @tf_real_name_final_3);
					if($file_inferx ne ""){
						print F_INF "\nREAL3=";
						print F_INF join("\|", @real_name_final_3).":".join("\|", @tf_real_name_final_3);	
					}						
				}

#				$i = 0;
#				while($i <= $#real_name_final_3){
#					print $real_name_final_3[$i].":".$tf_real_name_final_3[$i]."\|";
#					$i++;
#				}

				if($#nick_name > -1){
					print "\nNICK=";
					print join("\|", @nick_name).":".join("\|", @tf_nick_name);
					if($file_inferx ne ""){
						print F_INF "\nNICK=";
						print F_INF join("\|", @nick_name).":".join("\|", @tf_nick_name);
					}						
				}

#				$i = 0;
#				while($i <= $#nick_name){
#					print $nick_name[$i].":".$tf_nick_name[$i]."\|";
#					$i++;
#				}

				if($#tagx > -1){
					print "\nTAG=";
					print join("\|", @tagx).":".join("\|", @tf_tagx);
					if($file_inferx ne ""){
						print F_INF "\nTAG=";
						print F_INF join("\|", @tagx).":".join("\|", @tf_tagx);
					}					
				}

#				$i = 0;
#				while($i <= $#tag){
#					print $tag[$i].":".$tf_tag[$i]."\|";
#					$i++;
#				}

				if($#tag2 > -1){
					print "\nTAG2=";
					print join("\|", @tag2).":".join("\|", @tf_tag2);
					if($file_inferx ne ""){
						print F_INF "\nTAG2=";
						print F_INF join("\|", @tag2).":".join("\|", @tf_tag2);
					}						
				}

				
				if($file_inferx ne ""){
					close(F_INF);
				}					
#				$i = 0;
#				while($i <= $#tag2){
#					print $tag2[$i].":".$tf_tag2[$i]."\|";
#					$i++;
#				}
	}else{

		print "\nError: input file do not exist";
	}

}else{

#	print "\n\nUsage: perl guess_name.pl [split file]";
}

sub quick_flush{

	$old_handle = select (STDOUT); 
	$| = 1; 
	select ($old_handle);
}