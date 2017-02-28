# SelectHMM
Select large-scale sequences of candidates from HMMER results
To use the SelectHMM, you should pre-install the HMMsearch, and install SelectHMM.pl as well as ExtractSequence.pl in the same dir.

Usage: perl SelectHMM.pl input.fa HMMfile.
Input file should be Genome-Protein with fasta format.
HMMfile is a HMM model built by programe HMMbuild.

If you use the data obtained by SelectHMM, please cite in your paper: "Zhang TK, Liu CY, Zhang HY, Yuan ZH (2017).An integrated approach to identify Cytochrome P450 superfamilies in plant species within the Malvids. In: Proceedings of 2017 5th international conference on bioinformatics and computational biology. Zhang D edz. New York: ACM. Pp.11-16.".
Any question about SelectHMM, can contact me through the email (taikuizhang@126.com).
