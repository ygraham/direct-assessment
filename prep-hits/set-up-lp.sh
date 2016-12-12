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

SRC=$1
TRG=$2
DATA=$3
ITEM=$4

REF_DIR=data/references
WRITE_DIR=out
IMG_DIR=$WRITE_DIR/img/$ITEM
REF_IMG_DIR=$WRITE_DIR/img/ref/$TRG
BR_DIR=$WRITE_DIR/bad-ref/$ITEM/$SRC-$TRG

mkdir -p $IMG_DIR
mkdir -p $REF_IMG_DIR
mkdir -p $BR_DIR
mkdir -p out/bad-ref/ad/$SRC-$TRG/subwrds

EXP_FN=$WRITE_DIR/$ITEM\.$SRC-$TRG

#python rename.py $SRC $TRG $DATA

#python clean.py $SRC $TRG $DATA
python create-ref-img.py $SRC $TRG $DATA
python gen-100-item-sets.py $SRC $TRG $DATA > $EXP_FN
python gen-mturk-csv.py $SRC $TRG $ITEM
python sub-wrds.py data/$DATA $SRC $TRG $DATA $BR_DIR
python bad-refs.py data/$DATA $SRC $TRG $DATA $BR_DIR
python create-img.py $SRC $TRG data/$DATA/$SRC-$TRG $BR_DIR $REF_DIR $IMG_DIR $DATA $EXP_FN

#export MOSESROOT=~/tools/mosesdecoder
#CAN=out/img/$ITEM/$SRC-$TRG/snt_log
#REF=out/img/$ITEM/$SRC-$TRG/ref_log
#perl ~/tools/mosesdecoder/scripts/tokenizer/tokenizer.perl -l $TRG < $CAN > $CAN\.tok
#perl ~/tools/mosesdecoder/scripts/tokenizer/tokenizer.perl -l $TRG < $REF > $REF\.tok
#cat $CAN\.tok |$MOSESROOT/mert/sentence-bleu $REF\.tok > out/img/$ITEM/$SRC-$TRG/snt_bleu
#python add-bleu-log.py $SRC $TRG ad



