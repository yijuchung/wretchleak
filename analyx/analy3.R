rm(list=ls(all=TRUE));
source("R-lib/common.R");
source("R-lib/my.legend.R");
source("R-lib/my.sim.IO.R");
source("R-lib/my.fig.R");
source("R-lib/my.sim.R");

thres_num_frn = 1;
flag_frn_open = 0;
max_day = 7;
my.sim.output.path = "done/";
day_range = c(0:(max_day-1));
day_index = day_range + 1;

my.sim.read("data");
rdata$user_id = as.character(rdata$user_id);
rdata$raw_date = as.character(rdata$raw_date);

my.sim.read2("data_sur");
rdata_sur$user_id = as.character(rdata_sur$user_id);

bcol.sky = topo.colors(100);
bcol.red = sort(grep("red",colors()));
my.sim.output.path = "done/";

# got ID which have at least 2 days
max_id = rdata$user_id[rdata$num_day==max_day];

#::::::::::::::::::::::::::::::::
# Got Unconditioned in Open
#::::::::::::::::::::::::::::::::
rdata_day = rdata[1,];
rdata_day$num_day = 999;

tmp =  sapply(max_id, function(y) {
	# have enough friend is ok
	if(rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){
		rdata_day <<- merge(rdata_day, rdata[rdata$user_id == as.character(y) & rdata$num_day < max_day ,], all=T);
	}
});

rdata_day = rdata_day[rdata_day$num_day != 999,];

# Break by Day
rdata_day.sep = lapply(day_range, function(y) rdata_day[rdata_day$num_day == y ,])

if(0){
#::::::::::::::::::::::::::::::::
# Got Opened in first and end day
#::::::::::::::::::::::::::::::::
rdata_day.open = rdata[1,];
rdata_day.open$num_day = 999;

tmp =  sapply(max_id, function(y) {
	if(rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == 0] != 0 & rdata$frn_ok[rdata$user_id == as.character(y) & rdata$num_day == max_day] != 0 & rdata$num_frn[rdata$user_id == as.character(y) & rdata$num_day == 0] >= thres_num_frn){
		rdata_day.open <<- merge(rdata_day.open, rdata[rdata$user_id == as.character(y) & rdata$num_day < max_day ,], all=T);
	}
});

rdata_day.open = rdata_day.open[rdata_day.open$num_day != 999,];

# Break by Day
rdata_day.open.sep = lapply(day_range, function(y) rdata_day.open[rdata_day.open$num_day == y ,])
}

#:::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Leakage Change by Time
#:::::::::::::::::::::::::::::::::::::::::::::::
leaked_day.total_length = length(rdata_day.sep[[1]]$user_id);
leaked_day =  sapply(day_index, function(y) {
	leaked_day.ratio = length(rdata_day.sep[[y]]$user_id[rdata_day.sep[[y]]$num_n2 > 0 | rdata_day.sep[[y]]$num_n3 > 0]) / leaked_day.total_length * 100;
	leaked_day.ratio;
});

#:::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Leakage Change S6
#:::::::::::::::::::::::::::::::::::::::::::::::
user_id.sur_sc6.y = rdata_sur$user_id[rdata_sur$sc6 == 1 ];
user_id.sur_sc6.n = rdata_sur$user_id[rdata_sur$sc6 == 0 ];

leaked_day.sc6.y =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sc6.y, rdata_day.sep[[y]]$user_id);
	rdata_day.sc6.y = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sc6.y.total_length = length(rdata_day.sc6.y$user_id);
	leaked_day.sc6.y.ratio = length(rdata_day.sc6.y$user_id[rdata_day.sc6.y$num_n2 > 0 | rdata_day.sc6.y$num_n3 > 0]) / leaked_day.sc6.y.total_length * 100;
	leaked_day.sc6.y.ratio;
});

leaked_day.sc6.n =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sc6.n, rdata_day.sep[[y]]$user_id);
	rdata_day.sc6.n = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sc6.n.total_length = length(rdata_day.sc6.n$user_id);
	leaked_day.sc6.n.ratio = length(rdata_day.sc6.n$user_id[rdata_day.sc6.n$num_n2 > 0 | rdata_day.sc6.n$num_n3 > 0]) / leaked_day.sc6.n.total_length * 100;
	leaked_day.sc6.n.ratio;
});


#:::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Leakage Change S2
#:::::::::::::::::::::::::::::::::::::::::::::::
user_id.sur_sc2.y = rdata_sur$user_id[rdata_sur$sc2 == 1 ];
user_id.sur_sc2.n = rdata_sur$user_id[rdata_sur$sc2 == 0 ];

leaked_day.sc2.y =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sc2.y, rdata_day.sep[[y]]$user_id);
	rdata_day.sc2.y = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sc2.y.total_length = length(rdata_day.sc2.y$user_id);
	leaked_day.sc2.y.ratio = length(rdata_day.sc2.y$user_id[rdata_day.sc2.y$num_n2 > 0 | rdata_day.sc2.y$num_n3 > 0]) / leaked_day.sc2.y.total_length * 100;
	leaked_day.sc2.y.ratio;
});

leaked_day.sc2.n =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sc2.n, rdata_day.sep[[y]]$user_id);
	rdata_day.sc2.n = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sc2.n.total_length = length(rdata_day.sc2.n$user_id);
	leaked_day.sc2.n.ratio = length(rdata_day.sc2.n$user_id[rdata_day.sc2.n$num_n2 > 0 | rdata_day.sc2.n$num_n3 > 0]) / leaked_day.sc2.n.total_length * 100;
	leaked_day.sc2.n.ratio;
});

#:::::::::::::::::::::::::::::::::::::::::::::::
# Measure: Ratio of Leakage Change S7S8
#:::::::::::::::::::::::::::::::::::::::::::::::
user_id.sur_sit1 = rdata_sur$user_id[rdata_sur$sc7 == 0 & rdata_sur$sc8 == 0];
user_id.sur_sit2 = rdata_sur$user_id[rdata_sur$sc7 == 1 ];
user_id.sur_sit3 = rdata_sur$user_id[(rdata_sur$sc7 == 1 & rdata_sur$sc8 == 0)|(rdata_sur$sc7 == 0 | rdata_sur$sc8 == 1)|(rdata_sur$sc7 == 1 | rdata_sur$sc8 == 1) ];

leaked_day.sit1 =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sit1, rdata_day.sep[[y]]$user_id);
	rdata_day.sit1 = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sit1.total_length = length(rdata_day.sit1$user_id);
	leaked_day.sit1.ratio = length(rdata_day.sit1$user_id[rdata_day.sit1$num_n2 > 0 | rdata_day.sit1$num_n3 > 0]) / leaked_day.sit1.total_length * 100;
	leaked_day.sit1.ratio;
});

leaked_day.sit2 =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sit2, rdata_day.sep[[y]]$user_id);
	rdata_day.sit2 = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sit2.total_length = length(rdata_day.sit2$user_id);
	leaked_day.sit2.ratio = length(rdata_day.sit2$user_id[rdata_day.sit2$num_n2 > 0 | rdata_day.sit2$num_n3 > 0]) / leaked_day.sit2.total_length * 100;
	leaked_day.sit2.ratio;
});

leaked_day.sit3 =  sapply(day_index, function(y) {
	match_survey_list = match(user_id.sur_sit3, rdata_day.sep[[y]]$user_id);
	rdata_day.sit3 = rdata_day.sep[[y]][match_survey_list[!is.na(match_survey_list)], ];
	leaked_day.sit3.total_length = length(rdata_day.sit3$user_id);
	leaked_day.sit3.ratio = length(rdata_day.sit3$user_id[rdata_day.sit3$num_n2 > 0 | rdata_day.sit3$num_n3 > 0]) / leaked_day.sit3.total_length * 100;
	leaked_day.sit3.ratio;
});

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# DRAW -----------------------------------------------------------------------------------------------------------------------------------
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Leakage Change S7S8
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked_day.sit1, leaked_day.sit2, leaked_day.sit3);
custom.mixed1 = leaked_day.sit1;
custom.mixed2 = leaked_day.sit2;
custom.mixed3 = leaked_day.sit3;

custom.total = leaked_day.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin - custom.ymin*0.05,  custom.ymax + custom.ymax*0.05);
custom.col = c("red", "green", "blue");
custom.pch = c(19, 15, 17);
custom.type = c("b");
custom.lty = c(1, 2, 3);
custom.lwd = c(2);

custom.xlab = "Day";
custom.ylab = "Ratio of Name Leakage (%)";
custom.legend.x = max(day_index);
custom.legend.y = custom.ylim[2];
custom.legend = c("Not Change", "Change Now", "Change Now or Later");
custom.cex = 1.7;
custom.bar.cex = 1;

custom.xaxp = c(min(day_index), max(day_index), length(day_index)-1);
my.sim.start_draw("4. Ratio_Name_Leakage_sc78", main=F);
	mp = plot(custom.mixed1, type=custom.type, xaxp=custom.xaxp, cex=custom.cex, lwd=custom.lwd , col=custom.col[1], xstep=1, ylim=custom.ylim, pch=custom.pch[1], lty=custom.lty[1], xlab=custom.xlab, ylab=custom.ylab);
	lines(custom.mixed2, type=custom.type, cex=custom.cex, lwd=custom.lwd , col=custom.col[2], xstep=1, ylim=custom.ylim, pch=custom.pch[2], lty=custom.lty[2], xlab=custom.xlab, ylab=custom.ylab);
	lines(custom.mixed3, type=custom.type, cex=custom.cex, lwd=custom.lwd , col=custom.col[3], xstep=1, ylim=custom.ylim, pch=custom.pch[3], lty=custom.lty[3], xlab=custom.xlab, ylab=custom.ylab);
	text(day_index, custom.mixed+0.3 ,  labels=sprintf("%.0f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend( x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, pch=custom.pch, lty=custom.lty, lwd=custom.lwd,  pt.cex=custom.bar.cex, cex=0.8, xjust=1);		
my.sim.end_draw();


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Leakage Change S2
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked_day.sc2.y, leaked_day.sc2.n);
custom.mixed1 = leaked_day.sc2.y;
custom.mixed2 = leaked_day.sc2.n;

custom.total = leaked_day.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin - custom.ymin*0.05,  custom.ymax + custom.ymax*0.05);
custom.col = c("green", "red");
custom.pch = c(19, 15, 17);
custom.type = c("b");
custom.lty = c(1, 2);
custom.lwd = c(2);

custom.xlab = "Day";
custom.ylab = "Ratio of Name Leakage (%)";
custom.legend.x = max(day_index);
custom.legend.y = custom.ylim[2];
custom.legend = c("Answered Yes", "Answered No");
custom.cex = 1.7;
custom.bar.cex = 1;

custom.xaxp = c(min(day_index), max(day_index), length(day_index)-1);
my.sim.start_draw("3. Ratio_Name_Leakage_sc2", main=F);
	mp = plot(custom.mixed1, type=custom.type, xaxp=custom.xaxp, cex=custom.cex, lwd=custom.lwd , col=custom.col[1], xstep=1, ylim=custom.ylim, pch=custom.pch[1], lty=custom.lty[1], xlab=custom.xlab, ylab=custom.ylab);
	lines(custom.mixed2, type=custom.type, cex=custom.cex, lwd=custom.lwd , col=custom.col[2], xstep=1, ylim=custom.ylim, pch=custom.pch[2], lty=custom.lty[2], xlab=custom.xlab, ylab=custom.ylab);
	text(day_index, custom.mixed+0.3 ,  labels=sprintf("%.0f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend( x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, pch=custom.pch, lty=custom.lty, lwd=custom.lwd,  pt.cex=custom.bar.cex, cex=0.8, xjust=1);		
my.sim.end_draw();


#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Leakage Change S6
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = c(leaked_day.sc6.y, leaked_day.sc6.n);
custom.mixed1 = leaked_day.sc6.y;
custom.mixed2 = leaked_day.sc6.n;

custom.total = leaked_day.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin - custom.ymin*0.05,  custom.ymax + custom.ymax*0.05);
custom.col = c("green", "red");
custom.pch = c(19, 15, 17);
custom.type = c("b");
custom.lty = c(1, 2);
custom.lwd = c(2);

custom.xlab = "Day";
custom.ylab = "Ratio of Name Leakage (%)";
custom.legend.x = max(day_index);
custom.legend.y = custom.ylim[2];
custom.legend = c("Answered Yes", "Answered No");
custom.cex = 1.7;
custom.bar.cex = 1;

custom.xaxp = c(min(day_index), max(day_index), length(day_index)-1);
my.sim.start_draw("2. Ratio_Name_Leakage_Sc6", main=F);
	mp = plot(custom.mixed1, type=custom.type, xaxp=custom.xaxp, cex=custom.cex, lwd=custom.lwd , col=custom.col[1], xstep=1, ylim=custom.ylim, pch=custom.pch[1], lty=custom.lty[1], xlab=custom.xlab, ylab=custom.ylab);
	lines(custom.mixed2, type=custom.type, cex=custom.cex, lwd=custom.lwd , col=custom.col[2], xstep=1, ylim=custom.ylim, pch=custom.pch[2], lty=custom.lty[2], xlab=custom.xlab, ylab=custom.ylab);
	text(day_index, custom.mixed+0.3 ,  labels=sprintf("%.0f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
	legend( x=custom.legend.x, y=custom.legend.y, legend=custom.legend,  col=custom.col, pch=custom.pch, lty=custom.lty, lwd=custom.lwd,  pt.cex=custom.bar.cex, cex=0.8, xjust=1);		
my.sim.end_draw();

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# Ratio of Leakage Change by Time
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
custom.mixed = leaked_day;
custom.total = leaked_day.total_length;
custom.total = paste(" (",custom.total,")", sep="");
custom.ymin = min(custom.mixed);
custom.ymax = max(custom.mixed);
custom.ylim = c( custom.ymin - custom.ymin*0.05,  custom.ymax + custom.ymax*0.05);
custom.col = c("red");
custom.pch = c(19);
custom.type = c("b");
custom.lty = c(1);
custom.lwd = c(2);

custom.xlab = "Day";
custom.ylab = "Ratio of Name Leakage (%)";
custom.legend.x = 6;
custom.legend.y = custom.ylim[2];
custom.legend = c("First Name", "Full Name");
custom.cex = 1.7;
custom.bar.cex = 1;

custom.xaxp = c(min(day_index), max(day_index), length(day_index)-1);
my.sim.start_draw("1. Ratio_Name_Leakage_Time", main=F);
	mp = plot(custom.mixed, type=custom.type, xaxp=custom.xaxp, cex=custom.cex, lwd=custom.lwd , col=custom.col, xstep=1, ylim=custom.ylim, pch=custom.pch, lty=custom.lty, xlab=custom.xlab, ylab=custom.ylab);
	text(day_index, custom.mixed+0.3 ,  labels=sprintf("%.0f%%", custom.mixed), adj =c(0.5,-1), xpd = T, cex=custom.bar.cex );
my.sim.end_draw();


