#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
if(scalar @ARGV !=2){
	print "\nUsage: perl SelectHMM.pl input.txt output.fa\n\n";
	exit;
}
unless ( open(E, "<$ARGV[0]") ) {
	print "Cannot open file \n\n";
	exit;
}
open O,">$ARGV[ 1 ]";
open M,">$ARGV[ 1 ].D1.txt";
my ($s1,$s2,$s3,$s4,$s5,$s6,$s7);
my ($t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8);
my ($q1,$q2,$q3,$q4,$q5);
my $id;
print M "id\tID\tdomainN\tdomainS\tEvalue\n";
$/="== domain";
<E>;
while(<E>){
	chomp;
	my ($s1,$s2,$s3,$s4,$s5,$s6,$s7)=split(/\n/,$_,7);
	my ($t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8)=split(/[\s]+/,$s1,8);
	my ($q1,$q2,$q3,$q4,$q5)=split(/[\s]+/,$s5,5);
	$id=$q2."##D".$t2."S".$t4."E".$t8;
	print O ">$id\n$q4\n";
	print M "$id\t$q2\t$t2\t$t4\t$t8\n";
}
close E;
close O;