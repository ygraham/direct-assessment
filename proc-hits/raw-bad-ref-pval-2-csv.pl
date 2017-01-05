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

while( my $l = <STDIN>){

  chomp($l);
  $l =~ s/\[1\] //;
  $l =~ s/^\"//; 
  $l =~ s/\"$//; 
  my $id = $l;

  $l = <STDIN>;
  chomp($l);
  $l =~ s/\[1\] //;
  $l =~ s/^\"//; 
  $l =~ s/\"$//; 
  my $p = $l;
  
  $l = <STDIN>; # t line
  $l = <STDIN>;
  chomp($l);
  my $t = $l;

  $l = <STDIN>;
  chomp($l);
  $l =~ s/\[1\] //;
  my $j_cnt = $l;
  
  print "$id\t$p\t$t\t$j_cnt\n";
   

}

