#!/usr/bin/env tclsh

proc get_random {low high} {
	expr {int(($high-$low)*rand())+$low};
}

proc guess_a_number {n1 n2} {
	set low [expr {min($n1,$n2)}];
	set high [expr {max($n1,$n2)}];
	set num [get_random $low $high];
	puts "Guess a number between $low and $high:";
	puts -nonewline "Your guess: "; flush stdout;

	while {[gets stdin line]>0} {
		if {$line=="quit"} {
			exit;
		} elseif {[string length $line]>0 && ![string is integer $line]} {
			puts "Please guess an integer!"
		} elseif {$line==$num} {
			puts "You got it!"; break;
		} elseif {$line<$num} {
			puts "Too low."
		} elseif {$line>$num} {
			puts "Too high."
		}
		puts -nonewline "Your guess: "; flush stdout;
	}
}

guess_a_number [lindex $argv 0] [lindex $argv 1];
