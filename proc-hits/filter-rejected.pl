#/usr/bin/perl;

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

my $f = $ARGV[0];
open(F,"<$f") or die "cant open $f\n";
my @wrkr_info = <F>;
close(F);

my %rejected;

foreach my $wl (@wrkr_info){

	my @c = split(/\ /,$wl);
	my $wid = $c[0];
	my $reject_rate = $c[10];

	print STDERR $c[0]." ".$c[10]."\n";

	if( $reject_rate > 0 ){
		$rejected{$wid} = 1;
	}
}

while( my $l = <STDIN>){

	my @c = split(/\t/,$l);
	my $wid = $c[1];

	if( ! exists $rejected{$wid} ){
		print $l;	
	}
}

