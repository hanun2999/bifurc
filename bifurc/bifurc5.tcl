#!/usr/bin/env tclsh
package require Tk;

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
set options(-rinc) 0.002
set options(-o) "out.dat"

proc build_gui {w} {
	frame $w;
	set i 0;
	foreach n {-npoints -niter} {
		set l [label $w.l$n -text [string trim $n "-"]];
		set b [spinbox $w.b$n -textvariable options($n) -from 64 -to 1024 -increment 64 -width 5];
		grid $l -row $i -column 0 -sticky nw;
		grid $b -row $i -column 1 -sticky new;
		incr i;
	}
	
	foreach n {-rstart -rend -rinc} {
		set l [label $w.l$n -text [string trim $n "-"]];
		set b [spinbox $w.b$n -textvariable options($n) -from 0.0001 -to 3.99 -increment 0.0001 -width 6];
		grid $l -row $i -column 0 -sticky nw;
		grid $b -row $i -column 1 -sticky new;
		incr i;
	}
	
	set l [label $w.lfile -text "Output file:"]
	set e [entry $w.efile -textvariable options(-o) -width 64];
	grid $l -row $i -column 0 -sticky nw;
	grid $e -row $i -column 1 -sticky new;
	incr i;
	
	set b [button $w.bdoit -text "Do it!" -command do_it];
	grid $b -row $i -column 0 -columnspan 2 -sticky nsew;
	return $w;
}

proc do_it {} {
	global options;
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
	if {[info exists ::gnuplot] && [string length $::gnuplot]>0} {
		plot_it $::gnuplot;
	}
}

proc connect_to_gnuplot {} {
	set fp [open "|gnuplot" w];
	return $fp;
}

proc plot_it {fp} {
	global options;
	puts $fp "plot '$options(-o)' using 1:2 with dots;";
	flush $fp;
}

set gnuplot [connect_to_gnuplot];
build_gui .f
pack .f

array set options $argv;

