#!/usr/bin/perl -w
use strict;

#                               file     ins        fun        asm        nasm       ecall      necall     lock       nlock      loop       nloop      safe       safel
my $qr = qr/^\s*machine code:\s*(\S+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s+([0-9]+)\s*$/;

my ($ofile, $oins, $ofun, $oasm, $onasm, $oecall, $onecall, $olock, $onlock);
my ($oloop, $onloop, $osafe, $osafel);

my ($sumfile, $sumfun, $sumins1, $sumins2, $sumasm1, $sumasm2);
my ($sumnasm1, $sumnasm2, $sumecall1, $sumecall2, $sumnecall1, $sumnecall2);
my ($sumlock1, $sumlock2, $sumnlock1, $sumnlock2, $sumloop1, $sumloop2);
my ($sumnloop1, $sumnloop2, $sumsafe1, $sumsafe2, $sumsafel1, $sumsafel2);

while (<>) {
	next unless (/$qr/);
	my ($file, $ins, $fun, $asm, $nasm, $ecall, $necall, $lock, $nlock) =
	   ($1,    $2,   $3,   $4,   $5,    $6,     $7,      $8,    $9);
	my ($loop, $nloop, $safe, $safel) =
	   ($10,   $11,    $12,   $13);
	if ($file =~ /\.sliced$/) {
		if ($ofun) {
			print "for $ofile:\n";
			print "  fun: $ofun/$fun\n";
			print "    with asm: $oasm/$asm\n";
			print "      incl nested: $onasm/$nasm\n";
			print "    with call: $oecall/$ecall\n";
			print "      incl nested: $onecall/$necall\n";
			print "    with lock: $olock/$lock\n";
			print "      incl nested: $onlock/$nlock\n";
			print "    with loop: $oloop/$loop\n";
			print "      incl nested: $onloop/$nloop\n";
			print "    safe: $osafe/$safe\n";
			print "    safe w/o loop: $osafel/$safel\n";
		}
		$sumfile++;
		$sumfun += $ofun;
		$sumins1 += $oins;
		$sumins2 += $ins;
		$sumasm1 += $oasm;
		$sumasm2 += $asm;
		$sumnasm1 += $onasm;
		$sumnasm2 += $nasm;
		$sumecall1 += $oecall;
		$sumecall2 += $ecall;
		$sumnecall1 += $onecall;
		$sumnecall2 += $necall;
		$sumlock1 += $olock;
		$sumlock2 += $lock;
		$sumnlock1 += $onlock;
		$sumnlock2 += $nlock;
		$sumloop1 += $oloop;
		$sumloop2 += $loop;
		$sumnloop1 += $onloop;
		$sumnloop2 += $nloop;
		$sumsafe1 += $osafe;
		$sumsafe2 += $safe;
		$sumsafel1 += $osafel;
		$sumsafel2 += $safel;
		next;
	}
	($ofile, $oins, $ofun, $oasm, $onasm, $oecall, $onecall, $olock) =
	 ($file,  $ins,  $fun,  $asm,  $nasm,  $ecall,  $necall,  $lock);
	($onlock, $oloop, $onloop, $osafe, $osafel) =
	 ($nlock,  $loop,  $nloop,  $safe,  $safel);
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
stats("    incl nested", $sumnasm1, $sumnasm2, $sumfun);
stats("  with ext call", $sumecall1, $sumecall2, $sumfun);
stats("    incl nested", $sumnecall1, $sumnecall2, $sumfun);
stats("  with lock", $sumlock1, $sumlock2, $sumfun);
stats("    incl nested", $sumnlock1, $sumnlock2, $sumfun);
stats("  with loop", $sumloop1, $sumloop2, $sumfun);
stats("    incl nested", $sumnloop1, $sumnloop2, $sumfun);
stats("  w/o asm+call", $sumsafe1, $sumsafe2, $sumfun);
stats("  w/o asm+call+loop", $sumsafel1, $sumsafel2, $sumfun);

0;
