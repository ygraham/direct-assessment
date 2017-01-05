
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

DIR <- args[1]
ITEM <- args[2]
STND <- args[3]
SRC <- args[4]
TRG <- args[5]
N <- as.numeric(args[6])

if( STND=="raw" ){
    f <- paste( DIR, "/", ITEM, "-good-", STND, ".csv", sep="")
}else{
    f <- paste( DIR, "/", ITEM, "-", SRC, TRG,"-good-", STND, ".csv", sep="")
}
a <- read.table( f, header=TRUE )

# only include system outputs (repeats are system outputs) - not including ref or bad ref
a <- a[ which( (( a$Input.src==SRC ) & ( a$Input.trg==TRG )) & ( a$type=="SYSTEM" | a$type=="REPEAT" ) ), ]

f <- paste( DIR, "/", ITEM, "-", STND, "-seg-scores-",N,".", SRC, "-", TRG, ".csv", sep="")
sink( f)

cat( paste( "SID", "SYS", "SCR", "N", "\n") )
for( snt in unique(unlist( a$sid )) ) {
  for( sys in unique(unlist( a[ which( a$sid==snt ), ]$sys_id ))){
    scrs <- a[ which( (a$sid==snt) & (a$sys_id==sys)), ]$score

    if( N <= length(scrs) ){
      smp <- sample( scrs, N, replace=FALSE)
      cat( paste( snt, sys, mean(smp), N, "\n"))
    }
  }
}

sink()
cat(paste("wrote: ",f,"\n"))
a <- read.table(f)
