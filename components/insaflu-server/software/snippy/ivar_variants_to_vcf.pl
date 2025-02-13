#!/usr/bin/env perl
use warnings;
use strict;
use Data::Dumper;
use Bio::Tools::GFF;
use Bio::SeqIO;
use Fatal;

# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# Command line checking

my(@Options, $tab, $ref);
setOptions();

$tab or die "need --tab <snps_in.tab>";
$ref or die "need --ref <ref.fa>";

# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# Create an index of seq:pos => feature

my %seq;
print STDERR "Loading reference: $ref\n";
my $fa = Bio::SeqIO->new(-file=>$ref, -format=>'fasta');
while (my $seq = $fa->next_seq) {
  $seq{ $seq->id } = $seq;
}
my $nseq = scalar keys %seq;
print STDERR "Loaded $nseq sequences.\n";

my $toref = $ref;
$toref =~ s/.*\///;

my $header = "##fileformat=VCFv4.2\n";
$header .= "##source=iVar\n";
$header .= "##reference=file://".$toref."\n";
# Now add the reference contig info...
foreach my $contig (keys %seq){
   $header .= "##contig=<ID=".$contig.",length=".length($seq{ $contig }->seq ).">\n"; 
}

$header .= "##INFO=<ID=DP,Number=1,Type=Integer,Description=\"Total Depth\">\n";
$header .= "##INFO=<ID=RO,Number=1,Type=Integer,Description=\"Depth of reference base\">\n";
$header .= "##INFO=<ID=AO,Number=A,Type=Integer,Description=\"Depth of alternate base\">\n";
#$header .= "##INFO=<ID=FREQ,Number=1,Type=String,Description=\"Frequency of alternate base\">\n";
$header .= "##INFO=<ID=TYPE,Number=1,Type=String,Description=\"Type of variant\">\n";
$header .= "##FILTER=<ID=PASS,Description=\"Result of p-value <= 0.05\">\n";
$header .= "##FILTER=<ID=FAIL,Description=\"Result of p-value > 0.05\">\n";
$header .= "##FORMAT=<ID=GT,Number=1,Type=String,Description=\"Genotype\">\n";
$header .= "##FORMAT=<ID=REF_DP,Number=1,Type=Integer,Description=\"Depth of reference base\">\n";
$header .= "##FORMAT=<ID=REF_RV,Number=1,Type=Integer,Description=\"Depth of reference base on reverse reads\">\n";
$header .= "##FORMAT=<ID=REF_QUAL,Number=1,Type=Integer,Description=\"Mean quality of reference base\">\n";
$header .= "##FORMAT=<ID=ALT_DP,Number=A,Type=Integer,Description=\"Depth of alternate base\">\n";
$header .= "##FORMAT=<ID=ALT_RV,Number=A,Type=Integer,Description=\"Depth of alternate base on reverse reads\">\n";
$header .= "##FORMAT=<ID=ALT_QUAL,Number=A,Type=String,Description=\"Mean quality of alternate base\">\n";
$header .= "##FORMAT=<ID=ALT_FREQ,Number=A,Type=String,Description=\"Frequency of alternate base\">\n";
my $sample = $tab;
$sample =~ s/.*\///;
$sample =~ s/.tsv//;
$header .= "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t".$sample."\n";

print STDOUT $header;

my $count=0;

# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
# Create a VCF from SNP table file

my %detected;

open(FILE, $tab);
while(<FILE>){
    next if /^REGION/;
    chomp;
    my @line = split(/\t/);
    my $CHROM = $line[0];
    my $POS = $line[1];
    my $ID =  '.';
    my $REF = $line[2];
    my $ALT = $line[3];
    
    my $var_type = 'snp';
    if($ALT =~ /^\+/){
        $ALT =~ s/^\+//;
        $ALT = $REF.$ALT;
        $var_type = 'ins';
    } 
    if($ALT =~ /^\-/){
        $ALT =~ s/^\-//;
        $REF .= $ALT;
        $ALT = $line[2];
        $var_type = 'del';
    }  
    if(($var_type eq 'snp') && (length($ALT)>1)){
        #$var_type = 'mnp';
        $var_type = 'complex';
    }   
    my $curvar = $CHROM."_".$POS."_".$REF."_".$ALT;
    next if(defined($detected{$curvar}));

    my $QUAL = '.';

    my $pass_test = $line[13];
    my $FILTER = 'PASS';
    if($pass_test ne 'TRUE'){
        $FILTER = 'FAIL';
    }
    #my $INFO='DP='.$line[11].";RO=".$line[4].";AO=".$line[7].";FREQ=".sprintf("%.2f", 100.0*$line[10]);
    my $INFO='DP='.$line[11].";RO=".$line[4].";AO=".$line[7].";TYPE=".$var_type;
    my $FORMAT = 'GT:REF_DP:REF_RV:REF_QUAL:ALT_DP:ALT_RV:ALT_QUAL:ALT_FREQ';
    my $SAMPLE='1:'.$line[4].':'.$line[5].':'.$line[6].':'.$line[7].':'.$line[8].':'.$line[9].':'.sprintf("%.2f", $line[10]);
    my $oline = $CHROM."\t".$POS."\t".$ID."\t".$REF."\t".$ALT."\t".$QUAL."\t".$FILTER."\t".$INFO."\t".$FORMAT."\t".$SAMPLE."\n";

    print STDOUT $oline;

    $detected{$curvar} = 1;
    $count++;
}
close FILE;
print STDERR "Converted $count SNPs to TAB format.\n";



#----------------------------------------------------------------------
# Option setting routines

sub setOptions {
  use Getopt::Long;

  @Options = (
    {OPT=>"help!",     VAR=>\&usage,                DESC=>"This help"},
    {OPT=>"tab=s",     VAR=>\$tab,     DEFAULT=>'', DESC=>"Tab input file"},
    {OPT=>"ref=s",     VAR=>\$ref,     DEFAULT=>'', DESC=>"FASTA reference sequence"},
  );

  (!@ARGV) && (usage());

  &GetOptions(map {$_->{OPT}, $_->{VAR}} @Options) || usage();

  # Now setup default values.
  foreach (@Options) {
    if (defined($_->{DEFAULT}) && !defined(${$_->{VAR}})) {
      ${$_->{VAR}} = $_->{DEFAULT};
    }
  }
}

sub usage {
  print STDERR "Synopsis:\n  Convert a TSV into VCF\n";
  print STDERR "Usage:\n  $0 [options] --ref ref.fa --tab snps_in.tab > snps_out.vcf\n";
  print STDERR "Options:\n";
  foreach (@Options) {
    printf STDERR "  --%-13s %s%s.\n",$_->{OPT},$_->{DESC},
                  defined($_->{DEFAULT}) ? " (default '$_->{DEFAULT}')" : "";
  }
  exit(1);
}
 
#----------------------------------------------------------------------
