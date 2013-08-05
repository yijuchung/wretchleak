# General Graphing Drawing functions

my.sim.output.path = "done/";


my.bool.percent = function(w.data){
	return(sum(w.data) / length(w.data) * 100);
}

# Random move
do.runif = function(data){
	return(data + runif(length(data), -.5, .5))
}


my.sim.latex.table = function( data, caption="", title="", filename="", pos="h"){
	num_row = length(data[1,]);
	num_col = length(data[,1]);
	header =  sprintf("
	\\begin{table}[%s]
    \\begin{center}
        \\caption{%s}
        \\vspace{2pt}
        \\begin{tabular}{|l|r|}
        \\hline
	",
	pos,caption
	);		
	
	body = "";
	i = 1;
	while(i <= num_row){
		
		if(data[2,i] != ""){
			body = paste(body, data[1,i], " & ", data[2,i], " \\\\ \n", sep="");
		}else{
			body = paste(body, "\\multicolumn{2}{|c|}{", data[1,i], "} \\\\", sep="");
		}
		
		body = paste(body, "\\hline\n", sep="");
		i = i + 1;
	}

	footer = "
       
        \\end{tabular}
    \\end{center}

\\end{table}";

	conx = paste(header, body, footer, sep="");
	
	if(filename != ""){
		output = paste(my.sim.output.path, filename, ".tex", sep="");
		cat(file=output, conx, append=F);
	}else{
		print(conx);
	}

}

my.sim.dis_ratio = function(par){

	d_names = c("gender", "nickname", "blood","birthday","height","weight","education","occupation","email","msn","yahoo","skype","intro");
	nam.i = match(d_names, names(par));

	d_value = sapply(d_names, function(x) {
	  if (x == "height" || x == "weight") return (sum(par[x] > 0, na.rm=T))
	  if (x == "gender" || x == "blood" || x == "birthday" || x == "education") return (sum(par[x] != "", na.rm=T))
	  return (sum(par[x] == T ,na.rm=T))
	})
	
	d_value = d_value / length(par[,1]) * 100;
	
	return(d_value)

}

my.sim.init.barplot = function(win, start, end, xpar, ypar, meth="mean"){

	win = win
	ypar.block = ypar %/% win;
#	blocks = sort(unique(ypar.block))[(start %/% win):(end %/% win)]
	blocks = (start %/% win):((end %/% win)-1);
	
	if(meth=="median"){
		result = sapply(blocks, function(i) {
			r = median(xpar[ypar.block == i])
			if(i == blocks[1]){
				names(r) = sprintf("%d-%d", (i)*win, (i+1)*win)
			}else{
				names(r) = sprintf("%d-%d", (i)*win+1, (i+1)*win)
			}
			r
		})
	}else{
		result = sapply(blocks, function(i) {
			r = mean(xpar[ypar.block == i])
			if(i == blocks[1]){
				names(r) = sprintf("%d-%d", (i)*win, (i+1)*win)
			}else{
				names(r) = sprintf("%d-%d", (i)*win+1, (i+1)*win)
			}
			r
		})	
	}
	return(result);
	
}

my.sim.init.barplot.fix.cross = function(blocks, xpar, ypar, meth="mean"){


	if(meth=="median"){
		result = sapply(blocks, function(i) {
			r = median(xpar[ypar == i])
			names(r)  = i
			r
		})
	}else{
		result = sapply(blocks, function(i) {
			r = mean(xpar[ypar == i])
			names(r)  = i
			r
		})	
	}
	return(result);
	
}

my.sim.init.barplot.ratio = function(win, start, end, xpar, ypar){

	ypar.block = ypar %/% win;
#	blocks = sort(unique(ypar.block))[(start %/% win):(end %/% win)]
	blocks = (start %/% win):((end %/% win)-1);
	result = sapply(blocks, function(i) {
		r = sum(xpar[ypar.block == i]) / sum(ypar.block == i) * 100
		if(i == blocks[1]){
			names(r) = sprintf("%d-%d", (i)*win, (i+1)*win)
		}else{
			names(r) = sprintf("%d-%d", (i)*win+1, (i+1)*win)
		}		
		r
	})
	
	return(result);
	
}


my.sim.init.barplot.dis = function(win, start, end, par, total=0){

	win = win
	par.block = par %/% win;
#	blocks = sort(unique(par.block))[(start %/% win):(end %/% win)]
	blocks = (start %/% win):((end %/% win)-1);
	
	if(total==0){
		total = length(par)
	}
	
	result = sapply(blocks, function(i) {
		r = sum(par.block == i) / total * 100;
		if(i == blocks[1]){
			names(r) = sprintf("%d-%d", (i)*win, (i+1)*win)
		}else{
			names(r) = sprintf("%d-%d", (i)*win+1, (i+1)*win)
		}		
		r
	})
	
	return(result);
	
}

my.sim.init.barplot.fix = function( par, par.block, sort_res=F, total=0){

	if(total==0){
		total = length(par)
	}

	result = sapply(par.block, function(i) {
		r = sum(par == i) / total * 100;
		r
	})
	
	if(sort_res){
		sort(result, decreasing =T);
	}
	
	return(result);
}


my.sim.start_draw = function(out.file=NA, num=1, width=0, height=0, main=F){

	if(width != 0){
		my.fig.width <<- width;
	}
	
	if(height != 0){
	    my.fig.height <<- height;	
	}

	if(main == F){
		my.fig(paste(my.sim.output.path, out.file, sep=""), num);
#	        my.png.fig(paste(my.sim.output.path, out.file, sep=""), num);

	}else{
		my.fig(paste(my.sim.output.path, out.file, sep=""), num, main=T);
#	        my.png.fig(paste(my.sim.output.path, out.file, sep=""), num, main=T);

	}

}


my.sim.end_draw = function(){
    my.fig.off()
#    my.png.fig.off()

}

my.sim.barplot = function(output.file, data, title="", col="blue", xlab="x", ylab="y", space=NULL,legend_pos=c(0, max(data) + max(data)*0.2), legend_just=c(0, -0.5), legend_name, use_legend=F,  ylim=c(0, max(data) + max(data)*0.2), xaxis.cex=1, bar.cex=0.8, percent=1,auto=F,cex.ylab=1.5, cex.lab=1, cex.xlab=0, cex.axis=1, cex.name=1, cex.legend=0.9){	

	if(auto == T){
	    mp = barplot(data, beside=T, axis.lty=1,  col=col,
	    	xlab=xlab,  ylab=ylab);	
			
	}else{
		
		if(cex.xlab == 0){
	    mp = barplot(data, beside=T, axis.lty=1,  col=col, ylim=ylim, space=space,
	    	xlab=xlab,  ylab=ylab);
		}else{
		    mp = barplot(data, beside=T, axis.lty=1,  col=col, ylim=ylim, space=space,
		    	xlab="",  ylab=ylab, cex.lab=cex.ylab, cex.axis=cex.axis, cex.name = cex.name);		
			mtext(xlab, line = 2.1, side = 1, cex=cex.xlab) 		
		}
	}
	
	if(title != ""){
		title(main=title);
	}
	if(percent == 1){
		text(mp, data, labels=sprintf("%.0f%%", data), adj =c(0.5,-1), xpd = T, cex=bar.cex);
	}else{
		if(percent == 2){
			text(mp, data, labels=sprintf("%.1f", data), adj =c(0.5,-1), xpd = T, cex=bar.cex);
		}
	}
	if(use_legend){
	#	my.legend(legend_pos[1],legend_pos[2], legend_name,col=col, pch=15, xjust=legend_just[1], yjust=legend_just[2], cex=0.9);
		
		legend(x=legend_pos[1], y=legend_pos[2],  legend=legend_name,  fill = col,  xjust = legend_just[1], yjust = legend_just[2], cex=cex.legend);
      	
		
    }
	

}


my.sim.barplot.axis = function(output.file, data, title="", col="blue", xlab="x", ylab="y", space=NULL,legend_pos=c(0, max(data) + max(data)*0.2), legend_just=c(0, -0.5), legend_name, use_legend=F,  ylim=c(0, max(data) + max(data)*0.2), xaxis.cex=1, bar.cex=0.8, percent=1,auto=F,cex.ylab=1.5, cex.lab=1, cex.xlab=0, cex.axis=1, cex.name=1, cex.legend=0.9, axis.x=0, axis.y=0){	

	    mp = barplot(data, beside=T, axis.lty=1,  col=col, ylim=ylim, space=space,
	    	xlab=xlab,  ylab=ylab, cex.name = cex.name, axes=FALSE);
		
		if(length(axis.x) > 0){
			axis(1, axis.x, axis.x);
		}else{
			axis(1)
		}

		if(length(axis.y) > 0){
			axis(2, axis.y, axis.y);
		}else{
			axis(2);
		}

		
	if(title != ""){
		title(main=title);
	}
	if(percent == 1){
		text(mp, data, labels=sprintf("%.0f%%", data), adj =c(0.5,-1), xpd = T, cex=bar.cex);
	}else{
		if(percent == 2){
			text(mp, data, labels=sprintf("%.1f", data), adj =c(0.5,-1), xpd = T, cex=bar.cex);
		}
	}
	if(use_legend){
	#	my.legend(legend_pos[1],legend_pos[2], legend_name,col=col, pch=15, xjust=legend_just[1], yjust=legend_just[2], cex=0.9);
		
		legend(x=legend_pos[1], y=legend_pos[2],  legend=legend_name,  fill = col,  xjust = legend_just[1], yjust = legend_just[2], cex=cex.legend);      			
    }
	

}


my.sim.barplot.double = function(output.file, data, srt=0, x_cex=1, x_pos=c(0.5,-2), col=bcol.double, xlab="x", ylab="y", legend_pos=c(0, max(data)), legend_just=c(0, 1), legend_name, use_legend=T, ylim=c(0, max(data) + max(data)*0.15), x_name ){	


	mp = barplot(matrix(data, ncol=length(data) %/% 2), beside=T, axis.lty=1, ylim=ylim,  col=col,
		xlab="", ylab=ylab);
		
	if(use_legend){
		my.legend(legend_pos[1],legend_pos[2],legend_name,col=col, pch=15, xjust=-1, cex=0.9);
	}

    text(mp, data, labels=sprintf("%.0f%%", data), adj =c(0.5,-1), xpd = T, cex=0.8);

	text(mp+x_pos[1], x_pos[2], labels=x_name, srt = srt, xpd = T, cex=x_cex);
	mtext(xlab, line = 1, side = 1, cex=1.5) 
	
}


my.sim.scatterplot = function(output.file, x_data, y_data, xlab="x", ylab="y", log="", xlim=c(0,100), ylim=c(0,100),  col="blue"){

	plot(x_data, y_data, pch=".", log=log,  xlim=xlim, ylim=ylim, xlab=xlab, ylab=ylab, col=col);
	text(max(xlim),max(ylim),pos=2, sprintf("cor:%.3f",cor(x_data, y_data)), adj=c(0,1), cex=1);
	lines(lowess(x_data,y_data),col=2,lwd=2);
	
}


my.sim.ccdf = function(output.file, data, data2, log="",col=bcol.gender, xlab, ylab, double=F, lwd=2, legend_name, legend_pos = c(0,1), xlim=c(0,100), legend_just=c(0, -0.5)){
		

	m = seq(0, 100, 1);	
	plot(m, data(m), type="l", col=col[1], xlim=xlim, log=log, lwd=lwd, xlab=xlab, ylab=ylab);	
	if(double){
		lines(m, data2(m), type="l", col=col[2], lwd=lwd, lty=4);
		my.legend(legend_pos[1],legend_pos[2],legend_name,col=col,  lty=c(1, 4), cex=0.8, xjust=legend_just[1], yjust=legend_just[2],);
		
	}
	
}


my.sim.plot = function(data, log="",col=bcol.gender, xlab="", ylab="", lwd=2, legend_name="", legend_pos = c(0.5,max(data)), ylim=c(0,100), legend_just=c(0, 1), xaxis.cex=1, cex.name=1, xstep=0 ){
		

		
	p=plot(x=c(0:(length(data[1,])-1))+xstep, y=data[1,], type="o", col=col[1], log=log, lwd=lwd, xlab=xlab, ylab=ylab, pch = 16, ylim=ylim, xaxt = "n");	
	axis(1, at=1:length(data[1,]), labels=names(data[1,]), cex.axis=xaxis.cex);

#	mtext(xlab, line = 2.1, side = 1, cex=1.5) 
	

#	len = length(data[,1]);
	len=0;
	i = 2;
	ltyx = c(1);
	pchx = c(16);
	while(i <= len ){
		lines(x=c(0:(length(data[1,])-1))+xstep, y=data[i,], type="o", col=col[i], lwd=lwd, pch = i + 16, lty=i + 3, cex=1.3);
		ltyx = c(ltyx, i + 3);
		pchx = c(pchx, i + 16);
		i = i + 1;
	}
	
	if(len == 2){
	#	text(length(data[1,]),max(ylim)-1,pos=2, sprintf("cor:%.3f",cor(data[1,], data[2,])), adj=c(0,2), cex=1.5);	
	}
	if(len > 1){
		my.legend(legend_pos[1],legend_pos[2],legend_name,col=col, cex=0.9, pch=pchx,lwd=1, lty=ltyx, xjust=legend_just[1], yjust=legend_just[2], seg.len = 4);
	
	}

}


