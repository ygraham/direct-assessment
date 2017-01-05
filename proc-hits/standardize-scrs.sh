#!/bin/bash
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

function die() { echo "$@" >&2; exit 1; }
set -o pipefail  # safer pipes
set -e # die on any error


src=$1
trg=$2
wdir=analysis

R --no-save --args ad $src $trg $wdir < trk-mean-sd.R
perl standardize-scrs.pl $wdir/ad-$src$trg-trk-mean-sd.txt $src $trg < $wdir/ad-good-raw.csv > $wdir/ad-$src$trg-good-stnd.csv



