#!/usr/bin/perl -w
use strict;

my $jf = $ARGV[0];
shift;
my $chop = $ARGV[0];
shift;

my %flags;

open(JF, "<$jf") || die "cannot open '$jf'";
while (<JF>) {
	/^{(.*)},{(.*)},{(.*)},{(.*)}$/ || die "bad input";
	my $file = $1;

	$flags{$1} = [ $1, $2, $3, $4 ];
}
close JF;

while (<>) {
	chomp;
	my ($file, $line) = split / /;
	print "$file XX $line\n";
}

1;
