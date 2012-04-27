#!/usr/bin/env tclsh
#

proc bifurc {r npoints niter} {
	set fp [open "|./bifurc $r $npoints $niter" r];
	set vals [split [string trim [read $fp]] \n];
	close $fp;
	return $vals;
}

proc bifurc_range {r0 r1 rinc npoints niter} {
	for {set r $r0} {$r<$r1} {set r [expr {$r+$rinc}]} {
		set vals [bifurc $r $npoints $niter];
		lappend result $r $vals;
	}
	return $result;
}

set npoints 64;
set niter 1000;

set fout [open "out.dat" "w"];
set result [bifurc_range 2 4 0.01 $npoints $niter];
foreach {r vals} $result {
	foreach v $vals {
		puts $fout "$r $v"
	}
}
close $fout;
