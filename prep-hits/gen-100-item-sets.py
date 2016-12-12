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
import random
import glob

SRC = sys.argv[1]
TRG = sys.argv[2]
DATA = sys.argv[3]

LP = SRC+"-"+TRG
DIR = "data/"+DATA+"/"+LP

system_fns = glob.glob(DIR+"/*")
size = len([line.rstrip('\n') for line in open( system_fns[0],'rU')])
system = []
i = 0

for fn in system_fns:
  #s = fn.replace(DIR+"/"+DATA+".","")
  #s = s.replace("."+LP,"")
  s = fn.replace(DIR+"/"+DATA+"."+LP+".","")
  system.append(s)
  
  if len([line.rstrip('\n') for line in open(fn,'rU')]) != size :
    sys.stderr.write("Error: not all system submission files have the same number of lines: "+fn)
    sys.exit()    

# generate random ids  
total_items = len(system) * size * 10
rids = range(1000000,(1000000+total_items))
random.shuffle(rids)

# loop thru systems and sent ids
items = []

for i in xrange(0,len(system)): 
  for j in xrange(0,size):
    items.append(system[i]+" "+str(j+1))

random.shuffle(items)


nsecs = (len(items)/7)
if (len(items) % 7) != 0:
  nsecs = (len(items)/7) + 1

nhits = (nsecs / 10)

if (nsecs % 10) != 0:
  nhits = (nsecs / 10) + 1

nsecs = nhits * 10 # adds extra sec for uneven number of items

systems = []
snt_ids = []
types = []

ind = 0

# Setting up sets of 10 translations (7 orig + 3 calibration items)
for i in xrange(0, nsecs):
    
  systems.append([])
  snt_ids.append([])
  types.append([])

  for j in xrange(0,7):

    # if we have an uneven number of translations, add in extra from the beginning to make up
    if not ind < len(items):
      ind = 0

    l = items[ind]
    c = l.split()
    system = c[0]
    sid = c[1]

    systems[i].append(system)
    snt_ids[i].append(sid)
    types[i].append("SYSTEM")

    ind += 1

sys.stderr.write("Creating "+str(nsecs)+" sets of 10 items \n")

# loop through sets and add calibration according to spacing
space = 5

for i in xrange(0,nsecs):

  # randomly select 3 sents from swap set for (i) calib (ii) ref (iii) repeat
  # 5 items before or after
  if (i == 0) or ((i%10) < space):
    swap_set = i + space
  else:
    swap_set = i - space

  rnd = range(0,7)
  random.shuffle(rnd)

  systems[i].append(systems[swap_set][rnd[0]])
  systems[i].append(systems[swap_set][rnd[1]])
  systems[i].append(systems[swap_set][rnd[2]])

  snt_ids[i].append(snt_ids[swap_set][rnd[0]])
  snt_ids[i].append(snt_ids[swap_set][rnd[1]])
  snt_ids[i].append(snt_ids[swap_set][rnd[2]])
 
  types[i].append("BAD_REF")
  types[i].append("REPEAT")
  types[i].append("REF")

print "MT.SYS\tSID\tTYPE\tRID"

# shuffle only when all sets arranged
for i in xrange(0, nhits*10):

  rnd = range(0,10)
  random.shuffle(rnd)

  for j in range(0,len(rnd)):
    r = rnd[j] # selects translation at random (0-9)
    print systems[i][r]+"\t"+snt_ids[i][r]+"\t"+types[i][r]+"\t"+str(rids.pop())


