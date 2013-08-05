# File: my.sim.IO.R
# function: Provides read and write IO functions


my.sim.read = function(filename, refresh=F){
	filename.rdata = paste(filename, ".Rdata", sep="");
	filename.txt = paste(filename, ".txt", sep="");

	if(refresh==F && file.exists(filename.rdata)){
		msg = paste(filename.rdata, " exists, Reading Rdata...", sep="");
		print(msg);
		load(filename.rdata, .GlobalEnv);

	}else{
		if(file.exists(filename.txt)){
			msg = paste("Reading ", filename.txt, sep="");
			print(msg);
			# read Data
			rdata <<- read.table(filename.txt,header=T,sep = ",");
			save(rdata,file=filename.rdata)
			msg = paste("Read Data Completed!");
			print(msg);
		}else{
			msg = paste("File ", filename.txt, " not exists.", sep="");
			print(msg);
		}
	}
	flush.console();
}


my.sim.read2 = function(filename, refresh=F){
	filename.rdata = paste(filename, ".Rdata", sep="");
	filename.txt = paste(filename, ".txt", sep="");

	if(refresh==F && file.exists(filename.rdata)){
		msg = paste(filename.rdata, " exists, Reading Rdata...", sep="");
		print(msg);
		load(filename.rdata, .GlobalEnv);

	}else{
		if(file.exists(filename.txt)){
			msg = paste("Reading ", filename.txt, sep="");
			print(msg);
			# read Data
			rdata_sur <<- read.table(filename.txt,header=T,sep = ",");
			save(rdata_sur,file=filename.rdata)
			msg = paste("Read Data Completed!");
			print(msg);
		}else{
			msg = paste("File ", filename.txt, " not exists.", sep="");
			print(msg);
		}
	}
	flush.console();
}