#!perl
use warnings;
use diagnostics;
if(scalar @ARGV !=2){
	print "\nUsage: perl ExtractSequence.pl input.fa output.fa\n\n";
	exit;
}
unless ( open(M, "<$ARGV[0]") ) {
	print "Cannot open file \n\n";
	exit;
}
open N,">$ARGV[ 1 ]";
open F,"<list.txt";
my %hash ;
while (<F>) {
  $_=/(\S+)/;
  $hash{$1} =1;
}
$n=0;
while (<M>) {
  if (/>(\S+)/) {
    if ($hash{$1}) {
      print N $_;
      $n=1;
    }
    else{$n=0}
  }
  else{
    if($n==1){print N $_;}
  }
}
close F;
close M;
close N；
