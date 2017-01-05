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

fn <- paste( rdir, "/ad-repeats.csv", sep="")
cat(paste("Reading file:",fn,"\n"))

reps <- read.table( fn, header=TRUE, sep=",")

intra <- reps[ which( reps$rep_type=="sys_cal" ), ]
attach(intra)
sink(paste(rdir,"/ad-trk-stats.txt",sep=""))

for( w in unique(unlist(wid)) ) { 

    p <- 1
    t <- 1
    w_cal <- intra[ which( wid==w ), ]

    result = tryCatch({
  
        p <- t.test(w_cal$score_b,w_cal$score_a,alt="less",paired=TRUE)$p.value; 
        t <- t.test(w_cal$score_b,w_cal$score_a,alt="less",paired=TRUE)$statistic; 
  
    }, warning = function(warn) {
        return("warning")
    }, error = function(err) {
        return("error")
    }, finally = {})

    if( (result != "error") & (result != "warning") ){
        print(w)
        print(p)
        print(t) 
        print(length(w_cal$sid))
    }
}

sink()

