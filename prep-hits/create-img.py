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


import time
import os
import sys
import glob
from txt2img import text2png

SRC = sys.argv[1]
TRG = sys.argv[2]
SYS_DR = sys.argv[3]
BAD_DR = sys.argv[4]
REF_DR = sys.argv[5]
OUT_DR = sys.argv[6]
DATA = sys.argv[7]
FN = sys.argv[8]

LP = SRC+"-"+TRG

# read in reference translations
f = "data/references/"+DATA+"-"+SRC+TRG+"-ref."+TRG
ref_lines = [line.rstrip('\n') for line in open(f)]

# read in source language sentences 
#newstest2016-csen-src.cs
f = "data/sources/"+DATA+"-"+SRC+TRG+"-src."+SRC
src_lines = [line.rstrip('\n') for line in open(f)]

# read in MT system translations
system_fns = glob.glob(SYS_DR+"/"+DATA+"*")
sys_lines = {}

for f in system_fns:
  lines = [line.rstrip('\n') for line in open(f)]
  name = f.replace(SYS_DR+"/"+DATA+"."+LP+".","")
  print("|"+name+"|")
  sys_lines[name] = lines

# read in Bad reference translations
badref_fns = glob.glob(BAD_DR+"/"+DATA+"*")
bad_lines = {}

for f in badref_fns:
  lines = [line.rstrip('\n') for line in open(f)]
  name = f.replace(BAD_DR+"/"+DATA+"."+LP+".","")
  bad_lines[name] = lines

dr = OUT_DR+"/"+LP
if not os.path.isdir(dr):
  os.makedirs(dr) 

log_fn = OUT_DR+"/"+LP+"/snt_log"
det_fn = OUT_DR+"/"+LP+"/det_log"
ref_fn = OUT_DR+"/"+LP+"/ref_log"
src_fn = OUT_DR+"/"+LP+"/src_log"
logA = open(log_fn,'w')
logB = open(det_fn,'w')
logC = open(ref_fn,'w')
logD = open(src_fn,'w')
  
logB.write("sys sid type\n")

lines = [line.rstrip('\n') for line in open(FN)]

for i in xrange(1,len(lines)):
  l = lines[i]

  l.rstrip()
  c = l.split()

  # system	snt_id	typ	rnd_id
  sys_id = c[0]
  snt_id = int(c[1])
  typ =    c[2]
  rnd_id = c[3] 

  imgtxt = ""

  if (typ=="SYSTEM") or (typ=="REPEAT"):
    imgtxt = sys_lines[sys_id][snt_id-1]
  elif typ=="BAD_REF":
    imgtxt = bad_lines[sys_id][snt_id-1]
  elif typ== "REF":
    imgtxt = ref_lines[snt_id-1]
  
  subdr = int(rnd_id) / 1000
  subdr = str(subdr).zfill(3)
  
  dr = OUT_DR+"/"+LP+"/"+subdr
  if not os.path.isdir(dr):
    os.makedirs(dr) 

  imgfn = dr+"/"+rnd_id+".png"

  text2png(imgtxt, imgfn, fontfullpath = "arial.ttf")

  logA.write(imgtxt+"\n")
  logB.write(sys_id+" "+str(snt_id)+" "+typ+"\n")
  logC.write(ref_lines[snt_id-1]+"\n")
  logD.write(src_lines[snt_id-1]+"\n")

logA.close()
logB.close()
logC.close()
logD.close()
