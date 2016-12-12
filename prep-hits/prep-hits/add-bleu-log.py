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

f = "out/img/"+ITEM+"/"+SRC+"-"+TRG+"/det_log"
lines = [line.rstrip('\n') for line in open(f,'rU')]
hdr = lines.pop(0)

f = "out/img/"+ITEM+"/"+SRC+"-"+TRG+"/snt_bleu"
blines = [line.rstrip('\n') for line in open(f,'rU')]

f = "out/img/"+ITEM+"/"+SRC+"-"+TRG+"/details"
out = open(f,'w')
out.write(hdr+" bleu\n")

for i in xrange(0,len(lines)):
  out.write(lines[i]+" "+blines[i]+"\n")

out.close
