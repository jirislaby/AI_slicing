#!/usr/bin/perl -w
use strict;

#                               name     ins        fun        asm        call       lock       loop
my $qr = qr/^\s*machine code:\s*(\S+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s*$/;

my ($ofile, $oins, $ofun, $oasm, $ocall, $olock, $oloop, $osafe, $osafel);

my ($sumfile, $sumfun, $sumins1, $sumins2, $sumasm1, $sumasm2);
my ($sumcall1, $sumcall2, $sumlock1, $sumlock2, $sumloop1, $sumloop2);
my ($sumsafe1, $sumsafe2, $sumsafel1, $sumsafel2);

while (<>) {
	next unless (/$qr/);
	my ($file, $ins, $fun, $asm, $call, $lock, $loop, $safe, $safel) =
	   ($1,    $2,   $3,   $4,   $5,    $6,    $7,    $8,    $9);
	if ($file =~ /\.sliced$/) {
		print "for $ofile:\n";
		print "  fun: $ofun/$fun\n";
		print "    with asm: $oasm/$asm\n";
		print "    with call: $ocall/$call\n";
		print "    with lock: $olock/$lock\n";
		print "    with loop: $oloop/$loop\n";
		print "    safe: $osafe/$safe\n";
		print "    safe w/o loop: $osafel/$safel\n";
		$sumfile++;
		$sumfun += $fun;
		$sumins1 += $oins;
		$sumins2 += $ins;
		$sumasm1 += $oasm;
		$sumasm2 += $asm;
		$sumcall1 += $ocall;
		$sumcall2 += $call;
		$sumlock1 += $olock;
		$sumlock2 += $lock;
		$sumloop1 += $oloop;
		$sumloop2 += $loop;
		$sumsafe1 += $osafe;
		$sumsafe2 += $safe;
		$sumsafel1 += $osafel;
		$sumsafel2 += $safel;
		next;
	}
	($ofile, $oins, $ofun, $oasm, $ocall, $olock, $oloop, $osafe, $osafel) =
	 ($file,  $ins,  $fun,  $asm,  $call,  $lock,  $loop, $safe,  $safel);
}

sub stats($$$$) {
	my ($text, $sum1, $sum2, $sum) = @_;
	printf "$text: $sum1 (%.2f%%) / $sum2 (%.2f%%)\n",
	       100*$sum1/$sum, 100*$sum2/$sum;
}

print "\n\n\n";
print "files: $sumfile\n";
printf "instructions: $sumins1 / $sumins2 (%.2f%% is gone)\n",
       100-100*$sumins2/$sumins1;
print "functions: $sumfun\n";
print "  WHAT: before slicing / after slicing\n";
stats("  with asm", $sumasm1, $sumasm2, $sumfun);
stats("  with call", $sumcall1, $sumcall2, $sumfun);
stats("  with lock", $sumlock1, $sumlock2, $sumfun);
stats("  with loop", $sumloop1, $sumloop2, $sumfun);
stats("  w/o asm+call", $sumsafe1, $sumsafe2, $sumfun);
stats("  w/o asm+call+loop", $sumsafel1, $sumsafel2, $sumfun);

0;
