rm(list=ls(all=TRUE));
source("R-lib/common.R");
source("R-lib/my.legend.R");
source("R-lib/my.sim.IO.R");
source("R-lib/my.fig.R");
source("R-lib/my.sim.R");

thres_num_frn = 0;
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

my.sim.output.path = "done/";


# Only select start and end day
rdata_day.start = rdata[1,];
rdata_day.end = rdata[1,];

rdata_day.start$num_day = 999;
rdata_day.end$num_day = 999;

tmp =  sapply(max_id, function(y) {
	max_day = max(rdata$num_day[rdata$user_id == as.character(y)]);
	if(rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){
		rdata_day.start <<- merge(rdata_day.start, rdata[rdata$user_id == as.character(y) & rdata$num_day == 0,], all=T);
		rdata_day.end <<- merge(rdata_day.end, rdata[rdata$user_id == as.character(y) & rdata$num_day == max_day ,], all=T);
	}
});

rdata_day.start = rdata_day.start[rdata_day.start$num_day != 999,];
rdata_day.end = rdata_day.end[rdata_day.end$num_day != 999,];


# Only select start and end day (Needs All Opened)
rdata_day.open.start = rdata[1,];
rdata_day.open.end = rdata[1,];

rdata_day.open.start$num_day = 999;
rdata_day.open.end$num_day = 999;

tmp =  sapply(max_id, function(y) {
	max_day = max(rdata$num_day[rdata$user_id == as.character(y)]);
	if(rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == 0] != 0 & rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == max_day] != 0 & rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){
		rdata_day.open.start <<- merge(rdata_day.open.start, rdata[rdata$user_id == as.character(y) & rdata$num_day == 0,], all=T);
		rdata_day.open.end <<- merge(rdata_day.open.end, rdata[rdata$user_id == as.character(y) & rdata$num_day == max_day ,], all=T);
	}
});

rdata_day.open.start = rdata_day.open.start[rdata_day.open.start$num_day != 999,];
rdata_day.open.end = rdata_day.open.end[rdata_day.open.end$num_day != 999,];

	

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



#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Change on Ratio of Leaked Friend Description
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# We only analyze users which is leaked initially
rdata_day_leaked.start = rdata_day.open.start[rdata_day.open.start$num_frn_n > 0,];
match_start_end = match(rdata_day_leaked.start$user_id, rdata_day.open.end$user_id);
rdata_day_leaked.end = rdata_day.open.end[match_start_end,];

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
							paste("Sc8",custom.total7, sep=""),
							paste("Sc9",custom.total8, sep="")

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
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.col = c("red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green", "red","green");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Ratio of Closed Friend List vs Sc6 Sub", "", sep="");
custom.xlab = "";
custom.ylab = "Ratio (%)";
custom.legend.x = 21;
custom.legend.y = custom.ylim[2];
custom.legend = c("Leakage Found", "Leakage Not Found");

custom.bar.cex = 0.8;
#mp[1,] + mp[2,]) /2 + 1
my.sim.start_draw("7. Ratio_Close_Sc6", main=F);
	mp = barplot(custom.matrix, col=custom.col, beside=T, ylim=custom.ylim,   xlab=custom.xlab, ylab=custom.ylab, xaxs = "i");
	text(mp, custom.matrix- 0.3,  labels=sprintf("%.0f%%", custom.matrix), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	text(mp, custom.matrix-0.1,  labels=sprintf("(%d)", custom.matrix2), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	text(apply(mp, 2, mean), -8, adj=c(0.5, 0.5), labels=c(custom.total1,custom.total2,custom.total3, custom.total4,custom.total5,custom.total6,custom.total7,custom.total8), srt = 0,  xpd = T, cex=0.8);
	legend( x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=1);	
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Change on Ratio of Leaked Friend Description
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ratio_decreased, ratio_equal, ratio_increased);
names(custom.mixed) = c(
	paste("Decreased", " (",sprintf("%.1f%%",ratio_decreased),")", sep=""), 
	paste("Not Changed", " (",sprintf("%.1f%%",ratio_equal),")", sep=""),
	paste("Increased", " (",sprintf("%.1f%%",ratio_increased),")", sep="")
	);
custom.total = rdata_day_leaked.length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("#00009c", "#b5bae6", "#5c5bc8");
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

my.sim.start_draw("6. Ratio_Leaked_Frn_Des_Pie", main=F);
	mp = pie(custom.mixed, col=custom.col,  ylim=custom.ylim, cex=custom.bar.cex, border=c(0, 0, 0));
#	text(mp, custom.mixed - 2, labels=sprintf("%.2f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Change on Ratio of Leaked Real Name
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ratio_decreased.n, ratio_equal.n, ratio_increased.n);
#custom.matrix = matrix(custom.mixed, byrow=T, nrow=2);
names(custom.mixed) = c(
	paste("Decreased", " (",sprintf("%.1f%%",ratio_decreased.n),")", sep=""), 
	paste("Not Changed", " (",sprintf("%.1f%%",ratio_equal.n),")", sep=""),
	paste("Increased", " (",sprintf("%.1f%%",ratio_increased.n),")", sep="")
	);
custom.total = rdata_day_leaked.length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = 0;
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2 );
custom.col = c("#6b309c", "#d4c3e6", "#a984c6");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.main = paste("Change on Ratio of Leaked Real Name", custom.total, sep="");
custom.xlab = "Situation";
custom.ylab = "Ratio (%)";
custom.legend.x = 6;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Name", "Full Name");

custom.bar.cex = 1;

my.sim.start_draw("5. Ratio_Leaked_Name_Pie", main=F);
	mp = pie(custom.mixed, col=custom.col,   ylim=custom.ylim, cex=custom.bar.cex, border=c(0,0,0));
#	text(mp, custom.mixed, labels=sprintf("%.2f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);	
my.sim.end_draw();





