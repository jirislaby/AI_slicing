#!/usr/bin/perl -w
use strict;

my $jf = $ARGV[0];
shift;
my $crop = $ARGV[0];
my $croplen = length($crop);
shift;

my %funs;
my %flags;

open(JF, "<$jf") || die "cannot open '$jf'";
while (<JF>) {
	/^{(.*)},{(.*)},{(.*)},{(.*)}$/ || die "bad input";
	my $file = $1;
	if (substr($file, 0, $croplen) eq $crop) {
		$file = substr($file, $croplen);
	}
	$flags{$file} = [ $1, $2, $3, $4 ];
}
close JF;

while (<>) {
	chomp;
	my ($file, $line) = split / /;
	my $arrref = $flags{$file};
	die "not found" unless (defined $arrref);
	my $flags = "gcc -E -w $$arrref[3] $$arrref[0] | ".
		"clang -cc1 -w -analyze -analyzer-checker experimental.core.FunLines|";
	open(FUNS, $flags) || die "cannot exec clang";
	while (<FUNS>) {
		chomp;
		/^(.+): (.+):([0-9]+)-([0-9]+)$/ || die "bad input";
		my $file1 = $2;
		if (substr($file1, 0, $croplen) eq $crop) {
			$file1 = substr($file1, $croplen);
		}
		if ($file eq $file1 && $3 <= $line && $line <= $4) {
			print "$file:$line converted to $1\n"
		}
#		print "$file1: $3-$4 $1\n";
	}
	close FUNS;
}

1;
