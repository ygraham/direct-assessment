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

# take in file with turker good/bad classified
my $item = $ARGV[0];
my $f = $ARGV[1];

my %trusted;
my %bad;

open(F,"<$f") or die "cant open $f\n";

while( my $l = <F>){

  chomp($l);
  my @c = split(/\t/,$l);
  my $wid = $c[0];

  if( $c[1] =~ /good/){
  #if( $c[1] =~ /bad/){
    $trusted{$wid} = 1;
  }else{
    $bad{$wid} = 1;
  }
}

close(F);

my $n = 0;
my $t = 0;
my %missing;

my $l = <STDIN>;
print $l;

while( my $l = <STDIN>){

  my @c = split(/\t/,$l);
  my $wid = $c[1];  

  if($l =~ /$item/){
    if(exists $trusted{$wid}){
      print $l;
      $n++;
    }elsif( ! exists $bad{$wid} ){
      $missing{$wid} = 1;
    }   
  }
  $t++;
}

print STDERR "Retaining $n out of $t (".sprintf("%0.2f",($n*100)/$t)."%) judgments\n";

foreach my $w (sort keys %missing){
  print STDERR "warning: intra judgments missing: $w\n";
}

