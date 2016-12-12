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
import os
from txt2img import text2png

src = sys.argv[1]
trg = sys.argv[2]
data = sys.argv[3]

#f = "data/references/"+data+"-ref."+trg
# newstest2015-enru-ref.ru
f = "data/references/"+data+"-"+src+trg+"-ref."+trg
items = [line.rstrip('\n') for line in open(f)]
imgdir = "out/img/ref/"+src+"-"+trg

if not os.path.isdir( imgdir):
  os.makedirs( imgdir) 
 
for i in xrange(0,len(items)):
  
  imgtxt = items[i]
  imgfn = imgdir+'/'+str(i+1)+'.png'  
  text2png(imgtxt, imgfn, fontfullpath = "arial.ttf", color = '#708090') 

