rm(list=ls(all=TRUE));
source("R-lib/common.R");
source("R-lib/my.legend.R");
source("R-lib/my.sim.IO.R");
source("R-lib/my.fig.R");
source("R-lib/my.sim.R");

my.sim.read("data");
rdata$user_id = as.character(rdata$user_id);
rdata$raw_date = as.character(rdata$raw_date);

my.sim.read2("data_sur");
rdata_sur$user_id = as.character(rdata_sur$user_id);

bcol.sky = topo.colors(100);
bcol.red = sort(grep("red",colors()));



id_list = unique(rdata$user_id);
user_list = data.frame(id_list, rep(0, length(id_list)));
names(user_list) = c("user_id", "max_day");

# calcuate max day of each user
if(0){
rdata_diff = apply(rdata, 1, function(x) {
    if(length(rdata[rdata$user_id==as.character(x[1]) & rdata$num_day==(as.integer(x[3]) + 1),1]) > 0){
	#	print(paste(x[1], x[3],"-", as.integer(x[3]) + 1, "OK!"));
		user_list$max_day[user_list$user_id == as.character(x[1])] <<- user_list$max_day[user_list$user_id == as.character(x[1])] + 1;
	}else{
	#	print(paste(x[1], x[3],"-", as.integer(x[3]) + 1, "NO.."));
	}
	return(x);
})
}

# divide data by day
day_range = unique( rdata$num_day)
day_range = c(0:15);
max_id = rdata$user_id[rdata$num_day==max(day_range)];

if(0){
max_idX = c();
tmp = sapply(max_id, function(y) {
		max_idX <<- c(max_idX, sum(rdata$num_frn[rdata$user_id == y & rdata$num_day %in% day_range ] > 0) == length(day_range));
});

max_id = max_id[max_idX];
rdata_same = rdata[rdata$user_id %in% max_id ,]

}

rdata_same = rdata[1,];
rdata_same$num_day = 999;

tmp =  sapply(max_id, function(y) {
#	rdata[rdata$user_id == as.character(y),]
	rdata_same <<- merge(rdata_same, rdata[rdata$user_id == as.character(y) & sum(rdata$frn_ok[rdata$user_id==as.character(y)] > 0) == length(rdata$frn_ok[rdata$user_id==as.character(y)] > 0),], all=T);
});

rdata_same = rdata_same[rdata_same$num_day != 999,];

rdata_day = lapply(day_range, function(y) rdata_same[rdata_same$num_day == y ,])


#:::::::::::::::::::::::::::::::::::::::::::::::::

num_frn_n.time  = c();
num_frn_n2.time  = c();
num_frn_n3.time  = c();

num_n2.time  = c();
num_n3.time  = c();

selected_id = 3;
fin = sapply(day_range, function(y) {
		num_frn_n.time <<- c(num_frn_n.time, mean(rdata_day[[y+1]]$num_frn_n[selected_id]));
		num_frn_n2.time <<- c(num_frn_n2.time, mean(rdata_day[[y+1]]$num_frn_n2[selected_id]));
		num_frn_n3.time <<- c(num_frn_n3.time, mean(rdata_day[[y+1]]$num_frn_n3[selected_id]));

		num_n2.time <<- c(num_n2.time, mean(rdata_day[[y+1]]$num_n2[selected_id]));
		num_n3.time <<- c(num_n3.time, mean(rdata_day[[y+1]]$num_n3[selected_id]));
})

fin = sapply(day_range, function(y) {
	if(y < max(day_range)){
		# Number of Name-Exposing Friends Over Time
		num_frn_n.time <<- c(num_frn_n.time, mean(rdata_day[[y+1]]$num_frn_n));
		num_frn_n2.time <<- c(num_frn_n2.time, mean(rdata_day[[y+1]]$num_frn_n2));
		num_frn_n3.time <<- c(num_frn_n3.time, mean(rdata_day[[y+1]]$num_frn_n3));

		# Number of Exposed Names Over Time
		num_n2.time <<- c(num_n2.time, mean(rdata_day[[y+1]]$num_n2));
		num_n3.time <<- c(num_n3.time, mean(rdata_day[[y+1]]$num_n3));
	}
})

#:::::::::::::::::::::::::::::::::::::::::::::::::


ins_frn_des.time = c();
des_frn_des.time = c();

ins_frn_n.time = c();
des_frn_n.time = c();

ins_num_n2.time = c();
des_num_n2.time = c();

ins_num_n3.time = c();
des_num_n3.time = c();

ins_num_tag.time = c();
des_num_tag.time = c();

ins_num_nick.time = c();
des_num_nick.time = c();

ins_num_frn.time = c();
des_num_frn.time = c();


des_frn_n.all = rep(0, length(rdata_day[[1]]$num_frn_des));
#:::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Modified Over Time
#:::::::::::::::::::::::::::::::::::::::
fin = sapply(day_range, function(y) {
	if(y < max(day_range)){
		if(y > 0 ){
			# Ratio of Users' Number of  Friend Descriptions Change Over Time
			ins_frn_des = sum(rdata_day[[y+1]]$num_frn_des > (rdata_day[[y]]$num_frn_des)) / length(rdata_day[[y]]$num_frn_des) * 100;
			des_frn_des = sum(rdata_day[[y+1]]$num_frn_des < (rdata_day[[y]]$num_frn_des)) / length(rdata_day[[y]]$num_frn_des) * 100;
			ins_frn_des.time <<- c(ins_frn_des.time, ins_frn_des);
			des_frn_des.time <<- c(des_frn_des.time, des_frn_des);	

			# Ratio of User's  Number of Name-Exposing Friends Change Over Time
			ins_frn_n = sum(rdata_day[[y+1]]$num_frn_n > (rdata_day[[y]]$num_frn_n)) / length(rdata_day[[y]]$num_frn_n) * 100;
			des_frn_n = sum(rdata_day[[y+1]]$num_frn_n < (rdata_day[[y]]$num_frn_n)) / length(rdata_day[[y]]$num_frn_n) * 100;
			ins_frn_n.time <<- c(ins_frn_n.time, ins_frn_n);
			des_frn_n.time <<- c(des_frn_n.time, des_frn_n);				
			
			# Ratio of User's  Exposed Names Change Over Time
			ins_num_n2 = sum(rdata_day[[y+1]]$num_n2 > (rdata_day[[y]]$num_n2)) / length(rdata_day[[y]]$num_n2) * 100;
			des_num_n2 = sum(rdata_day[[y+1]]$num_n2 < (rdata_day[[y]]$num_n2)) / length(rdata_day[[y]]$num_n2) * 100;
			ins_num_n2.time <<- c(ins_num_n2.time, ins_num_n2);
			des_num_n2.time <<- c(des_num_n2.time, des_num_n2);				
	
			ins_num_n3 = sum(rdata_day[[y+1]]$num_n3 > (rdata_day[[y]]$num_n3)) / length(rdata_day[[y]]$num_n3) * 100;
			des_num_n3 = sum(rdata_day[[y+1]]$num_n3 < (rdata_day[[y]]$num_n3)) / length(rdata_day[[y]]$num_n3) * 100;
			ins_num_n3.time <<- c(ins_num_n3.time, ins_num_n3);
			des_num_n3.time <<- c(des_num_n3.time, des_num_n3);				
			
			# Ratio of User's  Number of Nick Names and Tags Change Over Time
			ins_num_tag = sum(rdata_day[[y+1]]$num_tag > (rdata_day[[y]]$num_tag)) ;	
			des_num_tag = sum(rdata_day[[y+1]]$num_tag < (rdata_day[[y]]$num_tag)) ;
			ins_num_tag2 = sum(rdata_day[[y+1]]$num_tag2 > (rdata_day[[y]]$num_tag2)) ;	
			des_num_tag2 = sum(rdata_day[[y+1]]$num_tag2 < (rdata_day[[y]]$num_tag2)) ;
			
			ins_num_tag.time <<- c(ins_num_tag.time, (ins_num_tag + ins_num_tag2)/length(rdata_day[[y]]$num_tag) * 100);
			des_num_tag.time <<- c(des_num_tag.time, (des_num_tag + des_num_tag2)/length(rdata_day[[y]]$num_tag) * 100);				
#			ins_num_tag.time <<- c(ins_num_tag.time, (ins_num_tag + ins_num_tag2));
#			des_num_tag.time <<- c(des_num_tag.time, (des_num_tag + des_num_tag2));				

			ins_num_nick = sum(rdata_day[[y+1]]$num_nick > (rdata_day[[y]]$num_nick)) / length(rdata_day[[y]]$num_nick) * 100;	
			des_num_nick = sum(rdata_day[[y+1]]$num_nick < (rdata_day[[y]]$num_nick)) / length(rdata_day[[y]]$num_nick) * 100;
			ins_num_nick.time <<- c(ins_num_nick.time, ins_num_nick);
			des_num_nick.time <<- c(des_num_nick.time, des_num_nick);				
			
			# Histrogram of Reduced Exposing Friends
			des_frn_num_n = rdata_day[[y+1]]$num_frn_n - rdata_day[[y]]$num_frn_n;
			des_frn_num_n[des_frn_num_n < 0] = 0;
			des_frn_n.all <<- des_frn_n.all + des_frn_num_n;
			
			# Ratio of User's Number of  In-Friend Change Over Time
			ins_num_frn = sum(rdata_day[[y+1]]$num_frn > (rdata_day[[y]]$num_frn)) / length(rdata_day[[y]]$num_frn) * 100;	
			des_num_frn = sum(rdata_day[[y+1]]$num_frn < (rdata_day[[y]]$num_frn)) / length(rdata_day[[y]]$num_frn) * 100;
			ins_num_frn.time  <<- c(ins_num_frn.time , ins_num_frn);
			des_num_frn.time  <<- c(des_num_frn.time , des_num_frn);				
		}
	}
})

ins_frn_des.time.n = c();
des_frn_des.time.n = c();

ins_num_n2.time.n = c();
des_num_n2.time.n = c();

ins_num_n3.time.n = c();
des_num_n3.time.n = c();

#:::::::::::::::::::::::::::::::::::::::
# Measure: Change Over Time
#:::::::::::::::::::::::::::::::::::::::
fin = sapply(day_range, function(y) {
	if(y < max(day_range)){
		if(y > 0 ){
			# Change in Number of Friend Descriptions Over Time
			ins_frn_des.n = sum(rdata_day[[y+1]]$num_frn_des - (rdata_day[[y]]$num_frn_des));
			des_frn_des.n = sum(rdata_day[[y]]$num_frn_des - (rdata_day[[y+1]]$num_frn_des));
			if(ins_frn_des.n < 0){
				ins_frn_des.n = 0;
			}
			
			if(des_frn_des.n < 0){
				des_frn_des.n = 0;
			}
						
			ins_frn_des.time.n <<- c(ins_frn_des.time.n, ins_frn_des.n);
			des_frn_des.time.n <<- c(des_frn_des.time.n, des_frn_des.n);	

			# Change in Number of Exposed Names Over Time
			ins_num_n2.n = sum(rdata_day[[y+1]]$num_n2 - (rdata_day[[y]]$num_n2));
			des_num_n2.n = sum(rdata_day[[y]]$num_n2 - (rdata_day[[y+1]]$num_n2));
			ins_num_n3.n = sum(rdata_day[[y+1]]$num_n3 - (rdata_day[[y]]$num_n3));
			des_num_n3.n = sum(rdata_day[[y]]$num_n3 - (rdata_day[[y+1]]$num_n3));

			if(ins_num_n2.n < 0){
				ins_num_n2.n = 0;
			}			
			if(des_num_n2.n < 0){
				des_num_n2.n = 0;
			}
						
			if(ins_num_n3.n < 0){
				ins_num_n3.n = 0;
			}			
			if(des_num_n3.n < 0){
				des_num_n3.n = 0;
			}

			ins_num_n2.time.n <<- c(ins_num_n2.time.n, ins_num_n2.n);
			des_num_n2.time.n <<- c(des_num_n2.time.n, des_num_n2.n);
			ins_num_n3.time.n <<- c(ins_num_n3.time.n, ins_num_n3.n);
			des_num_n3.time.n <<- c(des_num_n3.time.n, des_num_n3.n);
		
		}
	}
})

#:::::::::::::::::::::::::::::::::::::::
# Measure: Change In Range
#:::::::::::::::::::::::::::::::::::::::
tMax = max(day_range) + 1;
tMin = min(day_range) + 1;

# Percentage of Users Recovered from Leakage
per_num_n2.range.1 = length(rdata_day[[tMin]]$num_n2[rdata_day[[tMin]]$num_n2 > 0]) / length(rdata_day[[tMin]]$num_n2) * 100;
per_num_n2.range.2 = length(rdata_day[[tMax]]$num_n2[rdata_day[[tMax]]$num_n2 > 0]) / length(rdata_day[[tMax]]$num_n2) * 100;
per_num_n2.range = per_num_n2.range.1 - per_num_n2.range.2;
if(per_num_n2.range < 0){
	per_num_n2.range = 0;
}

per_num_n3.range.1 = length(rdata_day[[tMin]]$num_n3[rdata_day[[tMin]]$num_n3 > 0]) / length(rdata_day[[tMin]]$num_n3) * 100;
per_num_n3.range.2 = length(rdata_day[[tMax]]$num_n3[rdata_day[[tMax]]$num_n3 > 0]) / length(rdata_day[[tMax]]$num_n3) * 100;
per_num_n3.range = per_num_n3.range.1 - per_num_n3.range.2;
if(per_num_n3.range < 0){
	per_num_n3.range = 0;
}

per_num_frn_n.range.1 = length(rdata_day[[tMin]]$num_frn_n[rdata_day[[tMin]]$num_frn_n > 0]) / length(rdata_day[[tMin]]$num_frn_n) * 100 ;
per_num_frn_n.range.2 = length(rdata_day[[tMax]]$num_frn_n[rdata_day[[tMax]]$num_frn_n > 0]) / length(rdata_day[[tMax]]$num_frn_n)* 100 ;
per_num_frn_n.range = per_num_frn_n.range.1 - per_num_frn_n.range.2
if(per_num_frn_n.range < 0){
	per_num_frn_n.range = 0;
}

# Decreasion of Exposing-Friends and Exposed Names
per_num_n2.drange = length(rdata_day[[tMin]]$num_n2[rdata_day[[tMin]]$num_n2 - rdata_day[[tMax]]$num_n2 > 0]) / length(rdata_day[[tMin]]$num_n2) * 100;
per_num_n3.drange = length(rdata_day[[tMin]]$num_n3[rdata_day[[tMin]]$num_n3 - rdata_day[[tMax]]$num_n3 > 0]) / length(rdata_day[[tMin]]$num_n3) * 100;
per_num_frn_n.drange = length(rdata_day[[tMin]]$num_frn_n[rdata_day[[tMin]]$num_frn_n - rdata_day[[tMax]]$num_frn_n > 0]) / length(rdata_day[[tMin]]$num_frn_n) * 100;
if(per_num_frn_n.drange < 0){
	per_num_frn_n.drange = 0;
}


#:::::::::::::::::::::::::::::::::::::::
# Measure: Survey Data
#:::::::::::::::::::::::::::::::::::::::

# Survey : Single Choice
sur_sc1 = sum(rdata_sur$sc1)/length(rdata_sur$sc1) * 100;
sur_sc2 = sum(rdata_sur$sc2)/length(rdata_sur$sc2) * 100;
sur_sc3 = sum(rdata_sur$sc3)/length(rdata_sur$sc3) * 100;
sur_sc4 = sum(rdata_sur$sc4)/length(rdata_sur$sc4) * 100;
sur_sc5 = sum(rdata_sur$sc5)/length(rdata_sur$sc5) * 100;
sur_sc6 = sum(rdata_sur$sc6)/length(rdata_sur$sc6) * 100;
sur_sc7 = sum(rdata_sur$sc7)/length(rdata_sur$sc7) * 100;
sur_sc8 = sum(rdata_sur$sc8)/length(rdata_sur$sc8) * 100;

# Survey : Multiple Choice 1
rdata_sur_mc1 = rdata_sur[rdata_sur$sc6 > 0,];
sur_mc1_1 = sum(rdata_sur_mc1$mc1_1)/length(rdata_sur_mc1$mc1_1) * 100;
sur_mc1_2 = sum(rdata_sur_mc1$mc1_2)/length(rdata_sur_mc1$mc1_2) * 100;
sur_mc1_3 = sum(rdata_sur_mc1$mc1_3)/length(rdata_sur_mc1$mc1_3) * 100;
sur_mc1_4 = sum(rdata_sur_mc1$mc1_4)/length(rdata_sur_mc1$mc1_4) * 100;
sur_mc1_5 = sum(rdata_sur_mc1$mc1_5)/length(rdata_sur_mc1$mc1_5) * 100;
sur_mc1_6 = sum(rdata_sur_mc1$mc1_6)/length(rdata_sur_mc1$mc1_6) * 100;
sur_mc1_7 = sum(rdata_sur_mc1$mc1_7)/length(rdata_sur_mc1$mc1_7) * 100;
sur_mc1_8 = sum(rdata_sur_mc1$mc1_8)/length(rdata_sur_mc1$mc1_8) * 100;

rdata_sur_mc1.patch = rdata_sur[138:length(rdata_sur$mc1_9),];
rdata_sur_mc1.patch = rdata_sur_mc1.patch[rdata_sur_mc1.patch$sc6 > 0,];
sur_mc1_9 = sum(rdata_sur_mc1.patch$mc1_9)/length(rdata_sur_mc1.patch$mc1_9) * 100;

# Survey : Multiple Choice 2
rdata_sur_mc2 = rdata_sur[138:length(rdata_sur$mc2_1),];
rdata_sur_mc2 = rdata_sur_mc2[rdata_sur_mc2$sc6 > 0,];

sur_mc2_1 = sum(rdata_sur_mc2$mc1_1)/length(rdata_sur_mc2$mc1_1) * 100;
sur_mc2_2 = sum(rdata_sur_mc2$mc1_2)/length(rdata_sur_mc2$mc1_2) * 100;
sur_mc2_3 = sum(rdata_sur_mc2$mc1_3)/length(rdata_sur_mc2$mc1_3) * 100;
sur_mc2_4 = sum(rdata_sur_mc2$mc1_4)/length(rdata_sur_mc2$mc1_4) * 100;
sur_mc2_5 = sum(rdata_sur_mc2$mc1_5)/length(rdata_sur_mc2$mc1_5) * 100;
sur_mc2_6 = sum(rdata_sur_mc2$mc1_6)/length(rdata_sur_mc2$mc1_6) * 100;
sur_mc2_7 = sum(rdata_sur_mc2$mc1_7)/length(rdata_sur_mc2$mc1_7) * 100;
sur_mc2_8 = sum(rdata_sur_mc2$mc1_8)/length(rdata_sur_mc2$mc1_8) * 100;
sur_mc2_9 = sum(rdata_sur_mc2$mc1_9)/length(rdata_sur_mc2$mc1_9) * 100;

#:::::::::::::::::::::::::::::::::::::::
# Measure: Cross Relation
#:::::::::::::::::::::::::::::::::::::::
tMax = max(day_range) + 1;
tMin = min(day_range) + 1;

# Exposing-Friend Decreased User vs Survey Answered 
user_num_frn_n.decreased = rdata_day[[tMin]]$user_id[rdata_day[[tMin]]$num_frn_n - rdata_day[[tMax]]$num_frn_n > 0];
match_survey_list = match(user_num_frn_n.decreased, rdata_sur$user_id);
user_num_frn_n.decreased =  rdata_sur$user_id[match_survey_list[!is.na(match_survey_list)]];
user_num_frn_n.decreased.change = rdata_sur$user_id[rdata_sur$sc7 == 1 ];
user_num_frn_n.decreased.future = rdata_sur$user_id[rdata_sur$sc8 == 1 ];

per_num_frn_n.dc = sum(!is.na(match(user_num_frn_n.decreased, user_num_frn_n.decreased.change))) / length(user_num_frn_n.decreased) * 100;
per_num_frn_n.df = sum(!is.na(match(user_num_frn_n.decreased, user_num_frn_n.decreased.future))) / length(user_num_frn_n.decreased) * 100;

# User Exposing Situation vs Survey Answered
user_id.sur_sc2.y = rdata_sur$user_id[rdata_sur$sc2 == 1];
user_id.sur_sc2.n = rdata_sur$user_id[rdata_sur$sc2 == 0];

match_survey_list = match(user_id.sur_sc2.y, rdata_day[[tMin]]$user_id);
rdata_day_survey.y = rdata_day[[tMin]][match_survey_list[!is.na(match_survey_list)], ];
num_n2_survey.y = length(rdata_day_survey.y$num_n2[rdata_day_survey.y$num_n2 > 0])/ length(rdata_day_survey.y$num_n2) * 100;
num_n3_survey.y = length(rdata_day_survey.y$num_n3[rdata_day_survey.y$num_n3 > 0])/ length(rdata_day_survey.y$num_n3) * 100;
num_frn_n_survey.y = length(rdata_day_survey.y$num_frn_n[rdata_day_survey.y$num_frn_n > 0])/ length(rdata_day_survey.y$num_frn_n) * 100;

match_survey_list = match(user_id.sur_sc2.n, rdata_day[[tMin]]$user_id);
rdata_day_survey.n = rdata_day[[tMin]][match_survey_list[!is.na(match_survey_list)], ];
num_n2_survey.n = length(rdata_day_survey.n$num_n2[rdata_day_survey.n$num_n2 > 0])/ length(rdata_day_survey.n$num_n2) * 100;
num_n3_survey.n = length(rdata_day_survey.n$num_n3[rdata_day_survey.n$num_n3 > 0])/ length(rdata_day_survey.n$num_n3) * 100;
num_frn_n_survey.n = length(rdata_day_survey.n$num_frn_n[rdata_day_survey.n$num_frn_n > 0])/ length(rdata_day_survey.n$num_frn_n) * 100;




#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# DRAW -----------------------------------------------------------------------------------------
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# User Exposing Situation vs Survey Answered
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(num_frn_n_survey.y,num_n2_survey.y, num_n3_survey.y,  num_frn_n_survey.n, num_n2_survey.n, num_n3_survey.n);
custom.matrix = matrix(custom.mixed, byrow=F, nrow=3);
dimnames(custom.matrix) = list(c("", "",""), c("Protect", "Not Protect"));
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.3);
custom.legend = c("Have Exposing-Friend", "First Name Exposed", "Full Name Exposed");
custom.col = c("red", "green", "blue", "red", "green", "blue");
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3.5;
custom.legend.y = custom.ylim[2];
custom.main = "User Exposing Situation vs Survey Answered";
custom.xlab = "Answer";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Xleak_VS_care", main=T);
	barplot(custom.matrix , col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);
my.sim.end_draw();

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Exposing-Friend Decreased User vs Survey Answered 
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(per_num_frn_n.dc, per_num_frn_n.df);
names(custom.mixed) = c("Change Now", "Take Care in Future");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.col = bcol.sky;
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3;
custom.legend.y = custom.ylim[2];
custom.main = "Exposing-Friend Decreased User vs Survey Answered ";
custom.xlab = "Question";
custom.ylab = "Percentage of Answered Yes (%)"
my.sim.start_draw("XNum_frn_n_VS_change", main=T);
	barplot(custom.mixed , col=custom.col, cex.name=0.6, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=0);
my.sim.end_draw();



# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Survey Result 3
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(sur_mc1_1, sur_mc1_2, sur_mc1_3, sur_mc1_4, sur_mc1_5, sur_mc1_6, sur_mc1_7, sur_mc1_8, sur_mc1_9);
names(custom.mixed) = c("RName", "RFirst", "Gender", "Age", "School",  "WorLoc", "JobTit", "CellNo", "LivP");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.col = bcol.sky;
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3;
custom.legend.y = custom.ylim[2];
custom.main = "Survey Result 3";
custom.xlab = "Question";
custom.ylab = "Percentage of Answered Yes (%)"
my.sim.start_draw("Survey2", main=T);
	barplot(custom.mixed , col=custom.col, cex.name=0.6, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=0);
my.sim.end_draw();

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Survey Result 3
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(sur_mc2_1, sur_mc2_2, sur_mc2_3, sur_mc2_4, sur_mc2_5, sur_mc2_6, sur_mc2_7, sur_mc2_8, sur_mc2_9);
names(custom.mixed) = c("RName", "RFirst", "Gender", "Age", "School",  "WorLoc", "JobTit", "CellNo", "LivP");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.col = bcol.sky;
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3;
custom.legend.y = custom.ylim[2];
custom.main = "Survey Result 3";
custom.xlab = "Question";
custom.ylab = "Percentage of Answered Yes (%)"
my.sim.start_draw("Survey3", main=T);
	barplot(custom.mixed , col=custom.col, cex.name=0.6, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=0);
my.sim.end_draw();


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Survey Result 2
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(sur_mc1_1, sur_mc1_2, sur_mc1_3, sur_mc1_4, sur_mc1_5, sur_mc1_6, sur_mc1_7, sur_mc1_8, sur_mc1_9);
names(custom.mixed) = c("RName", "RFirst", "Gender", "Age", "School",  "WorLoc", "JobTit", "CellNo", "LivP");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.col = bcol.sky;
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3;
custom.legend.y = custom.ylim[2];
custom.main = "Survey Result 2";
custom.xlab = "Question";
custom.ylab = "Percentage of Answered Yes (%)"
my.sim.start_draw("Survey2", main=T);
	barplot(custom.mixed , col=custom.col, cex.name=0.6, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=0);
my.sim.end_draw();

# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Survey Result 1
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(sur_sc1, sur_sc2, sur_sc3, sur_sc4, sur_sc5, sur_sc6, sur_sc7, sur_sc8);
names(custom.mixed) = c("Ptect_SNS", "Ptect_WRE", "Show_Photo", "Know_Leak", "Know_Nam", "Find_Risk", "Chg_Now", "Chg_Late");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.col = bcol.sky;
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3;
custom.legend.y = custom.ylim[2];
custom.main = "Survey Result 1";
custom.xlab = "Question";
custom.ylab = "Percentage of Answered Yes (%)"
my.sim.start_draw("Survey1", main=T);
	barplot(custom.mixed , col=custom.col, cex.name=0.6, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=0);
my.sim.end_draw();


# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Percentage of User Mitigated from Leakage
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(per_num_n2.drange, per_num_n3.drange, per_num_frn_n.drange, per_num_n2.range, per_num_n3.range, per_num_frn_n.range);
custom.matrix = matrix(custom.mixed, byrow=T, nrow=2);
dimnames(custom.matrix) = list(c("", ""), c("Exposed First Name", "Exposed Full Name", "Exposed Frn"));
names(custom.mixed) = c("Exposed First Name", "Exposed Full Name", "Exposed Frn");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Decreased", "Recovered");
custom.col = c("red", "green", "red", "green", "red", "green");
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 6;
custom.legend.y = custom.ylim[2];
custom.main = "Percentage of User Mitigated from Leakage";
custom.xlab = "Situations";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Decrease_num_n", main=T);
	barplot(custom.matrix , col=custom.col, beside=T, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=-1);
my.sim.end_draw();

if(0){
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Percentage of Users Recovered from Leakage
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(per_num_n2.range, per_num_n3.range, per_num_frn_n.range);
names(custom.mixed) = c("Exposed First Name", "Exposed Full Name", "Exposed Frn");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( 0,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Exposed First Name", "Exposed Full Name", "Exposed Frn");
custom.col = c("red", "green", "blue", "violetred2");
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = 3;
custom.legend.y = custom.ylim[2];
custom.main = "Percentage of Users Recovered from Leakage";
custom.xlab = "Situations";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Crange_num_n", main=T);
	barplot(custom.mixed , col=custom.col, ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
#	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  fill=custom.col,  cex=0.8, xjust=0);
my.sim.end_draw();
}


# :::::::::::::::::::::::::::::::::::::::::
# Change in Number of Exposed Names Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_num_n2.time.n, des_num_n2.time.n, ins_num_n3.time.n, ins_num_n3.time.n);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("First Name Increase", "First Name Decrease", "Full Name Increase", "Full Name Decrease");
custom.col = c("red", "green", "blue", "violetred2");
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = length(ins_num_n2.time);
custom.legend.y = custom.ylim[2];
custom.main = "Change in Number of Exposed Names Over Time";
custom.xlab = "Day";
custom.ylab = "Number of Exposed Names"
my.sim.start_draw("NCtime_num_n", main=T);
	plot(ins_num_n2.time.n, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_num_n2.time.n, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
	lines(ins_num_n3.time.n, col=custom.col[3], lty=custom.lty[3], type=custom.type[3],  pch=custom.pch[3]);
	lines(des_num_n3.time.n, col=custom.col[4], lty=custom.lty[4], type=custom.type[4], pch=custom.pch[4]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();



# :::::::::::::::::::::::::::::::::::::::::
# Change in Number of Friend Descriptions Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_frn_des.time.n, des_frn_des.time.n);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Increase", "Decrease");
custom.col = c("red", "green", "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.legend.x = length(ins_frn_n.time);
custom.legend.y = custom.ylim[2];
custom.main = "Change in Number of Friend Descriptions Over Time";
custom.xlab = "Day";
custom.ylab = "Number of Friend Descriptions"
my.sim.start_draw("NCtime_num_frn_des", main=T);
	plot(ins_frn_des.time.n, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_frn_des.time.n, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
#	lines(diff_frn_des.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3], pch=custom.pch[3]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Ratio of User's  Number of Nick Names and Tags Change Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_num_tag.time, des_num_tag.time, ins_num_nick.time, des_num_nick.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Nick Name Increase", "Nick Name Decrease", "Tag Increase", "Tag Decrease");
custom.col = c("red", "green", "blue", "violetred2");
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = length(ins_num_n2.time);
custom.legend.y = custom.ylim[2];
custom.main = "Ratio of User's  Number of Nick Names and Tags Change Over Time";
custom.xlab = "Day";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Ctime_num_tag_nick", main=T);
	plot(ins_num_nick.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_num_nick.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
	lines(ins_num_tag.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3],  pch=custom.pch[3]);
	lines(des_num_tag.time, col=custom.col[4], lty=custom.lty[4], type=custom.type[4], pch=custom.pch[4]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();



# :::::::::::::::::::::::::::::::::::::::::
# Ratio of User Modified Exposed Name Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_num_n2.time, des_num_n2.time, ins_num_n3.time, des_num_n3.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("First Name Increase", "First Name Decrease", "Full Name Increase", "Full Name Decrease");
custom.col = c("red", "green", "blue", "violetred2");
custom.pch = c(1, 2, 3, 4);
custom.type = c("b", "b", "b", "b");
custom.lty = c(2, 1, 3, 4);
custom.legend.x = length(ins_num_n2.time);
custom.legend.y = custom.ylim[2];
custom.main = "Ratio of User's  Exposed Names Change Over Time";
custom.xlab = "Day";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Ctime_num_n", main=T);
	plot(ins_num_n2.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_num_n2.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
	lines(ins_num_n3.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3],  pch=custom.pch[3]);
	lines(des_num_n3.time, col=custom.col[4], lty=custom.lty[4], type=custom.type[4], pch=custom.pch[4]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Histrogram of Reduced Exposing Friends
# :::::::::::::::::::::::::::::::::::::::::
custom.col = c("red", "green", "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.legend.x = length(ins_frn_n.time);
custom.legend.y = custom.ylim[2];
custom.main = "Histrogram of Decreased Name-Exposing Friends";
custom.xlab = "Number of Decreased Name-Exposing Friends";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Hist_num_frn_n", main=T);
	hist(des_frn_n.all[des_frn_n.all > 0], freq=F, main=custom.main, xlab=custom.xlab);
	lines(density(des_frn_n.all[des_frn_n.all > 0]), col=custom.col[1]);
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::::::::::
# Ratio of User's Number of  In-Friend Change Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_num_frn.time, des_num_frn.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Increase", "Decrease");
custom.col = c("red", "green", "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.legend.x = length(ins_frn_n.time);
custom.legend.y = custom.ylim[2];
custom.main = "Ratio of User's Number of  In-Friend Change Over Time";
custom.xlab = "Day";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Ctime_num_frn", main=T);
	plot(ins_num_frn.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_num_frn.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
#	lines(diff_frn_des.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3], pch=custom.pch[3]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();

# :::::::::::::::::::::::::::::::::::::::::
# Ratio of User's  Number of Name-Exposing Friends Change Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_frn_n.time, des_frn_n.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Increase", "Decrease");
custom.col = c("red", "green", "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.legend.x = length(ins_frn_n.time);
custom.legend.y = custom.ylim[2];
custom.main = "Ratio of User's  Number of Name-Exposing Friends Change Over Time";
custom.xlab = "Day";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Ctime_num_frn_n", main=T);
	plot(ins_frn_n.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_frn_n.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
#	lines(diff_frn_des.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3], pch=custom.pch[3]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();


# ::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Users' Number of  Friend Descriptions Change Over Time
# ::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(ins_frn_des.time, des_frn_des.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("Increase", "Decrease");
custom.col = c("red", "green", "blue");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.legend.x = length(ins_frn_des.time);
custom.legend.y = custom.ylim[2];
custom.main = "Ratio of Users' Number of  Friend Descriptions Change Over Time";
custom.xlab = "Day";
custom.ylab = "Percentage (%)"
my.sim.start_draw("Ctime_num_frn_des", main=T);
	plot(ins_frn_des.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(des_frn_des.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
#	lines(diff_frn_des.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3], pch=custom.pch[3]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();



# :::::::::::::::::::::::::::::::::::::::::
# Number of Name-Exposing Friends Over Time
# :::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(num_frn_n.time, num_frn_n2.time, num_frn_n3.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("First Name", "Full Name", "First Name or Full Name");
custom.col = c("red", "green", "blue");
custom.pch = c(1, 2, 3);
custom.type = c("b", "b", "b");
custom.lty = c(2, 1 ,1);
custom.legend.x = length(num_frn_n.time);
custom.legend.y = custom.ylim[2];
custom.main = "Number of Name-Exposing Friends Over Time";
custom.xlab = "Day";
custom.ylab = "Number of Name-Exposing Friends"
my.sim.start_draw("time_num_frn_n", main=T);
	plot(num_frn_n2.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(num_frn_n3.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
	lines(num_frn_n.time, col=custom.col[3], lty=custom.lty[3], type=custom.type[3], pch=custom.pch[3]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();


# :::::::::::::::::::::::::::::::::
# Number of Exposed Names Over Time
# :::::::::::::::::::::::::::::::::
custom.mixed = c(num_n2.time, num_n3.time);
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin,  custom.ymax + custom.ymax*0.2);
custom.legend = c("First Name", "Full Name");
custom.col = c("red", "green");
custom.pch = c(1, 2);
custom.type = c("b", "b");
custom.lty = c(2, 1);
custom.legend.x = length(num_n2.time);
custom.legend.y = custom.ylim[2];
custom.main = "Number of Exposed Names Over Time";
custom.xlab = "Day";
custom.ylab = "Number of Exposed Names"
my.sim.start_draw("time_num_name");
	plot(num_n2.time, col=custom.col[1], lty=custom.lty[1], type=custom.type[1],  pch=custom.pch[1], ylim=custom.ylim, main=custom.main,  xlab=custom.xlab, ylab=custom.ylab);
	lines(num_n3.time, col=custom.col[2], lty=custom.lty[2], type=custom.type[2], pch=custom.pch[2]);
	legend(x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, lty=custom.lty, pch=custom.pch, cex=0.8, xjust=1);
my.sim.end_draw();


if(0){
label_frn_expose =  c("First Name", "Full Name", "First Name or Full Name" );
name_frn_expose = list(NULL, label_frn_expose);

num_frn_n.day2 = rdata_day[[2]]$num_frn_n;
num_frn_n.day21 = rdata_day[[21]]$num_frn_n;
match.result = match(rdata_day[[2]]$user_id, rdata_day[[21]]$user_id);
match.result = match.result[!is.na(match.result)]
num_frn_n.day21 = num_frn_n.day21[match.result];

match.result2 = match(rdata_day[[21]]$user_id, rdata_day[[2]]$user_id);
match.result2 = match.result2[!is.na(match.result2)]
num_frn_n.day2 = num_frn_n.day2[match.result2];

id.day21 = rdata_day[[21]]$user_id[match.result];
id.day2 = rdata_day[[2]]$user_id[match.result2];


mean_num_frn_n_2 = mean(num_frn_n.day2);
mean_num_frn_n_21 = mean(num_frn_n.day21);



data_frn_expose = matrix( c(rdata_day[[1]]$num_frn_n2, rdata_day[[1]]$num_frn_n3, rdata_day[[1]]$num_frn_n),  ncol=3, nrow=length(rdata_day[[1]]$num_frn_n3), dimnames=name_frn_expose);

		my.sim.start_draw("hist_frn_expose");
#		hist(rdata_day[[2]]$num_frn_n,freq=F, main="Histrogram of Number of Friend Exposed Real Name", xlab="Number of Friend Exposed Real Name");
		plot(density(rdata_day[[2]]$num_frn_n), col="blue");
		lines(density(rdata_day[[12]]$num_frn_n), col="red");
		lines(density(rdata_day[[18]]$num_frn_n), col="green");
		my.sim.end_draw();
		
		
	}