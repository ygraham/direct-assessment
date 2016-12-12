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
import os
import sys

src = sys.argv[1]
trg = sys.argv[2]
data = sys.argv[3]

dr = "data/"+data+"/"+src+"-"+trg
new_dr = dr+"_clean/"

if not os.path.isdir(new_dr):
  os.mkdir(new_dr)

fns = glob.glob(dr+"/*")

for fn in fns:

  lines = [line.rstrip('\n') for line in open(fn,'rU')]

  fn = fn.replace(dr+"/","")
  new_fn = new_dr+"/"+fn
  out = open(new_fn,'w')

  for l in lines:
    l = l.replace("&quot;","\"")

    if l.strip()=="":
      out.write("No\n")
    else:
      out.write(l+"\n")
      
  out.close()

orig = "data/"+data+"/orig"
if not os.path.isdir(orig):
  os.mkdir(orig)

os.rename(dr,"data/"+data+"/orig/"+src+"-"+trg)
os.rename("data/"+data+"/"+src+"-"+trg+"_clean",dr)

