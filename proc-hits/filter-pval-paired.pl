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

my $trs = 0;
my $cnt = 0;
my $min_cnt = 0;
my $min_trk;
my $min_p = 1;
my %ps;

while( my $l = <STDIN> ){

  chomp($l);
   
  my @c = split(/\t/,$l);
  my $wid = $c[0];
  my $p = $c[1];
  my $t = $c[2];
  my $js= $c[3];

  $ps{$p} = $wid;

  if( $p < $min_p){
    $min_p = $p;
    $min_trk = $wid;
  }

  if(($p ne "NaN") && ($p <= 0.05)){
  
    print "$wid\tgood\n";
    $trs++;

    if( $js == 10 ){
      $min_cnt++;
    }
  }else{
    print "$wid\tbad\n";
    
  }
  $cnt++;

}

foreach my $p ( sort {$a <=> $b}  keys %ps){
  print STDERR $ps{$p}.": $p\n";
}

print STDERR "$trs out of $cnt (".sprintf("%0.2f",(($trs*100)/$cnt))."%) good workers\n\n";
print STDERR "$min_cnt completed just a single HIT good workers\n";
print STDERR "$min_trk is most reliable worker with p-value $min_p\n";

