#!/usr/bin/env tclsh

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


set options(-npoints) 64;
set options(-niter) 1000;
set options(-rstart) 3.0
set options(-rend) 4.0
set options(-rinc) 0.01
set options(-o) "out.dat"

array set options $argv;

set result [bifurc_range \
  $options(-rstart) \
	$options(-rend)  \
	$options(-rinc) \
	$options(-npoints) \
	$options(-niter)];

set fout [open $options(-o) "w"];
foreach {r vals} $result {
	foreach v $vals {
		puts $fout "$r $v"
	}
}
close $fout;
