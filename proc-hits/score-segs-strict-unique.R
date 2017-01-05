
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

f <- paste( DIR, "/", ITEM, "-",STND,"-wrkr-seg-scores.", SRC,"-", TRG,".csv", sep="")
a <- read.table( f, header=TRUE )

f <- paste( DIR, "/", ITEM, "-", STND, "-seg-scores-",N,".", SRC, "-", TRG, ".csv", sep="")
sink( f)

cat( paste( "HIT", "N", "SID", "SYS", "SCR", "\n") )
for( snt in unique(unlist( a$SID )) ) {
  for( system in unique(unlist( a[ which( a$SID==snt ), ]$SYS ))){
    b <- a[ which( (a$SID==snt) & (a$SYS==system)), ]

    if( N <= length(b$SCR) ){
      cat( paste( b[1,]$HIT, length(b$SCR), snt, system, mean(b$SCR), "\n"))
    }
  }
}

sink()
cat(paste("wrote: ",f,"\n"))
a <- read.table(f)
