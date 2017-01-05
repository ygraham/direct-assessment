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

fn = sys.argv[1]
lines = [line.rstrip('\n') for line in open(fn)]

system = {}
ref = {}
bref = {}
rep = {}

sys_time = {}

for i in xrange(1,len(lines)):

  l = lines[i]
  c = l.split()

  # 39AYGO6AFFGHV5WHHSQL465H02R6N2  A1VL7AAOUPDN72  en      es      ad      QE13T11 1000850 SYSTEM  117     0       2529  
  hit = c[0]
  trkr = c[1]
  src = c[2]
  trg = c[3]
  item = c[4]
  sys = c[6]
  rid = c[7]
  typ = c[8]
  sid = c[9]
  scr = c[10]
  time = c[11]

  k = trkr+","+hit+","+src+","+trg+","+item+","+sys+","+sid

  if typ == "SYSTEM":
    system[k] = scr
  elif typ == "REPEAT":
    rep[k] = scr
  elif typ == "REF":
    ref[k] = scr
  elif typ == "BAD_REF":
    bref[k] = scr

  sys_time[k] = time

i = 0
  
print "rep_id,a_type,wid,hit,src,trg,item,sys,sid,rep_type,score_a,time_a,score_b,time_b"

for k in rep.keys():
  typ = "sys_sys"
  sys_scr = system[k]
  rep_scr = rep[k]
  time = sys_time[k]

  prn = str(i)+",intra,"+k+","+typ+","+str(sys_scr)+","+str(time)+","+str(rep_scr)+","+str(time) 
  print prn   

for k in bref.keys():
  typ = "sys_cal"
  sys_scr = system[k]
  rep_scr = bref[k]
  time = sys_time[k]

  prn = str(i)+",intra,"+k+","+typ+","+str(sys_scr)+","+str(time)+","+str(rep_scr)+","+str(time) 
  print prn   

for k in ref.keys():
  typ = "sys_ref"
  sys_scr = system[k]
  rep_scr = ref[k]
  time = sys_time[k]

  prn = str(i)+",intra,"+k+","+typ+","+str(sys_scr)+","+str(time)+","+str(rep_scr)+","+str(time) 
  print prn   


