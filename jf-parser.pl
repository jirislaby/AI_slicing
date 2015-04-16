#!/usr/bin/perl -w
use strict;
use File::Temp;

my $cc = $ENV{REAL_CC} || 'gcc';

while (<>) {
	chomp;
	/^{(.*)},{(.*)},{(.*)},{(.*)}$/ || die "bad input";
	my $file = $1;
	my $out = $2;
	my $workdir = $3;
	my $flags = $4;
	chdir $workdir;
#	my $filesan = $file;
#	$filesan =~ s@/@_@g;
#	my $tmph = File::Temp->new(TEMPLATE => "${filesan}XXXXXXX");
#	my $tmp = $tmph->filename; # -o $tmp here:
	$flags = "$cc -E -w $flags $file";
#	my @args = ("gcc", "-E", "-w", "-o", $tmp->filename);
#	my $tn = 0;
#	foreach (split/ /, $flags) {
#		if ($tn || /^-[DIU]/) {
#			push @args, $_;
#			$tn = 0;
#		}
#
#		if (/^-include/) {
#			push(@args, $_);
#			$tn = 1;
#		}
#	}
#	push @args, $file;
#	print "$flags\n";
#	system $args[0], @args;

#	system $flags;
#	system "cppcheck --enable=all $tmp";

	$out =~ s/\.o/.i/;
	print "$flags -o $out\n";
	system "$flags -o $out";
}

1;
