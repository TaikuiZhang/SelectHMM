#!/usr/bin/perl -w
use strict;
use warnings;
use diagnostics;
use FindBin qw($Bin $Script);
use File::Copy;

if(scalar @ARGV !=2){
	print "\nUsage: perl SelectHMM.pl input.fa HMMfile\n";
	print "\nInput file should be Genome-Protein with fasta format.\n";
	print "\nHMMfile is a HMM model built by programe HMMbuild.\n";
	print "\nHMMSearch should be pre-installed.\n";
	print "\nExtractSequence.pl should be installed in the same dir as SelectHMM.pl.\n";
	exit;
}
unless ( open(E, "<$ARGV[0]") ) {
	print "Cannot open file \n\n";
	exit;
}
mkdir('SelectHMM_Out');

my $t=0;

#Reformat Genome Sequences
my $gfile=(split(/.fa/,$ARGV[ 0 ]))[0];
$gfile=$gfile."_ref.fasta";
open M,">$gfile";
open N,">BadID_list.txt";
my ($id,$seq);
$/=">";
my $b=0;
<E>;
while(<E>){
	chomp;
	my ($id,$seq)=split(/[\n\r]+/,$_,2);
	$id=(split(/\s+/,$id))[0];
	$seq=~s/\n//g;
	if ($seq =~ /X/) {
	print N "$id\n";
	$b++;
	}
	else {
		print M ">$id\n$seq\n";
	}
}
close E;
close N;
close M;
print "\nCheck Genome-Protein Sequences: Done\n";
if ($b>0) {
    print "\nBad set of $b sequences with 'X' were filted out, and the bad IDs were list in BadID_list.txt.\n";
	move("BadID_list.txt", "SelectHMM_Out");
	$t++;
}
else {
	system("rm -f BadID_list.txt");
}
print "\nCheck Genome-Protein Sequences: Done.\n";

#HMMsearch
my $file=(split(/.hmm/,$ARGV[ 1 ]))[0];
$file=$file."_hmmout.txt";
open P1,">$file";
system("hmmsearch $ARGV[ 1 ] $gfile >$file");
print "\nHMMsearch: Done.\n";
close P1;

open P,"<$file";
open O,">$file.Stat.txt";
open L,">list.txt";
my ($s1,$s2,$s3,$s4,$s5,$s6,$s7);
my ($t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8);
my ($q1,$q2,$q3,$q4,$q5);
print O "ID\tdomainN\tdomainS\tEvalue\n";
$/="== domain";
<P>;
while(<P>){
	chomp;
	my ($s1,$s2,$s3,$s4,$s5,$s6,$s7)=split(/\n/,$_,7);
	my ($t1,$t2,$t3,$t4,$t5,$t6,$t7,$t8)=split(/[\s]+/,$s1,8);
	my ($q1,$q2,$q3,$q4,$q5)=split(/[\s]+/,$s5,5);
	chomp($q2);
	print O "$q2\t$t2\t$t4\t$t8\n";
	print L "$q2\n";
}
close O;
close P;
close L;
print "\nSummary HMMStat: Done.\n";
move("$file.Stat.txt", "SelectHMM_Out");
$t++;
open(R, ">Final_Protein.fa") or die $!;
system ("perl ExtractSequence.pl $gfile Final_Protein.fa") || die("\nExtractSequence.pl should be installed in the same dir as SelectHMM.pl.$!\n");
close R;

move("Final_Protein.fa", "SelectHMM_Out");
$t++;


print "\nSelectHMM: Done.\n";
print "\nIn dir SelectHMM_Out, you can find:\n";

if ($t eq 2) {
	print "a.Final_Protein.fa #Target sequence \n";
	print "b.$file.Stat.txt #HMM-Stat file \n";
	system("rm -f $gfile");
}
if ($t eq 3) {
    print "a.Final_Protein.fa #Target sequence \n";
	print "b.$file.Stat.txt #HMM-Stat file \n";
	print "c.$gfile #Genome file \n";
	print "d.BadID_list.txt #Filted File \n";
	move("$gfile", "SelectHMM_Out");
}
system("rm -f list.txt");
system("rm -f $file");

print "\nUse the data obtained by SelectHMM, please cite in your paper:\n";
print "\nZhang TK, Liu CY, Zhang HY, Yuan ZH (2017).An integrated approach to identify Cytochrome P450 superfamilies in plant species within the Malvids. In: Proceedings of 2017 5th international conference on bioinformatics and computational biology. Zhang D edz. New York: ACM. Pp.11-16.\n\n";
