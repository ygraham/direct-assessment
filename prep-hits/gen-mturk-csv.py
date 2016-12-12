#!/usr/bin/env python2
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


import sys

SRC = sys.argv[1]
TRG = sys.argv[2]
ITEM = sys.argv[3]
LP = SRC+"-"+TRG
SIZE = 100

f = "out/"+ITEM+"."+LP
lines = [line.rstrip('\n') for line in open(f,'rU')]
# skip header
lines.pop(0)

print("LEN:"+str(len(lines)))

nhits = len(lines)/SIZE

f = "out/ad.mturk-hits."+SRC+"-"+TRG+".csv"
out = open(f,'w')

# HEADER
out.write("src,trg,item,hit")
for i in xrange(0,SIZE):  
  out.write(",sys_"+str(i)+",sid_"+str(i)+",tst_"+str(i)+","+"rid_"+str(i))
out.write("\n")

# HITS
info_str = "\'"+SRC+"\',\'"+TRG+"\',\'"+ITEM+"\'"

k = 0
for i in xrange(0,nhits):
  out.write(info_str+","+str(i))

  for j in xrange(0,SIZE):
    l = lines[k].replace("\t","\',\'")
    out.write(",\'"+l+"\'") 
    k += 1
  out.write("\n")
  
out.close()

