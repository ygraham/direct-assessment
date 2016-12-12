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

import glob
import sys
 
DIR = sys.argv[1]
SRC = sys.argv[2]
TRG = sys.argv[3]
DATA = sys.argv[4]
BR_DIR = sys.argv[5]

LP = SRC+"-"+TRG

swrds = [{},{},{},{},{},{},{}]

f = "data/references/"+DATA+"-"+SRC+TRG+"-ref."+TRG

lines = [line.rstrip('\n') for line in open(f,'rU')]

for i in xrange(0,len(lines)):
    
  if (i%100)==0: print('.'),

  l = lines[i]
  wrds = l.split()

  # skip initial and last words
  for j in xrange(1,len(wrds)-1):
    w = wrds[j]
    w = w.lower()

    if not w in swrds[1].keys():
      swrds[1][w] = 1

    if j+1 < (len(wrds)-1) :
      w = w +' '+ wrds[j+1]

      if not w in swrds[2].keys():
        swrds[2][w] = 1 

    if j+2 < (len(wrds)-1) :
      w = w +' '+wrds[j+2]

      if not (w in swrds[3].keys()):
        swrds[3][w] = 1 
      
    if j+3 < (len(wrds)-1) :
      w = w +' '+wrds[j+3]

      if not (w in swrds[4].keys()):
        swrds[4][w] = 1 
      
    if j+4 < (len(wrds)-1) :
      w = w +' '+wrds[j+4]

      if not (w in swrds[5].keys()):
        swrds[5][w] = 1 

    if j+5 < (len(wrds)-1) :
      w = w +' '+wrds[j+5]

      if not (w in swrds[6].keys()):
        swrds[6][w] = 1 
      
for i in xrange(1,7):
  f = 'out/bad-ref/ad/'+SRC+"-"+TRG+'/subwrds/subwrds-'+str(i)
  out = open(f,'w')

  for k in swrds[i].keys():
    out.write(k+'\n')

  out.close()

