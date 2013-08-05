#! c:/perl/perl/exe

# Usage: perl da.pl 
# External Call: 

# function: read user survey data from DB:

use DBI;
$dbh = DBI->connect('DBI:mysql:wretch', 'wrinfo', 'wretchmmnet123') || die "Could not connect to database: $DBI::errstr";
$sth = $dbh->prepare('SELECT user_id, sc1, sc2, sc3, sc4, sc5, sc6, sc7, sc8, mc1, mc2 FROM survey');
$sth->execute();

print "user_id,sc1,sc2,sc3,sc4,sc5,sc6,sc7,sc8,mc1_1,mc1_2,mc1_3,mc1_4,mc1_5,mc1_6,mc1_7,mc1_8,mc1_9,mc2_1,mc2_2,mc2_3,mc2_4,mc2_5,mc2_6,mc2_7,mc2_8,mc2_9\n";
while(@result = $sth->fetchrow_array()){
	@tmp_ary = split(/,/, $result[9]);
	if($#tmp_ary < 8){
		$result[9] .= ",-1";
	}
	if($result[9] eq ""){
		$result[9] = "-1,-1,-1,-1,-1,-1,-1,-1,-1";
	}
	if($result[10] eq ""){
		$result[10] = "-1,-1,-1,-1,-1,-1,-1,-1,-1";
	}
	
	print join(",", @result);
	print "\n";
}
