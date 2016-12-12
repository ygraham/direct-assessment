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
DATA = sys.argv[3]

# from: newstest2016.cu-mergedtrees.4515.cs-en
# to:   newstest2016.cs-en.cu-mergedtrees

f = "data/"+DATA+"/"+src+"-"+trg+"/*"

fns = glob.glob(f)

for fn in fns:

  name = fn.replace("data/"+DATA+"/"+src+"-"+trg+"/"+DATA+".","")
  i = name.find(".")

  name = name[0:i]

  newfn = "data/"+DATA+"/"+src+"-"+trg+"/"+DATA+"."+src+"-"+trg+"."+name

  print(fn)
  print(newfn)
  print("")

  os.rename(fn,newfn)


