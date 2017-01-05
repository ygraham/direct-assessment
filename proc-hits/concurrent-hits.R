# Copyright 2016 Yvette Graham 
# 
# This file is part of Direct-Assessment.
# 
# Direct-Assessment is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Direct-Assessment is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Direct-Assessment.  If not, see <http://www.gnu.org/licenses/>

args <- commandArgs(TRUE);
rdir <- args[1];
item <- args[2];

hits <- read.table(paste(rdir,"/",item,"-hit-time.csv",sep=""),header=TRUE);

hits$accept <- strptime(hits$accept,"%a %b %d %H:%M:%S %Y");
hits$submit <- strptime(hits$submit,"%a %b %d %H:%M:%S %Y");
cat(paste("H=",hits[1,]$accept,"\n"))
hits$accept.open <- NA;
hits$submit.open <- NA;

attach(hits)

for( w in unique(unlist(WorkerId)) ) { 
	
	worker.hits <- hits[ which( WorkerId==w ), ]

	if( length(worker.hits$accept) == 1 ){
		hits[ which( WorkerId==w ), ]$accept.open=1;
		hits[ which( WorkerId==w ), ]$submit.open=1;
	}else{
		# sort all the accept and submit times for this worker
		times <- c( worker.hits$accept, worker.hits$submit);
		
		sorted.times <- sort(times);
		open.hits <- 0

		# loop through from latest to earliest hit for worker
		for( i in 1:length(sorted.times) ){
			accept.times <- worker.hits[ which( worker.hits$accept == sorted.times[i]), ];
			submit.times <- worker.hits[ which( worker.hits$submit == sorted.times[i]), ];

			# add newly opened hit (with this accept time)
			open.hits <- open.hits + length(accept.times$HITId);
			
			if( length(submit.times$HITId) >= 1){
				hits[ which( hits$WorkerId==w & hits$submit == sorted.times[i]), ]$submit.open <- open.hits
			}

			if( length(accept.times$HITId) >= 1){
				hits[ which( hits$WorkerId==w & hits$accept == sorted.times[i]), ]$accept.open <- open.hits
			}
			
			# remove newly submitted hit (with this submit time)
			open.hits <- open.hits - length(submit.times$HITId);

			
			#if( (length(accept.times$HITId) > 1) ){
			#	cat(paste("error: duplicate accept time for worker ",w," accepts:",length(accept.times$HITId),"\n"));
			#	quit("no");
			#}
			#if( (length(submit.times$HITId) > 1) ){
		#		cat(paste("error: duplicate accept time for worker ",w," submits:",length(submit.times$HITId),"\n"));
		#		quit("no");
		#	}

		}
	}
}
cat(paste(rdir,"/",item,"-corrected-hit-times.csv",sep=""));
sink(paste(rdir,"/",item,"-corrected-hit-times.csv",sep=""));

cat(paste(
	"hit",
	"wid",
	"src",
	"trg",
	"item",
	"work.seconds",
	"accept.time",
	"submit.time",
	"concurrent.hits",
	"corrected.work.seconds",
	"approval",
"\n"));
    
for( w in sort(unique(unlist(WorkerId))) ) { 
  
	worker.hits <- hits[ which( WorkerId==w ), ]
        
    if( length(worker.hits$accept) == 1 ){
	
        h <- worker.hits
        concurrent = 1

        cat(paste(
                  h$HITId,
                  h$WorkerId,
                  h$src,
                  h$trg,
                  h$item,
                  h$work.seconds,
                  paste("\"",h$accept,"\"",sep=""),
                  paste("\"",h$submit,"\"",sep=""),
                  concurrent,
                  (h$work.seconds/concurrent),
                  h$approval,
                  "\n",sep="\t")) 
    }else{

	    sorted.times <- sort(worker.hits$accept);
    
        # loop through from latest to earliest hit for worker
	    for( i in 1:length(sorted.times) ){
    
		    hs <- worker.hits[ which( worker.hits$accept == sorted.times[i]), ];

		    for( j in 1:length(hs$HITId) ){
			h <- hs[j,];

			if( h$accept.open > h$submit.open ){
				concurrent <- h$accept.open
          	}else{
				concurrent <- h$submit.open
			}

			cat(paste(
				h$HITId,
				h$WorkerId,
				h$src,
				h$trg,
				h$item,
				h$work.seconds,
				paste("\"",h$accept,"\"",sep=""),
				paste("\"",h$submit,"\"",sep=""),
				concurrent,
				(h$work.seconds/concurrent),
				h$approval,
			"\n",sep="\t"))
		    }
	    }
    }
}

sink()
