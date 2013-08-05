rm(list=ls(all=TRUE));
source("R-lib/common.R");
source("R-lib/my.legend.R");
source("R-lib/my.sim.IO.R");
source("R-lib/my.fig.R");
source("R-lib/my.sim.R");

thres_num_frn = 20;
flag_frn_open = 1;

my.sim.read("data");
rdata$user_id = as.character(rdata$user_id);
rdata$raw_date = as.character(rdata$raw_date);

my.sim.read2("data_sur");
rdata_sur$user_id = as.character(rdata_sur$user_id);

bcol.sky = topo.colors(100);
bcol.red = sort(grep("red",colors()));

# got ID which have at least 2 days
max_id = rdata$user_id[rdata$num_day==1];

# Only select start and end day
rdata_day.start = rdata[1,];
rdata_day.end = rdata[1,];

rdata_day.start$num_day = 999;
rdata_day.end$num_day = 999;

if(flag_frn_open == 1){
	my.sim.output.path = "done/";
	tmp =  sapply(max_id, function(y) {
		max_day = max(rdata$num_day[rdata$user_id == as.character(y)]);
		if(rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == 0] != 0 & rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == max_day] != 0 & rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){
			rdata_day.start <<- merge(rdata_day.start, rdata[rdata$user_id == as.character(y) & rdata$num_day == 0,], all=T);
			rdata_day.end <<- merge(rdata_day.end, rdata[rdata$user_id == as.character(y) & rdata$num_day == max_day ,], all=T);
		}
	});
}else{
	my.sim.output.path = "done20/";
	tmp =  sapply(max_id, function(y) {
		max_day = max(rdata$num_day[rdata$user_id == as.character(y)]);
		if(rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){
			rdata_day.start <<- merge(rdata_day.start, rdata[rdata$user_id == as.character(y) & rdata$num_day == 0,], all=T);
			rdata_day.end <<- merge(rdata_day.end, rdata[rdata$user_id == as.character(y) & rdata$num_day == max_day ,], all=T);
		}
	});
}

rdata_day.start = rdata_day.start[rdata_day.start$num_day != 999,];
rdata_day.end = rdata_day.end[rdata_day.end$num_day != 999,];

# Unconditioned Date Set
rdata_day_full.start = rdata[1,];
rdata_day_full.end = rdata[1,];

rdata_day_full.start$num_day = 999;
rdata_day_full.end$num_day = 999;

tmp =  sapply(max_id, function(y) {
	max_day = max(rdata$num_day[rdata$user_id == as.character(y)]);
	if(rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == 0] != 0 & rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){	
		rdata_day_full.start <<- merge(rdata_day_full.start, rdata[rdata$user_id == as.character(y) & rdata$num_day == 0,], all=T);
		rdata_day_full.end <<- merge(rdata_day_full.end, rdata[rdata$user_id == as.character(y) & rdata$num_day == max_day ,], all=T);
	}
});

rdata_day_full.start = rdata_day_full.start[rdata_day_full.start$num_day != 999,];
rdata_day_full.end = rdata_day_full.end[rdata_day_full.end$num_day != 999,];




#:::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Leaked and non-leaked Users
#:::::::::::::::::::::::::::::::::::::::::::::::

# We only analyze users which is leaked initially

if(flag_frn_open == 1){
	rdata_day_leaked.start = rdata_day.start[rdata_day.start$num_frn_n > 0,];
}else{
	rdata_day_leaked.start = rdata_day.start;
}
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day.end$user_id);
rdata_day_leaked.end = rdata_day.end[match_start_end,];


leaked.start.total_length = length(rdata_day_leaked.start$user_id);
leaked.start = length(rdata_day_leaked.start$user_id[rdata_day_leaked.start$num_n2 > 0 | rdata_day_leaked.start$num_n3 > 0]) / leaked.start.total_length * 100;
non_leaked.start = 100 - leaked.start;

leaked.end.total_length = length(rdata_day.end$user_id);
leaked.end = length(rdata_day_leaked.end$user_id[rdata_day_leaked.end$num_n2 > 0 | rdata_day_leaked.end$num_n3 > 0]) / leaked.end.total_length * 100;
non_leaked.end = 100 - leaked.end;


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Leaked and non-leaked Users based on Survey Result (Protect)
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

user_id.sur_sc2.y = rdata_sur$user_id[rdata_sur$sc2 == 1];
user_id.sur_sc2.n = rdata_sur$user_id[rdata_sur$sc2 == 0];

match_survey_list = match(user_id.sur_sc2.y, rdata_day.start$user_id);
rdata_day_sc2.y = rdata_day.start[match_survey_list[!is.na(match_survey_list)], ];
leaked_sc2.y.total_length = length(rdata_day_sc2.y$user_id);
leaked_sc2.y = length(rdata_day_sc2.y $user_id[rdata_day_sc2.y$num_n2 > 0 | rdata_day_sc2.y $num_n3 > 0]) / leaked_sc2.y.total_length * 100;
non_leaked_sc2.y = 100 - leaked_sc2.y;


match_survey_list = match(user_id.sur_sc2.n, rdata_day.start$user_id);
rdata_day_sc2.n = rdata_day.start[match_survey_list[!is.na(match_survey_list)], ];
leaked_sc2.n.total_length = length(rdata_day_sc2.n$user_id);
leaked_sc2.n = length(rdata_day_sc2.n $user_id[rdata_day_sc2.n$num_n2 > 0 | rdata_day_sc2.n $num_n3 > 0]) / leaked_sc2.n.total_length * 100;
non_leaked_sc2.n = 100 - leaked_sc2.n;


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Change on Ratio of Leaked Friend Description
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# We only analyze users which is leaked initially
rdata_day_leaked.start = rdata_day.start[rdata_day.start$num_frn_n > 0,];
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day.end$user_id);
rdata_day_leaked.end = rdata_day.end[match_start_end,];

rdata_day_leaked.length = length(rdata_day_leaked.end$num_frn_n);
ratio_decreased = sum(rdata_day_leaked.end$num_frn_n < rdata_day_leaked.start$num_frn_n) / rdata_day_leaked.length * 100;
ratio_equal = sum(rdata_day_leaked.end$num_frn_n == rdata_day_leaked.start$num_frn_n) / rdata_day_leaked.length * 100;
ratio_increased = sum(rdata_day_leaked.end$num_frn_n > rdata_day_leaked.start$num_frn_n) / rdata_day_leaked.length * 100;


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Change on Ratio of Leaked Real Name
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# We only analyze users which is leaked initially
rdata_day_leaked.start = rdata_day.start[rdata_day.start$num_frn_n > 0,];
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day.end$user_id);
rdata_day_leaked.end = rdata_day.end[match_start_end,];

rdata_day_leaked.length = length(rdata_day_leaked.end$num_frn_n);
ratio_decreased.n2 = sum(rdata_day_leaked.end$num_n2 < rdata_day_leaked.start$num_n2) / rdata_day_leaked.length * 100;
ratio_equal.n2 = sum(rdata_day_leaked.end$num_n2 == rdata_day_leaked.start$num_n2) / rdata_day_leaked.length * 100;
ratio_increased.n2 = sum(rdata_day_leaked.end$num_n2 > rdata_day_leaked.start$num_n2) / rdata_day_leaked.length * 100;

ratio_decreased.n3 = sum(rdata_day_leaked.end$num_n3 < rdata_day_leaked.start$num_n3) / rdata_day_leaked.length * 100;
ratio_equal.n3 = sum(rdata_day_leaked.end$num_n3 == rdata_day_leaked.start$num_n3) / rdata_day_leaked.length * 100;
ratio_increased.n3 = sum(rdata_day_leaked.end$num_n3 > rdata_day_leaked.start$num_n3) / rdata_day_leaked.length * 100;

ratio_decreased.n = sum((rdata_day_leaked.end$num_n3 + rdata_day_leaked.end$num_n2)  < (rdata_day_leaked.start$num_n3 + rdata_day_leaked.start$num_n2)) / rdata_day_leaked.length * 100;
ratio_equal.n = sum((rdata_day_leaked.end$num_n3 + rdata_day_leaked.end$num_n2) == (rdata_day_leaked.start$num_n3 + rdata_day_leaked.start$num_n2)) / rdata_day_leaked.length * 100;
ratio_increased.n = sum((rdata_day_leaked.end$num_n3 + rdata_day_leaked.end$num_n2) > (rdata_day_leaked.start$num_n3 + rdata_day_leaked.start$num_n2)) / rdata_day_leaked.length * 100;



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Change on Ratio of Leaked Friend Description by Survey
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# We only analyze users which is leaked initially
rdata_day_leaked.start = rdata_day.start[rdata_day.start$num_frn_n > 0,];
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day.end$user_id);
rdata_day_leaked.end = rdata_day.end[match_start_end,];

#situation1 -> Never change
user_id.sur_sit1 = rdata_sur$user_id[rdata_sur$sc7 == 0 & rdata_sur$sc8 == 0];
match_survey_list = match(user_id.sur_sit1, rdata_day_leaked.start$user_id);
sit1_rdata_day_leaked.start = rdata_day_leaked.start[match_survey_list[!is.na(match_survey_list)], ];
sit1_rdata_day_leaked.end = rdata_day_leaked.end[match_survey_list[!is.na(match_survey_list)], ];

sit1_rdata_day_leaked.length = length(sit1_rdata_day_leaked.end$num_frn_n);
sit1_ratio_decreased = sum(sit1_rdata_day_leaked.end$num_frn_n < sit1_rdata_day_leaked.start$num_frn_n) / sit1_rdata_day_leaked.length * 100;
sit1_ratio_equal = sum(sit1_rdata_day_leaked.end$num_frn_n == sit1_rdata_day_leaked.start$num_frn_n) / sit1_rdata_day_leaked.length * 100;
sit1_ratio_increased = sum(sit1_rdata_day_leaked.end$num_frn_n > sit1_rdata_day_leaked.start$num_frn_n) / sit1_rdata_day_leaked.length * 100;


#situation2 -> Change Later Only
user_id.sur_sit2 = rdata_sur$user_id[rdata_sur$sc7 == 0 & rdata_sur$sc8 == 1];
match_survey_list = match(user_id.sur_sit2, rdata_day_leaked.start$user_id);
sit2_rdata_day_leaked.start = rdata_day_leaked.start[match_survey_list[!is.na(match_survey_list)], ];
sit2_rdata_day_leaked.end = rdata_day_leaked.end[match_survey_list[!is.na(match_survey_list)], ];

sit2_rdata_day_leaked.length = length(sit2_rdata_day_leaked.end$num_frn_n);
sit2_ratio_decreased = sum(sit2_rdata_day_leaked.end$num_frn_n < sit2_rdata_day_leaked.start$num_frn_n) / sit2_rdata_day_leaked.length * 100;
sit2_ratio_equal = sum(sit2_rdata_day_leaked.end$num_frn_n == sit2_rdata_day_leaked.start$num_frn_n) / sit2_rdata_day_leaked.length * 100;
sit2_ratio_increased = sum(sit2_rdata_day_leaked.end$num_frn_n > sit2_rdata_day_leaked.start$num_frn_n) / sit2_rdata_day_leaked.length * 100;


#situation3 -> Change Now or Later
user_id.sur_sit3 = rdata_sur$user_id[(rdata_sur$sc7 == 1 & rdata_sur$sc8 == 0)|(rdata_sur$sc7 == 0 | rdata_sur$sc8 == 1)|(rdata_sur$sc7 == 1 | rdata_sur$sc8 == 1) ];
match_survey_list = match(user_id.sur_sit3, rdata_day_leaked.start$user_id);
sit3_rdata_day_leaked.start = rdata_day_leaked.start[match_survey_list[!is.na(match_survey_list)], ];
sit3_rdata_day_leaked.end = rdata_day_leaked.end[match_survey_list[!is.na(match_survey_list)], ];

sit3_rdata_day_leaked.length = length(sit3_rdata_day_leaked.end$num_frn_n);
sit3_ratio_decreased = sum(sit3_rdata_day_leaked.end$num_frn_n < sit3_rdata_day_leaked.start$num_frn_n) / sit3_rdata_day_leaked.length * 100;
sit3_ratio_equal = sum(sit3_rdata_day_leaked.end$num_frn_n == sit3_rdata_day_leaked.start$num_frn_n) / sit3_rdata_day_leaked.length * 100;
sit3_ratio_increased = sum(sit3_rdata_day_leaked.end$num_frn_n > sit3_rdata_day_leaked.start$num_frn_n) / sit3_rdata_day_leaked.length * 100;


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Change on Ratio of Leaked Friend Description by Survey (Protect)
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# We only analyze users which is leaked initially
rdata_day_leaked.start = rdata_day.start[rdata_day.start$num_frn_n > 0,];
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day.end$user_id);
rdata_day_leaked.end = rdata_day.end[match_start_end,];


user_id.sur_sc2.y = rdata_sur$user_id[rdata_sur$sc2 == 1];
match_survey_list = match(user_id.sur_sc2.y, rdata_day_leaked.start$user_id);
rdata_day_leaked.start.sc2.y = rdata_day_leaked.start[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_leaked.end.sc2.y = rdata_day_leaked.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_leaked.sc2.y.total_length = length(rdata_day_leaked.start.sc2.y$user_id);

sc2y_ratio_decreased = sum(rdata_day_leaked.end.sc2.y$num_frn_n < rdata_day_leaked.start.sc2.y$num_frn_n) / rdata_day_leaked.sc2.y.total_length * 100;
sc2y_ratio_equal = sum(rdata_day_leaked.end.sc2.y$num_frn_n == rdata_day_leaked.start.sc2.y$num_frn_n) / rdata_day_leaked.sc2.y.total_length * 100;
sc2y_ratio_increased = sum(rdata_day_leaked.end.sc2.y$num_frn_n > rdata_day_leaked.start.sc2.y$num_frn_n) / rdata_day_leaked.sc2.y.total_length * 100;


user_id.sur_sc2.n = rdata_sur$user_id[rdata_sur$sc2 == 0];
match_survey_list = match(user_id.sur_sc2.n, rdata_day_leaked.start$user_id);
rdata_day_leaked.start.sc2.n = rdata_day_leaked.start[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_leaked.end.sc2.n = rdata_day_leaked.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_leaked.sc2.n.total_length = length(rdata_day_leaked.start.sc2.n$user_id);

sc2n_ratio_decreased = sum(rdata_day_leaked.end.sc2.n$num_frn_n < rdata_day_leaked.start.sc2.n$num_frn_n) / rdata_day_leaked.sc2.n.total_length * 100;
sc2n_ratio_equal = sum(rdata_day_leaked.end.sc2.n$num_frn_n == rdata_day_leaked.start.sc2.n$num_frn_n) / rdata_day_leaked.sc2.n.total_length * 100;
sc2n_ratio_increased = sum(rdata_day_leaked.end.sc2.n$num_frn_n > rdata_day_leaked.start.sc2.n$num_frn_n) / rdata_day_leaked.sc2.n.total_length * 100;


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Closed Friend List vs Different Factors
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# Leaked
rdata_day_leaked.start = rdata_day_full.start[rdata_day_full.start$num_frn_n > 0,];
rdata_day_leaked.start.total_length = length(rdata_day_leaked.start$user_id);
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day_full.end$user_id);
rdata_day_leaked.end = rdata_day_full.end[match_start_end,];
Cf_ratio_leaked.close = sum(rdata_day_leaked.end$frn_ok == 0) / rdata_day_leaked.start.total_length * 100;
Cf_num_leaked.close = sum(rdata_day_leaked.end$frn_ok == 0);

rdata_day_nonleaked.start = rdata_day_full.start[rdata_day_full.start$num_frn_n == 0,];
rdata_day_nonleaked.start.total_length = length(rdata_day_nonleaked.start$user_id);
match_start_end = match(rdata_day_nonleaked.start$user_id, rdata_day_full.end$user_id);
rdata_day_nonleaked.end = rdata_day_full.end[match_start_end,];
Cf_ratio_nonleaked.close = sum(rdata_day_nonleaked.end$frn_ok == 0) / rdata_day_nonleaked.start.total_length * 100;
Cf_num_nonleaked.close = sum(rdata_day_nonleaked.end$frn_ok == 0); 

#Sc2
user_id.sur_sc2.y = rdata_sur$user_id[rdata_sur$sc2 == 1];
match_survey_list = match(user_id.sur_sc2.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc2.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc2.y.total_length = length(rdata_day_full.end.sc2.y$user_id);
Cf_ratio_sc2.y.close = sum(rdata_day_full.end.sc2.y$frn_ok == 0) / rdata_day_full.end.sc2.y.total_length * 100;
Cf_num_sc2.y.close = sum(rdata_day_full.end.sc2.y$frn_ok == 0);

user_id.sur_sc2.n = rdata_sur$user_id[rdata_sur$sc2 == 0];
match_survey_list = match(user_id.sur_sc2.n, rdata_day_full.start$user_id);
rdata_day_full.end.sc2.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc2.n.total_length = length(rdata_day_full.end.sc2.n$user_id);
Cf_ratio_sc2.n.close = sum(rdata_day_full.end.sc2.n$frn_ok == 0) / rdata_day_full.end.sc2.n.total_length * 100;
Cf_num_sc2.n.close = sum(rdata_day_full.end.sc2.n$frn_ok == 0);

#Sc6 / Mc11 or Mc12
user_id.sur_mc11mc12.y = rdata_sur$user_id[rdata_sur$sc6 == 1 | (rdata_sur$mc1_1 == 1 | rdata_sur$mc1_2 == 1 )];
match_survey_list = match(user_id.sur_mc11mc12.y, rdata_day_full.end$user_id);
rdata_day_full.end.mc11mc12.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.mc11mc12.y.total_length = length(rdata_day_full.end.mc11mc12.y $user_id);
Cf_ratio_mc11mc12.y.close = sum(rdata_day_full.end.mc11mc12.y$frn_ok == 0) / rdata_day_full.end.mc11mc12.y.total_length * 100;
Cf_num_mc11mc12.y.close = sum(rdata_day_full.end.mc11mc12.y$frn_ok == 0);


user_id.sur_mc11mc12.n = rdata_sur$user_id[rdata_sur$sc6 == 0 & (rdata_sur$mc1_1 == 0 & rdata_sur$mc1_2 == 0) ];
match_survey_list = match(user_id.sur_mc11mc12.n, rdata_day_full.end$user_id);
rdata_day_full.end.mc11mc12.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.mc11mc12.n.total_length = length(rdata_day_full.end.mc11mc12.n $user_id);
Cf_ratio_mc11mc12.n.close = sum(rdata_day_full.end.mc11mc12.n$frn_ok == 0) / rdata_day_full.end.mc11mc12.n.total_length * 100;
Cf_num_mc11mc12.n.close = sum(rdata_day_full.end.mc11mc12.n$frn_ok == 0);

#Sc6 
user_id.sur_sc6.y = rdata_sur$user_id[rdata_sur$sc6 == 1 ];
match_survey_list = match(user_id.sur_sc6.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc6.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc6.y.total_length = length(rdata_day_full.end.sc6.y $user_id);
Cf_ratio_sc6.y.close = sum(rdata_day_full.end.sc6.y$frn_ok == 0) / rdata_day_full.end.sc6.y.total_length * 100;
Cf_num_sc6.y.close = sum(rdata_day_full.end.sc6.y$frn_ok == 0);

user_id.sur_sc6.n = rdata_sur$user_id[rdata_sur$sc6 == 0 ];
match_survey_list = match(user_id.sur_sc6.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc6.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc6.n.total_length = length(rdata_day_full.end.sc6.n $user_id);
Cf_ratio_sc6.n.close = sum(rdata_day_full.end.sc6.n$frn_ok == 0) / rdata_day_full.end.sc6.n.total_length * 100;
Cf_num_sc6.n.close = sum(rdata_day_full.end.sc6.n$frn_ok == 0);

#Sc7 or Sc8
user_id.sur_sc78.y = rdata_sur$user_id[rdata_sur$sc7 == 1 | rdata_sur$sc8 == 1 ];
match_survey_list = match(user_id.sur_sc78.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc78.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc78.y.total_length = length(rdata_day_full.end.sc78.y $user_id);
Cf_ratio_sc78.y.close = sum(rdata_day_full.end.sc78.y$frn_ok == 0) / rdata_day_full.end.sc78.y.total_length * 100;
Cf_num_sc78.y.close = sum(rdata_day_full.end.sc78.y$frn_ok == 0);

user_id.sur_sc78.n = rdata_sur$user_id[rdata_sur$sc7 == 0 & rdata_sur$sc8 == 0 ];
match_survey_list = match(user_id.sur_sc78.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc78.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc78.n.total_length = length(rdata_day_full.end.sc78.n $user_id);
Cf_ratio_sc78.n.close = sum(rdata_day_full.end.sc78.n$frn_ok == 0) / rdata_day_full.end.sc78.n.total_length * 100;
Cf_num_sc78.n.close = sum(rdata_day_full.end.sc78.n$frn_ok == 0);

#Sc7
user_id.sur_sc7.y = rdata_sur$user_id[rdata_sur$sc7 == 1 ];
match_survey_list = match(user_id.sur_sc7.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc7.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc7.y.total_length = length(rdata_day_full.end.sc7.y $user_id);
Cf_ratio_sc7.y.close = sum(rdata_day_full.end.sc7.y$frn_ok == 0) / rdata_day_full.end.sc7.y.total_length * 100;
Cf_num_sc7.y.close = sum(rdata_day_full.end.sc7.y$frn_ok == 0);

user_id.sur_sc7.n = rdata_sur$user_id[rdata_sur$sc7 == 0];
match_survey_list = match(user_id.sur_sc7.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc7.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc7.n.total_length = length(rdata_day_full.end.sc7.n $user_id);
Cf_ratio_sc7.n.close = sum(rdata_day_full.end.sc7.n$frn_ok == 0) / rdata_day_full.end.sc7.n.total_length * 100;
Cf_num_sc7.n.close = sum(rdata_day_full.end.sc7.n$frn_ok == 0);

#Sc8
user_id.sur_sc8.y = rdata_sur$user_id[rdata_sur$sc8 == 1 ];
match_survey_list = match(user_id.sur_sc8.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc8.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc8.y.total_length = length(rdata_day_full.end.sc8.y $user_id);
Cf_ratio_sc8.y.close = sum(rdata_day_full.end.sc8.y$frn_ok == 0) / rdata_day_full.end.sc8.y.total_length * 100;
Cf_num_sc8.y.close = sum(rdata_day_full.end.sc8.y$frn_ok == 0);

user_id.sur_sc8.n = rdata_sur$user_id[rdata_sur$sc8 == 0];
match_survey_list = match(user_id.sur_sc8.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc8.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc8.n.total_length = length(rdata_day_full.end.sc8.n $user_id);
Cf_ratio_sc8.n.close = sum(rdata_day_full.end.sc8.n$frn_ok == 0) / rdata_day_full.end.sc8.n.total_length * 100;
Cf_num_sc8.n.close = sum(rdata_day_full.end.sc8.n$frn_ok == 0);


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Closed Friend List vs Sc6 Sub
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::



#Sc6 / Mc11 or Mc12
user_id.sur_sc6162.y = rdata_sur$user_id[(rdata_sur$mc1_1 == 1 | rdata_sur$mc1_2 == 1 )];
match_survey_list = match(user_id.sur_sc6162.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc6162.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc6162.y.total_length = length(rdata_day_full.end.sc6162.y$user_id);
Cf_ratio_sc6162.y.close = sum(rdata_day_full.end.sc6162.y$frn_ok == 0) / rdata_day_full.end.sc6162.y.total_length * 100;
Cf_num_sc6162.y.close = sum(rdata_day_full.end.sc6162.y$frn_ok == 0);

user_id.sur_sc6162.n = rdata_sur$user_id[(rdata_sur$mc1_1 == 0 & rdata_sur$mc1_2 == 0 )];
match_survey_list = match(user_id.sur_sc6162.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc6162.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc6162.n.total_length = length(rdata_day_full.end.sc6162.n$user_id);
Cf_ratio_sc6162.n.close = sum(rdata_day_full.end.sc6162.n$frn_ok == 0) / rdata_day_full.end.sc6162.n.total_length * 100;
Cf_num_sc6162.n.close = sum(rdata_day_full.end.sc6162.n$frn_ok == 0);


#Sc6 / Mc13
user_id.sur_sc63.y = rdata_sur$user_id[(rdata_sur$mc1_3 == 1)];
match_survey_list = match(user_id.sur_sc63.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc63.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc63.y.total_length = length(rdata_day_full.end.sc63.y$user_id);
Cf_ratio_sc63.y.close = sum(rdata_day_full.end.sc63.y$frn_ok == 0) / rdata_day_full.end.sc63.y.total_length * 100;
Cf_num_sc63.y.close = sum(rdata_day_full.end.sc63.y$frn_ok == 0);

user_id.sur_sc63.n = rdata_sur$user_id[(rdata_sur$mc1_3 == 0)];
match_survey_list = match(user_id.sur_sc63.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc63.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc63.n.total_length = length(rdata_day_full.end.sc63.n$user_id);
Cf_ratio_sc63.n.close = sum(rdata_day_full.end.sc63.n$frn_ok == 0) / rdata_day_full.end.sc63.n.total_length * 100;
Cf_num_sc63.n.close = sum(rdata_day_full.end.sc63.n$frn_ok == 0);


#Sc6 / Mc14
user_id.sur_sc64.y = rdata_sur$user_id[(rdata_sur$mc1_4 == 1)];
match_survey_list = match(user_id.sur_sc64.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc64.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc64.y.total_length = length(rdata_day_full.end.sc64.y$user_id);
Cf_ratio_sc64.y.close = sum(rdata_day_full.end.sc64.y$frn_ok == 0) / rdata_day_full.end.sc64.y.total_length * 100;
Cf_num_sc64.y.close = sum(rdata_day_full.end.sc64.y$frn_ok == 0);

user_id.sur_sc64.n = rdata_sur$user_id[(rdata_sur$mc1_4 == 0)];
match_survey_list = match(user_id.sur_sc64.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc64.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc64.n.total_length = length(rdata_day_full.end.sc64.n$user_id);
Cf_ratio_sc64.n.close = sum(rdata_day_full.end.sc64.n$frn_ok == 0) / rdata_day_full.end.sc64.n.total_length * 100;
Cf_num_sc64.n.close = sum(rdata_day_full.end.sc64.n$frn_ok == 0);


#Sc6 / Mc15
user_id.sur_sc65.y = rdata_sur$user_id[(rdata_sur$mc1_5 == 1)];
match_survey_list = match(user_id.sur_sc65.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc65.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc65.y.total_length = length(rdata_day_full.end.sc65.y$user_id);
Cf_ratio_sc65.y.close = sum(rdata_day_full.end.sc65.y$frn_ok == 0) / rdata_day_full.end.sc65.y.total_length * 100;
Cf_num_sc65.y.close = sum(rdata_day_full.end.sc65.y$frn_ok == 0);

user_id.sur_sc65.n = rdata_sur$user_id[(rdata_sur$mc1_5 == 0)];
match_survey_list = match(user_id.sur_sc65.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc65.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc65.n.total_length = length(rdata_day_full.end.sc65.n$user_id);
Cf_ratio_sc65.n.close = sum(rdata_day_full.end.sc65.n$frn_ok == 0) / rdata_day_full.end.sc65.n.total_length * 100;
Cf_num_sc65.n.close = sum(rdata_day_full.end.sc65.n$frn_ok == 0);

#Sc6 / Mc16
user_id.sur_sc66.y = rdata_sur$user_id[(rdata_sur$mc1_6 == 1)];
match_survey_list = match(user_id.sur_sc66.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc66.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc66.y.total_length = length(rdata_day_full.end.sc66.y$user_id);
Cf_ratio_sc66.y.close = sum(rdata_day_full.end.sc66.y$frn_ok == 0) / rdata_day_full.end.sc66.y.total_length * 100;
Cf_num_sc66.y.close = sum(rdata_day_full.end.sc66.y$frn_ok == 0);

user_id.sur_sc66.n = rdata_sur$user_id[(rdata_sur$mc1_6 == 0)];
match_survey_list = match(user_id.sur_sc66.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc66.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc66.n.total_length = length(rdata_day_full.end.sc66.n$user_id);
Cf_ratio_sc66.n.close = sum(rdata_day_full.end.sc66.n$frn_ok == 0) / rdata_day_full.end.sc66.n.total_length * 100;
Cf_num_sc66.n.close = sum(rdata_day_full.end.sc66.n$frn_ok == 0);

#Sc6 / Mc17
user_id.sur_sc67.y = rdata_sur$user_id[(rdata_sur$mc1_7 == 1)];
match_survey_list = match(user_id.sur_sc67.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc67.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc67.y.total_length = length(rdata_day_full.end.sc67.y$user_id);
Cf_ratio_sc67.y.close = sum(rdata_day_full.end.sc67.y$frn_ok == 0) / rdata_day_full.end.sc67.y.total_length * 100;
Cf_num_sc67.y.close = sum(rdata_day_full.end.sc67.y$frn_ok == 0);

user_id.sur_sc67.n = rdata_sur$user_id[(rdata_sur$mc1_7 == 0)];
match_survey_list = match(user_id.sur_sc67.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc67.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc67.n.total_length = length(rdata_day_full.end.sc67.n$user_id);
Cf_ratio_sc67.n.close = sum(rdata_day_full.end.sc67.n$frn_ok == 0) / rdata_day_full.end.sc67.n.total_length * 100;
Cf_num_sc67.n.close = sum(rdata_day_full.end.sc67.n$frn_ok == 0);

#Sc6 / Mc18
user_id.sur_sc68.y = rdata_sur$user_id[(rdata_sur$mc1_8 == 1)];
match_survey_list = match(user_id.sur_sc68.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc68.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc68.y.total_length = length(rdata_day_full.end.sc68.y$user_id);
Cf_ratio_sc68.y.close = sum(rdata_day_full.end.sc68.y$frn_ok == 0) / rdata_day_full.end.sc68.y.total_length * 100;
Cf_num_sc68.y.close = sum(rdata_day_full.end.sc68.y$frn_ok == 0);

user_id.sur_sc68.n = rdata_sur$user_id[(rdata_sur$mc1_8 == 0)];
match_survey_list = match(user_id.sur_sc68.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc68.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc68.n.total_length = length(rdata_day_full.end.sc68.n$user_id);
Cf_ratio_sc68.n.close = sum(rdata_day_full.end.sc68.n$frn_ok == 0) / rdata_day_full.end.sc68.n.total_length * 100;
Cf_num_sc68.n.close = sum(rdata_day_full.end.sc68.n$frn_ok == 0);

#Sc6 / Mc19
user_id.sur_sc69.y = rdata_sur$user_id[(rdata_sur$mc1_9 == 1)];
match_survey_list = match(user_id.sur_sc69.y, rdata_day_full.end$user_id);
rdata_day_full.end.sc69.y = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc69.y.total_length = length(rdata_day_full.end.sc69.y$user_id);
Cf_ratio_sc69.y.close = sum(rdata_day_full.end.sc69.y$frn_ok == 0) / rdata_day_full.end.sc69.y.total_length * 100;
Cf_num_sc69.y.close = sum(rdata_day_full.end.sc69.y$frn_ok == 0);

user_id.sur_sc69.n = rdata_sur$user_id[(rdata_sur$mc1_9 == 0)];
match_survey_list = match(user_id.sur_sc69.n, rdata_day_full.end$user_id);
rdata_day_full.end.sc69.n = rdata_day_full.end[match_survey_list[!is.na(match_survey_list)], ];
rdata_day_full.end.sc69.n.total_length = length(rdata_day_full.end.sc69.n$user_id);
Cf_ratio_sc69.n.close = sum(rdata_day_full.end.sc69.n$frn_ok == 0) / rdata_day_full.end.sc69.n.total_length * 100;
Cf_num_sc69.n.close = sum(rdata_day_full.end.sc69.n$frn_ok == 0);


#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# DRAW -----------------------------------------------------------------------------------------------------------------------------------
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Closed Friend List vs Sc6 Sub
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

custom.mixed = c(Cf_ratio_sc6162.y.close, Cf_ratio_sc6162.n.close, 
				 Cf_ratio_sc63.y.close, Cf_ratio_sc63.n.close, 
				 Cf_ratio_sc64.y.close, Cf_ratio_sc64.n.close, 
				 Cf_ratio_sc65.y.close, Cf_ratio_sc65.n.close, 
				 Cf_ratio_sc66.y.close, Cf_ratio_sc66.n.close, 
				 Cf_ratio_sc67.y.close, Cf_ratio_sc67.n.close, 
				 Cf_ratio_sc68.y.close, Cf_ratio_sc68.n.close, 
				 Cf_ratio_sc69.y.close, Cf_ratio_sc69.n.close 
				 );

custom.mixed2 = c(Cf_num_sc6162.y.close, Cf_num_sc6162.n.close, 
				 Cf_num_sc63.y.close, Cf_num_sc63.n.close, 
				 Cf_num_sc64.y.close, Cf_num_sc64.n.close, 
				 Cf_num_sc65.y.close, Cf_num_sc65.n.close, 
				 Cf_num_sc66.y.close, Cf_num_sc66.n.close, 
				 Cf_num_sc67.y.close, Cf_num_sc67.n.close, 
				 Cf_num_sc68.y.close, Cf_num_sc68.n.close, 
				 Cf_num_sc69.y.close, Cf_num_sc69.n.close
				 );
				 

				 
custom.matrix = matrix(custom.mixed, byrow=F, nrow=2);
custom.matrix2 = matrix(custom.mixed2, byrow=F, nrow=2);

custom.total1 = paste("(",rdata_day_full.end.sc6162.y.total_length, ",", rdata_day_full.end.sc6162.n.total_length,")", sep="");
custom.total2 = paste("(",rdata_day_full.end.sc63.y.total_length, ",", rdata_day_full.end.sc63.n.total_length,")", sep="");
custom.total3 = paste("(",rdata_day_full.end.sc64.y.total_length, ",", rdata_day_full.end.sc64.n.total_length,")", sep="");
custom.total4 = paste("(",rdata_day_full.end.sc65.y.total_length, ",", rdata_day_full.end.sc65.n.total_length,")", sep="");
custom.total5 = paste("(",rdata_day_full.end.sc66.y.total_length, ",", rdata_day_full.end.sc66.n.total_length,")", sep="");
custom.total6 = paste("(",rdata_day_full.end.sc67.y.total_length, ",", rdata_day_full.end.sc67.n.total_length,")", sep="");
custom.total7 = paste("(",rdata_day_full.end.sc68.y.total_length, ",", rdata_day_full.end.sc68.n.total_length,")", sep="");
custom.total8 = paste("(",rdata_day_full.end.sc69.y.total_length, ",", rdata_day_full.end.sc69.n.total_length,")", sep="");

if(0){
dimnames(custom.matrix) = list(c("", ""), c(
							paste("Leaked", custom.total1, sep=""),
							paste("Sc2", custom.total2, sep=""),
							paste("Sc6162", custom.total3, sep=""),
							paste("Sc6", custom.total4, sep=""),
							paste("Sc78", custom.total5, sep=""),
							paste("Sc7", custom.total6, sep=""),
							paste("Sc8",custom.total7, sep="")
							));
}

dimnames(custom.matrix) = list(c("", ""), c(							
							"Name", 
							"Gender", 
							"Age", 
							"School", 
							"WorkP",
							"JobT", 
							"CellN",
							"LiveP"
							));							
							

custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.1);
custom.col = c("green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Closed Friend List vs Sc6 Sub", "", sep="");
custom.xlab = "";
custom.ylab = "Ratio (%)";
custom.legend.x = 16;
custom.legend.y = custom.ylim[2];
custom.legend = c("True", "False");

custom.bar.cex = 0.6;
#mp[1,] + mp[2,]) /2 + 1
my.sim.start_draw("8. Ratio_Close_Sc6", main=T);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab, xaxs = "i");
	text(mp, custom.matrix+2,  labels=sprintf("%.1f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	text(mp, custom.matrix-0.1,  labels=sprintf("(%d)", custom.matrix2), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	text(apply(mp, 2, mean), -8, adj=c(0.5, 0.5), labels=c(custom.total1,custom.total2,custom.total3, custom.total4,custom.total5,custom.total6,custom.total7,custom.total8), srt = 0,  xpd = T, cex=0.8);
	legend( x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Closed Friend List vs Different Factors
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(Cf_ratio_leaked.close, Cf_ratio_nonleaked.close, 
				 Cf_ratio_sc2.y.close, Cf_ratio_sc2.n.close, 
				 Cf_ratio_mc11mc12.y.close, Cf_ratio_mc11mc12.n.close,
				 Cf_ratio_sc6.y.close, Cf_ratio_sc6.n.close,
				 Cf_ratio_sc78.y.close, Cf_ratio_sc78.n.close, 
				 Cf_ratio_sc7.y.close, Cf_ratio_sc7.n.close , 
				 Cf_ratio_sc8.y.close, Cf_ratio_sc8.n.close 				 
				 );
				 
custom.mixed2 = c(Cf_num_leaked.close, Cf_num_nonleaked.close, 
				 Cf_num_sc2.y.close, Cf_num_sc2.n.close, 
				 Cf_num_mc11mc12.y.close, Cf_num_mc11mc12.n.close,
				 Cf_num_sc6.y.close, Cf_num_sc6.n.close,
				 Cf_num_sc78.y.close, Cf_num_sc78.n.close, 
				 Cf_num_sc7.y.close, Cf_num_sc7.n.close , 
				 Cf_num_sc8.y.close, Cf_num_sc8.n.close 				 
				 );
				 
custom.matrix = matrix(custom.mixed, byrow=F, nrow=2);
custom.matrix2 = matrix(custom.mixed2, byrow=F, nrow=2);

custom.total1 = paste("(",rdata_day_leaked.start.total_length, ",", rdata_day_nonleaked.start.total_length,")", sep="");
custom.total2 = paste("(", rdata_day_full.end.sc2.y.total_length, ",", rdata_day_full.end.sc2.n.total_length ,")", sep="");
custom.total3 = paste("(", rdata_day_full.end.mc11mc12.y.total_length, ",", rdata_day_full.end.mc11mc12.n.total_length ,")", sep="");
custom.total4 = paste("(", rdata_day_full.end.sc6.y.total_length, ",", rdata_day_full.end.sc6.n.total_length ,")", sep="");
custom.total5 = paste("(", rdata_day_full.end.sc78.y.total_length, ",", rdata_day_full.end.sc78.n.total_length ,")", sep="");
custom.total6 = paste("(", rdata_day_full.end.sc7.y.total_length, ",", rdata_day_full.end.sc7.n.total_length ,")", sep="");
custom.total7 = paste("(", rdata_day_full.end.sc8.y.total_length, ",", rdata_day_full.end.sc8.n.total_length ,")", sep="");

if(0){
dimnames(custom.matrix) = list(c("", ""), c(
							paste("Leaked", custom.total1, sep=""),
							paste("Sc2", custom.total2, sep=""),
							paste("Sc6162", custom.total3, sep=""),
							paste("Sc6", custom.total4, sep=""),
							paste("Sc78", custom.total5, sep=""),
							paste("Sc7", custom.total6, sep=""),
							paste("Sc8",custom.total7, sep="")
							));
}

dimnames(custom.matrix) = list(c("", ""), c(							
							"Leaked", 
							"Sc2", 
							"Sc6162", 
							"Sc6", 
							"Sc78",
							"Sc7", 
							"Sc8"
							));							
							

custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.1);
custom.col = c("green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Closed Friend List vs Different Factors", "", sep="");
custom.xlab = "";
custom.ylab = "Ratio (%)";
custom.legend.x = 16;
custom.legend.y = custom.ylim[2];
custom.legend = c("True", "False");

custom.bar.cex = 0.6;
#mp[1,] + mp[2,]) /2 + 1
my.sim.start_draw("7. Ratio_Close_Factors", main=T);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab, xaxs = "i");
	text(mp, custom.matrix+0.3,  labels=sprintf("%.1f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	text(mp, custom.matrix-0.1,  labels=sprintf("(%d)", custom.matrix2), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	text(apply(mp, 2, mean), -2, adj=c(0.5, 0.5), labels=c(custom.total1,custom.total2,custom.total3, custom.total4,custom.total5,custom.total6,custom.total7), srt = 0,  xpd = T, cex=0.8);
	legend( x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Change on Ratio of Leaked Friend Description by Survey (Protect)
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(sc2y_ratio_decreased, sc2y_ratio_equal, sc2y_ratio_increased, sc2n_ratio_decreased, sc2n_ratio_equal, sc2n_ratio_increased);
custom.matrix = matrix(custom.mixed, byrow=T, nrow=2);
dimnames(custom.matrix) = list(c("", ""), c("Decreased", "Not Changed", "Increased"));
custom.total1 = rdata_day_leaked.sc2.y.total_length;
custom.total1 = paste(" (",custom.total1,")", sep="");
custom.total2 = rdata_day_leaked.sc2.n.total_length;
custom.total2 = paste(" (",custom.total2,")", sep="");

custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("green", "red","green", "red", "green", "red" );
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Change on Ratio of Leaked Friend Description by Survey (Protect)", "", sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 5;
custom.legend.y = custom.ylim[2];
custom.legend = c(paste("Protect",custom.total1, sep=""), paste("Not Protect", custom.total2, sep=""));

custom.bar.cex = 0.8;

my.sim.start_draw("6. Ratio_Leaked_Des_Change_Sc2", main=T);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.matrix - 2, labels=sprintf("%.2f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();




# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Change on Ratio of Leaked Friend Description by Survey
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(sit1_ratio_decreased, sit1_ratio_equal, sit1_ratio_increased,  sit2_ratio_decreased, sit2_ratio_equal, sit2_ratio_increased, sit3_ratio_decreased, sit3_ratio_equal, sit3_ratio_increased);
custom.matrix = matrix(custom.mixed, byrow=T, nrow=3);
dimnames(custom.matrix) = list(c("", "",""), c("Decreased", "Not Changed", "Increased"));
custom.total1 = sit1_rdata_day_leaked.length;
custom.total1 = paste(" (",custom.total1,")", sep="");
custom.total2 = sit2_rdata_day_leaked.length;
custom.total2 = paste(" (",custom.total2,")", sep="");
custom.total3 = sit3_rdata_day_leaked.length;
custom.total3 = paste(" (",custom.total3,")", sep="");

custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("green", "red", "blue",  "green", "red", "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Change on Ratio of Leaked Friend Description by Survey", "", sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 3.8;
custom.legend.y = custom.ylim[2];
custom.legend = c(paste("Not Change",custom.total1, sep=""), paste("Change Later", custom.total2, sep=""), paste("Change Now or Later", custom.total3, sep=""));

custom.bar.cex = 0.8;

my.sim.start_draw("5. Ratio_Leaked_Des_Change_Sc78", main=T);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.matrix - 2, labels=sprintf("%.2f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Change on Ratio of Leaked Real Name
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ratio_decreased.n, ratio_equal.n, ratio_increased.n);
#custom.matrix = matrix(custom.mixed, byrow=T, nrow=2);
names(custom.mixed) = c("Decreased", "Not Changed", "Increased");
custom.total = rdata_day_leaked.length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("green", "red",  "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Change on Ratio of Leaked Real Name", custom.total, sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 6;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Name", "Full Name");

custom.bar.cex = 1.0;

my.sim.start_draw("4. Ratio_Leaked_Name_Change", main=T);
	mp = barplot(custom.mixed, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.mixed - 2, labels=sprintf("%.2f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Change on Ratio of Leaked Friend Description
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ratio_decreased, ratio_equal, ratio_increased);
names(custom.mixed) = c("Decreased", "Not Changed", "Increased");
custom.total = rdata_day_leaked.length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("blue", "green", "red");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Change on Ratio of Leaked Friend Description", custom.total, sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 4;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Day", "Last Day");

custom.bar.cex = 1.0;

my.sim.start_draw("3. Ratio_Frn_Leaked_Des_Change", main=T);
	mp = barplot(custom.mixed, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.mixed - 2, labels=sprintf("%.2f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1.3);	
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Ratio of Leaked and non-leaked Users based on Survey Result (Protect)
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked_sc2.y, non_leaked_sc2.y, leaked_sc2.n, non_leaked_sc2.n);
custom.matrix = matrix(custom.mixed, byrow=T, nrow=2);
dimnames(custom.matrix) = list(c("", ""), c("Full Name / First Name Leaked", "Non-Leaked"));
custom.total = leaked.start.total_length;
custom.total = paste(" (",custom.total,")", sep="");

custom.total1 = leaked_sc2.y.total_length;
custom.total1 = paste(" (",custom.total1,")", sep="");
custom.total2 = leaked_sc2.n.total_length;
custom.total2 = paste(" (",custom.total2,")", sep="");

custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("green", "red",  "green", "red");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Leaked and non-leaked Users vs Survey Result", "", sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 3.0;
custom.legend.y = custom.ylim[2];
custom.legend = c(paste("Protected", custom.total1, sep=""), paste("Non-Protected", custom.total2, sep=""));

custom.bar.cex = 1.0;

my.sim.start_draw("2. Ratio_Leaked_NonLeaked_Sc2", main=T);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.matrix - 2, labels=sprintf("%.2f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();




# :::::::::::::::::::::::::::::::::::::::::
# Ratio of Leaked and non-leaked Users
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked.start, non_leaked.start, leaked.end, non_leaked.end);
custom.matrix = matrix(custom.mixed, byrow=T, nrow=2);
dimnames(custom.matrix) = list(c("", ""), c("Full Name / First Name Leaked", "Non-Leaked"));
custom.total = leaked.start.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("red",  "green", "red", "green");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Leaked and non-leaked Users", custom.total, sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 4;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Day", "Last Day");

custom.bar.cex = 1.0;

my.sim.start_draw("1. Ratio_Leaked_NonLeaked", main=T);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.matrix - 2, labels=sprintf("%.2f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1.3);	
my.sim.end_draw();

if(0){

# :::::::::::::::::::::::::::::::::::::::::
# Ratio of Leaked and non-leaked Users (Start)
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked.start, non_leaked.start);
names(custom.mixed) = c("Full Name / First Name Leaked", "Non-Leaked");
custom.total = leaked.start.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("red",  "green", "red", "green");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Leaked and non-leaked Users", custom.total, sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 4;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Day", "Last Day");

custom.bar.cex = 1.0;

my.sim.start_draw("Ratio_Leaked_NonLeaked_Start", main=T);
	mp = barplot(custom.mixed, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.mixed - 2, labels=sprintf("%.2f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1.3);	
my.sim.end_draw();

# :::::::::::::::::::::::::::::::::::::::::
# Ratio of Leaked and non-leaked Users (End)
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked.end, non_leaked.end);
names(custom.mixed) = c("Full Name / First Name Leaked", "Non-Leaked");
custom.total = leaked.end.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("red",  "green", "red", "green");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Leaked and non-leaked Users", custom.total, sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 4;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Day", "Last Day");

custom.bar.cex = 1.0;

my.sim.start_draw("Ratio_Leaked_NonLeaked_End", main=T);
	mp = barplot(custom.mixed, col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	text(mp, custom.mixed - 2, labels=sprintf("%.2f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1.3);	
my.sim.end_draw();

}