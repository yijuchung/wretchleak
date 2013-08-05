#!/usr/bin/perl

# Usage: perl get_break.pl [info file]

# [split file] -> prepare manually


# Function
# 1. read split character from [split file]
# 2. read extracted user info from info file
# 3. extract tokens and insert into table guess
# Random select from user id start from a to z 

# use DBI for DB connection.

use Encode; 

# ensure we have split file
if(exists($ARGV[0])){


	if(-e $ARGV[0] && ! -z $ARGV[0]){

		quick_flush();

		# all pattern files name
		$file_split = "pl-bin/split.txt";
		$file_related = "pl-bin/list_related2.txt";
		$file_connect = "pl-bin/list_connect.txt";

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
		@list_related = ();
		@list_connect = ();
		
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
			@frn_info = split(/\:/, $split_char);
		#	print $frn_info[0]." ".$frn_info[1]."\n";

			if($frn_info[0] eq "Nickname" ||  $frn_info[0] eq "Birthday" ||  $frn_info[0] eq "Education" || $frn_info[0] eq "Occupation" || $frn_info[0] eq "Hobby" || $frn_info[0] eq "Favorite"  || $frn_info[0] eq "Introduction"){
				push(@friend_list, $frn_info[0]);
				push(@friend_desc, $frn_info[1]);
			#	print($frn_info[0]."\n");
			}
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



		#system("pause");




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

		
		open(FI, "$file_connect")|| die " [$!]\n";

		# read all split char to array
		while($tmp_line = <FI>){
			chomp $tmp_line;
			if($tmp_line ne ''){
				push(@list_connect, $tmp_line);
			#	print "\n".encode("Big5", decode("utf8",$tmp_line));
			}
			
		}

		close(FI);		
		

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
				@tag2 = ();
				@tf_tag2 = ();
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
					$i++;
				}

				
				$i = 0;
				while($i <= $#list_connect){
					$a =~ s/$list_connect[$i]/,/sg;
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
				
		#		print " > ".encode("Big5", decode("utf8", $a));				



		#		print "\n$friend_list[$k] ->";
				
				# split into array by ,
				@token =  split(/,/, $a);
				$friend_desc_token[$k] = "";

				# chop out blank token, label name candidate
				foreach(@token){
					if($_ ne ''){
					
						$friend_desc_token[$k] .= $_.",";
						$leng_token = length($_);
			#			$str_print = $_;					
			#			print $str_print;
						
						if($leng_token>=6 && $leng_token <= 12){
			#				print encode("Big5",decode("utf8", $_));

							push(@name_candidate, $_);
						}
					}
				}
				
				foreach(@tag2){
					if($_ ne ''){
						$friend_desc_token[$k] .= $_.",";
						$leng_token = length($_);
			#			$str_print = $_;					
			#			print $str_print;
						
						if($leng_token>=6 && $leng_token <= 12){
							print encode("Big5",decode("utf8", $str_print));
			#				print ",";
			#				print "(NC)";
							push(@name_candidate, $_);
						}
					}
				}									
				
			}

			$k++;

		}
		
	#	@name_candidate = (@name_candidate,@tag2);
	#	@tf_name_candidate = (@tf_name_candidate,@tf_tag2);

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
		#	$tf_name_candidate[$j] = 1;
			# check how much description contains same name candidate
			while($p <= $#name_candidate){
				if(index($friend_desc_token[$j], $name_candidate[$p]) > -1){
					$tf_name_candidate[$p]++;
				}

				$p++;
			}

			$j++;
		}
		

		print("TAG3=");
	#	print encode("Big5", decode("utf8",join("\|",@name_candidate).":".join("\|", @tf_name_candidate)));						
		print join("\|",@name_candidate).":".join("\|", @tf_name_candidate);						

}
}else{

#	print "\n\nUsage: perl guess_name.pl [split file]";
}

sub quick_flush{

	$old_handle = select (STDOUT); 
	$| = 1; 
	select ($old_handle);
}