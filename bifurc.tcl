#!/usr/bin/env tclsh
#

set npoints 1024;
set niter 1000;

set fout [open "out.dat" "w"];
for {set r 0} {$r<4} {set r [expr {$r+0.001}]} {
	set fp [open "|./bifurc $r $npoints $niter" r];
	set vals [split [string trim [read $fp]] \n];
	foreach v $vals {
		puts $fout "$r $v"
	}
	close $fp;
}
close $fout;
