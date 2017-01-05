
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

item <- args[1]
sl <- args[2];
tl <- args[3];
dir <- args[4]

fn <- paste(dir,"/",item,"-latest.csv",sep="")

a <- read.table(fn,header=TRUE);
b <- a[ which( (a$Input.src==sl) & (a$Input.trg==tl) ), ]
fn <- paste(dir,"/",item,"-trk-mean-sd.txt",sep="")

attach(b);
sink(paste(dir,"/",item,"-",sl,tl,"-trk-mean-sd.txt",sep=""))

for( w in unique(unlist(WorkerId)) ) {
  wjs <- b[ which( WorkerId==w ), ]
  print(w)
  print(mean(wjs$score))
  print(sd(wjs$score))
}

sink()

attach(b);
sink(paste(dir,"/",item,"-",sl,tl,"-trk-mean-sd-no-refs.txt",sep=""))

for( w in unique(unlist(WorkerId)) ) {
  wjs <- b[ which( WorkerId==w & ( type=="SYSTEM" | type=="REPEAT" )), ]
  print(w)
  print(mean(wjs$score))
  print(sd(wjs$score))
}

sink()
