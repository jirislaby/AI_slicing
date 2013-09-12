#!/usr/bin/perl -w
use strict;
use XML::XPath;
use Getopt::Std;

my $tool_name = "Stanse";
my $tool_ver = "1.2";

my $dest_proj = "Linux Kernel";
my $dest_proj_ver = "2.6.28";
my $user = "jirislaby";

my $cmdline_err = "wrong commandline. should be:\n" .
	"$0 stanse_error_type src.xml " .
	"[-c string to crop from paths] [-m conversion file]";

die $cmdline_err if (scalar @ARGV < 2);

my $stanse_error_type = shift; # short_desc in XML
my $in = shift;
my %opts;
if (!getopts("c:m:", \%opts) || scalar @ARGV) {
	die $cmdline_err;
}

my $crop = $opts{'c'};
my $conv = $opts{'m'};
my %conv_map;

if (defined $conv) {
	print STDERR "Using '$conv' as conv file\n";
	open(CONV, $conv) || die "cannot open $conv";
	while (<CONV>) {
		chomp;
		die "invalid conv file" unless (/^(.+) ([0-9]+) (.+) ([0-9]+)$/);
		$conv_map{"$1\x00$2"} = "$3\x00$4";
	}
	close CONV;
}

my $xp = XML::XPath->new(filename => "$in") || die "can't open $in";

my $croplen = defined($crop) ? length($crop) : 0;
my $xp1 = XML::XPath->new();

#	} elsif ($return_loc && $#loc > 0) {
#		my $retloc = $loc[-2];
#		my $file = $retloc->findvalue("unit");
#		my $line = $retloc->findvalue("line")->value;
#		open(LOC, "<", "$file") || die "cannot open $file";
#		my @lines = <LOC>;
#		close LOC;
#		return ($lines[$line - 1] =~ /\breturn\b/) ? $retloc : $loc[-1];

my $errors = $xp->findnodes("/database/errors/error");

my $undef_conv = 0;

sub get_loc($) {
	my $loc = shift;

	my $unit = $loc->findvalue("unit");
	if ($croplen && substr($unit, 0, $croplen) eq $crop) {
		$unit = substr($unit, $croplen);
	}
	$unit =~ s@/\.tmp_@/@;
	$unit =~ s@\.o\.preproc$@.c@;
	my $line = $loc->findvalue("line");
	return ($unit, $line) unless (defined $conv);

	my $entry = $conv_map{"$unit\x00$line"};
	if (!defined $entry) {
		$undef_conv = 1;
		print STDERR "no entry for $unit:$line in conv map\n";
		return ($unit, "X${line}X");
	}
	return split /\x00/, $entry;
}

foreach my $error ($errors->get_nodelist) {
	my $short_desc = $error->findvalue("short_desc");
	next if ($short_desc ne $stanse_error_type);

	my $fp_bug = 0;
	$fp_bug++ if ($xp1->exists("real-bug", $error));
	$fp_bug-- if ($xp1->exists("false-positive", $error));

	my @locs = $error->findnodes("traces/trace[1]/locations/location");
	foreach my $loc (@locs) {
		my ($unit, $line) = get_loc($loc);
		my $type;
		if ($loc->findvalue("description") =~ /^<context>/) {
			$type = "C";
		} elsif (0) {
			$type = "R";
		} else {
			$type = "O";
		}
		print "$type $unit $line ";
	}
	print "$fp_bug\n";
}

$errors = undef;

die "some conversion entries not found" if ($undef_conv);

1;
