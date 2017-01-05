#!/usr/bin/perl;

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


use strict;

my %bad_imgs;
my $CELL_ONE = 31;
my $ANS_CELL = 431;

my $item = $ARGV[0];
my $read_dir = $ARGV[1];
my $wrt_dir = $ARGV[2];

opendir(DIR, $read_dir) or die "cant open $read_dir";
my @fns = readdir(DIR);
my @f;
closedir DIR;

foreach my $s (sort @fns){
  if($s =~ /^(Batch_.*\.csv)/i ){
    my $fn = $1;
    print STDERR "adding: $fn\n";
    push(@f,"$read_dir/$fn");
  }
}

my $n = 0;
my $fn = 0;
my $incomplete = 0;
my $hit_str = "";

foreach my $filename (@f){

  open(F,"<$filename") or die "can't open $filename\n";

  print STDERR "Reading $filename ";

  my $l = <F>; # skip header
  chomp($l);
  #$l =~ s/,\'/,/g;
  #$l =~ s/\',/,/g;

  my @c = split(/\",\"/,$l);

  # print the new header
  if( ($fn==0) && ($n==0) ){
    my @c = split(/\",\"/,$l);

    # SCORES data - one line per judgment
    # HITId	WorkerId	src	trg	item	sys_id	rid	type	sid	score	time	accept	submit
    my $new_hdr = $c[0]."\t".$c[15]."\t".$c[27]."\t".$c[28]."\t".$c[29]."\thit\tsys_id\trid\ttype\tsid\tscore\ttime\n";
    $new_hdr =~ s/\"Input\.//g;
    $new_hdr =~ s/\"//g;
    print $new_hdr;

    # HIT times data - one line per HIT
    $hit_str .= "HITId	WorkerId	src	trg	item	hit work-seconds	accept	submit	approval\n";
  }

  # read through hit results for this file
  while( my $l = <F>){
    chomp($l);
    my @c = split(/\",\"/,$l);
    
    if( $l =~ /undefined/ ){
      print STDERR "bad image skipping hit\n";
      $bad_imgs{$c[15]} = 1;
      next;
    }       

      
    if( scalar(@c) >= 35 ){ # some lines might be present due to turker pressing enter in comment box - this skips those
      my $SL = $c[27];
      my $TL = $c[28];
      my $IT = $c[29];
      my $HIT = $c[30];

      $SL =~ s/'//g;
      $TL =~ s/'//g;
      $IT =~ s/'//g;
      
      my $data = $c[0]."\t".$c[15]."\t$SL\t$TL\t$IT\t$HIT";
      my $time = $c[23];
      
      $time =~ s/\"//g;

      my $approval = $c[16];
      my $accept_time = $c[17];
      my $submit_time = $c[18];
     
      # strip timezone 
      $accept_time =~ s/ [A-Z]* (20[0-9][0-9])$/ $1/;
      $submit_time =~ s/ [A-Z]* (20[0-9][0-9])$/ $1/;

      $data =~ s/\"//g;

      my @dat;
      my $rn=0;
      
      for( my $i=$CELL_ONE; $i<($CELL_ONE+400); $i=$i+4){

          my $sys_id = $c[$i];
          my $sid    = $c[$i+1];
          my $type   = $c[$i+2];
          my $rid    = $c[$i+3];
    
          $sys_id =~ s/^\"//;
          $sid =~ s/^\"//;
          $rid =~ s/^\"//;
          $type =~ s/^\"//;
          $sys_id =~ s/\"$//;
          $type =~ s/\"$//;
          $rid =~ s/\"$//;
          $sid =~ s/\"$//; 

          $dat[$rn] = "$sys_id\t$rid\t$type\t$sid\t";

          $n++;
          $rn++;
      }
        
      # parse the answer data
      my $complete = 0;
      my $ans_str = $c[$ANS_CELL];
      my @a = split(/\|/,$ans_str);
      my @scr;

      if( scalar(@a) == 100 ){    
        $complete = 1;  
      }else{    
	print STDERR "\nHIT incomplete (size=".scalar(@a).") : $data\n"; $incomplete++;  
      }

      if( $complete ){
          for( my $i=0; $i<100; $i++){
            $a[$i] =~ s/^\"//;
            $a[$i] =~ s/\"$//;
            $a[$i] =~ s/BAD_REF/BAD-REF/;
            my @inf = split(/_/,$a[$i]);

            # sysid+"_"+sid+"_"+tst+"_"+index+"_"+"_"+document.getElementById("amount").value

            my $sys = $inf[0];
            my $sid = $inf[1];
            my $tst = $inf[2];
            my $ind = $inf[3];
            my $score = $inf[4];

            if( scalar(@inf)==6){
              $score = $inf[5];
            }
            $tst =~ s/BAD-REF/BAD_REF/;

            my $seg_dat = "$sys\t$ind\t$tst\t$sid\t";

            if((scalar(@inf) != 5)&&(scalar(@inf) != 6)){ 
              print STDERR "error in answer".$a[$i]." \n"; 
              exit 1; 
            }

            print $data."\t".$seg_dat.$score."\t$time\n";
          }


#          for( my $i=0; $i<100; $i++ ){
            #print $data."\t".$dat[$i].$scr[$i]."\t$time\n";
 #         }    

	      # HIT data
          $c[0] =~ s/\"//g;

          my $SL = $c[27];
          my $TL = $c[28];
          my $IT = $c[29];
          my $HIT = $c[30];

          $SL =~ s/'//g;
          $TL =~ s/'//g;
          $IT =~ s/'//g;

          $hit_str .= $c[0]."\t".$c[15]."\t$SL\t$TL\t$IT\t$HIT\t$time\t\"$accept_time\"\t\"$submit_time\"\t$approval\n";
      }
      $n++; 
    }
  }

  print STDERR "... processed $n translations so far\n";
  close(F);

  $fn++;
}

print STDERR "$incomplete HITS omitted due to being incomplete\n";

foreach my $w (keys %bad_imgs){
  print STDERR "bad image for: $w\n";
}

my $f = "$wrt_dir/$item-hit-time.csv";
open(F,">$f") or die "error cant open $f\n";
print F $hit_str;
close(F);

