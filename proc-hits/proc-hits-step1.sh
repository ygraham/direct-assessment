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

rdir=batched-hits
wdir=analysis

mkdir -p $wdir

perl hits2r.pl ad $rdir $wdir > $wdir/ad-latest.csv
wc -l $wdir/ad-latest.csv

R --no-save --args $wdir ad < concurrent-hits.R
R --no-save --args $wdir ad < wrkr-times.R
perl filter-rejected.pl $wdir/ad-wrkr-stats.csv < $wdir/ad-latest.csv > $wdir/ad-approved.csv
python repeats.py $wdir/ad-approved.csv > $wdir/ad-repeats.csv
R --no-save --args $wdir < quality-control.R
perl raw-bad-ref-pval-2-csv.pl < $wdir/ad-trk-stats.txt > $wdir/ad-trk-stats.csv
perl filter-pval-paired.pl < $wdir/ad-trk-stats.csv > $wdir/ad-trk-stats.class
perl filter-latest.pl ad $wdir/ad-trk-stats.class < $wdir/ad-approved.csv > $wdir/ad-good-raw.csv
python repeats.py $wdir/ad-good-raw.csv > $wdir/ad-good-raw-repeats.csv

