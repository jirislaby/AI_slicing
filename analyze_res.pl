#!/usr/bin/perl
use strict;
use Data::Dumper;

my $res = shift;
my $starting = shift;
my %files;

open(RES, "<$res") || die "cannot open $res";
while (<RES>) {
	die "invalid input in $res" unless (/^([A-Z]+) (\.\/)?(.*)$/);
	my $state = $1;
	my $file = $3;
	$file =~ s/\.log$//;
	if ($state eq 'X') {
		$files{$file} = -1;
	} elsif ($state =~ /B/) {
		$files{$file} = 1;
	} else {
		$files{$file} = 0;
	}
}
close RES;

#print %files, "\n";

my $main = undef;
my ($cnt, $bugs, $fp);

sub handle() {
	return unless (defined $main);
	if ($cnt == $bugs || $cnt == $fp) {
		print "SUM $main: ", $cnt == $bugs ? "BUG" : "FALSE", "\n";
	}
}

open(START, "<$starting") || die "cannot open $starting";
while (<START>) {
	if (/^A (.*) (.*)$/) {
		my $file = $1;
		my $fun = $2;
		handle();
		$main = "$1 $2";
#		print "\nXXX $main\n";
		$cnt = $bugs = $fp = 0;
	} elsif (/^B (.*)$/) {
		my $file = $1;
#		print "B $file", defined $files{$file} ? " $files{$file}" : "",
#		      "\n";
		if (defined $files{$file}) {
			if ($files{$file} < 0) {
				$fp++;
			} elsif ($files{$file} > 0) {
				$bugs++;
			}
		}
		$cnt++;
	} else {
		die "invalid input in $starting";
	}
}
close START;

handle();

1;
