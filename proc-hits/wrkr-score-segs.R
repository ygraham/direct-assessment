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
cat(paste(f))
a <- read.table( f, header=TRUE )

# only include system outputs (repeats are system outputs) - not including ref or bad ref
a <- a[ which( (( a$Input.src==SRC ) & ( a$Input.trg==TRG )) & ( a$type=="SYSTEM" | a$type=="REPEAT" ) ), ]

f <- paste( DIR, "/", ITEM, "-", STND, "-wrkr-seg-scores.", SRC, "-", TRG, ".csv", sep="")
sink( f)

cat( paste( "HIT", "SID", "SYS", "SCR", "N", "WID", "\n") )
for( snt in unique(unlist( a$sid )) ) {
    
    b <- a[ which(a$sid==snt), ]
  
    for( sys in unique(unlist( b$sys_id ))){

      c <- b[ which(b$sys_id==sys), ]

        for( w in unique(unlist( c$WorkerId))){
    
          d <- c[ which(c$WorkerId==w), ]

          #if( N <= length(scrs) ){
          #smp <- sample( scrs, N, replace=FALSE)
          cat( paste( paste("H",d[1,]$hit,sep=""), d[1,]$sid, d[1,]$sys, mean(d$score), length(d$score), d[1,]$WorkerId, "\n"))
          
          #}
       }
    }
}

sink()
cat(paste("wrote: ",f,"\n"))
a <- read.table(f)
