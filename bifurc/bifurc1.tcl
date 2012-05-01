#!/usr/bin/env tclsh
#

set npoints 256;
set niter 1000;

set fout [open "out.dat" "w"];
for {set r 2.5} {$r<4} {set r [expr {$r+0.002}]} {
	set fp [open "|./bifurc $r $npoints $niter" r];
	set vals [split [string trim [read $fp]] \n];
	foreach v $vals {
		puts $fout "$r $v"
	}
	close $fp;
}
close $fout;
