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
import random
 
DIR = sys.argv[1]
SRC = sys.argv[2]
TRG = sys.argv[3]
DATA = sys.argv[4]
BR_DIR = sys.argv[5]

LP = SRC+"-"+TRG

system_fns = glob.glob(DIR+"/"+LP+"/*")

WORDS = ["zero"]

for i in xrange(1,7):
  #f = 'out/bad-ref/sub-wrds-'+str(i)
  f = 'out/bad-ref/ad/'+LP+'/subwrds/subwrds-'+str(i)
  WORDS.append([line.rstrip('\n') for line in open(f,'rU')])

for f in system_fns:

  newf = BR_DIR+"/"+f.replace("data/"+DATA+"/"+LP+"/","")

  lines = [line.rstrip('\n') for line in open(f,'rU')]

  out = open(newf,'w')

  # create a new file containg bad refs for each line in lines
  for i in xrange(0,len(lines)):

    l = lines[i]
    #print("\n"+l)
    wrds = l.split()
    n = len(wrds)
    #print("\nLEN="+str(n))
    new_l = ""

    if n == 1:
      new_l = random.choice(WORDS[1]).title()
    elif n == 2:
      new_l = wrds[0]+' '+random.choice(WORDS[1])
    elif n==3:
      new_l = wrds[0]+' '+random.choice(WORDS[1])+' '+wrds[2]
    elif n==4:
      new_l = wrds[0]+' '+random.choice(WORDS[2])+' '+wrds[3]
    else: 
  
      if n==5:
        rem = 2
      elif n < 8:
        rem = 3
      elif n < 15:
        rem = 4
      elif n < 20:
        rem = 5
      else: 
        rem = int(n/4)
   
      #print("newfn="+newf) 
      #print("i="+str(i)) 
      #print("REM="+str(rem))
      #print("LAST POSS START="+str(n-rem-1))

      start = random.choice(xrange(1,n-rem-1))
      
      new_l = wrds[0]

      for i in xrange(1,start):
        new_l = new_l + ' '+wrds[i]

      if rem <=5 :
        new_l += ' '+random.choice(WORDS[rem])
      else:
        new_l += ' '+random.choice(WORDS[6])

      for i in xrange(start+rem,len(wrds)):
        new_l = new_l + ' '+wrds[i]
      
    out.write(new_l+'\n')

  out.close()

#f = system_fns[0]
#lines = [line.rstrip('\n') for line in open(f,'rU')]


