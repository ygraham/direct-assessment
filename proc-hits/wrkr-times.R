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


args <- commandArgs(TRUE)
rdir <- args[1]
item <- args[2]

pnts <- 1

scrs <- read.table(paste(rdir,"/",item,"-latest.csv",sep=""),header=TRUE)
hits <- read.table(paste(rdir,"/",item,"-corrected-hit-times.csv",sep=""),header=TRUE)

hits$max.const.seq.len <- NA
hits$app <- NA
hits$rej <- NA
hits$rejected <- NA

j <- 1

for( w in unique(unlist(scrs$WorkerId))){

  	w.hits <- scrs[ which( scrs$WorkerId==w), ]

	last.scr <- -1;
	curr.const.seq.len <- 1;
	max.const.seq.len <- 0;
	const.val <- -1;

	for( i in 1:length(w.hits$score)){

		if( w.hits[i,]$score == last.scr ){
			curr.const.seq.len <- curr.const.seq.len + 1

			if( curr.const.seq.len > max.const.seq.len ){
				max.const.seq.len <- curr.const.seq.len
				const.val <- w.hits[i,]$score
			}
		}else{
			curr.const.seq.len <- 1;
		}
		last.scr <- w.hits[i,]$score

	}
	
	hits[ which( hits$wid==w), ]$max.const.seq.len <- max.const.seq.len
	hits[ which( hits$wid==w), ]$rejected <- round(length(hits[ which( hits$wid==w & hits$approval=="Rejected" ),]$approval)/length(hits[which( hits$wid==w ),]$approval),2)

}

attach(hits)

sink(paste(rdir,"/",item,"-wrkr-stats.csv",sep=""))
cat(	"wid",
	"hit.count",
	"mean.bad.ref",
	"mean.sys.out",
	"mean.ref",
	"min.hit.time",
	"mean.hit.time",
	"mean.concurrent",
	"max.concurrent",
	"max.const.seq.len",
	"reject.rate",
	"scores.flag",
	"time.flag",
	"seq.flag",
	"reject.flag",
	"\n")

for( w in unique(unlist(wid))){

  	w.hits <- hits[ which( wid==w), ]
    w.bad.refs <- scrs[ which( scrs$WorkerId==w & scrs$type=="BAD_REF" ), ]
    w.sys.out <- scrs[ which( scrs$WorkerId==w & scrs$type=="SYSTEM" ), ]
    w.refs <- scrs[ which( scrs$WorkerId==w & scrs$type=="REF" ), ]

	suspect.scrs <- "-"
	suspect.time <- "-"
	suspect.const.seq <- "-"
	suspect.rej <- "-"
	
	if( ((mean(w.bad.refs$score) >= mean(w.sys.out$score)) | (mean(w.sys.out$score) >= mean(w.refs$score))) | ( (item=="ad") & (mean(w.refs$score)<90) ) ){
		suspect.scrs <- "flag(scrs)"
	}

	if( min(w.hits$corrected.work.seconds) < 300 ){
        	suspect.time <- "flag(time)"  	 
	}

	if( mean(w.hits$max.const.seq.len) > 8 ){
		suspect.const.seq <- "flag(seq)"
	}
	
	if( mean(w.hits$rejected) > 0 ){
		suspect.rej <- "flag(rej)"
	}

	cat(w,
		length(w.hits$hit),
		# mean scores
		round(mean(w.bad.refs$score),pnts),
		round(mean(w.sys.out$score),pnts),
		round(mean(w.refs$score),pnts),
		# hit completion times
		round(min(w.hits$corrected.work.seconds),pnts),
		round(mean(w.hits$corrected.work.seconds),pnts),
		round(mean(w.hits$concurrent.hits),pnts),
		round(max(w.hits$concurrent.hits),pnts),
		# sequence of constant scores
		mean(w.hits$max.const.seq.len), # will be constant - mean for quick fix
		# percentage of rejected hits
		mean(w.hits$rejected), # will also be constant
		# flags
		suspect.scrs,
		suspect.time,
		suspect.const.seq,
		suspect.rej,
		"\n")
}

sink()
