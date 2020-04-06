#!/usr/bin/env perl
 
# Converts an alignment to another alignment format
# Run with no arguments or with -h for help.
# author: Lee Katz <lkatz@cdc.gov>
 
use Bio::AlignIO;
use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use List::Util qw/max/;
 
sub logmsg{print "@_\n";};
exit(main());
 
sub main{
  my $settings={};
  die usage() if(@ARGV<1);
  GetOptions($settings,qw(infile=s ginformat=s outfile=s format=s concatenateAlignment linker=s));
  die usage() if($$settings{help});
 
  my $infile=$$settings{infile} or die "Error: Need infile param:\n".usage();
  my $outfile=$$settings{outfile} or die "Error: Need outfile param:\n".usage();
  $$settings{outfileformat}=$$settings{format} || "fasta";
  $$settings{linker}||="";
 
  convertAln($infile,$outfile,$settings);
 
  logmsg "Output is now in $outfile";
  return 0;
}
 
sub convertAln{
  my($infile,$outfile,$settings)=@_;
  $$settings{infileFormat}=$$settings{ginformat}||guess_format($infile,$settings);
  my $numAlns;
  if($outfile=~/\/$/){
    $numAlns=convertAlnToDir($infile,$outfile,$settings);
  } else {
    $numAlns=convertAlnToFile($infile,$outfile,$settings);
  }
  logmsg "Finished converting $infile to $outfile ($numAlns alignments)";
  return $numAlns;
}
 
sub convertAlnToDir{
  my($infile,$outdir,$settings)=@_;
  $outdir=~s/\/+$//; # remove the trailing slash
  logmsg "Converting $infile ($$settings{infileFormat}) to a directory $outdir ($$settings{outfileformat})";
  mkdir($outdir) if(!-d $outdir);
  my $in=Bio::AlignIO->new(-file=>$infile,-format=>$$settings{infileFormat});
  my $alnCounter=0;
  my $outExtension=$$settings{outfileformat};
  while(my $aln=$in->next_aln){
    my $out=Bio::AlignIO->new(-file=>">$outdir/".++$alnCounter.$outExtension,-format=>$$settings{outfileformat});
    $out->write_aln($aln);
  }
  return $alnCounter;
}
 
sub convertAlnToFile{
  my($infile,$outfile,$settings)=@_;
  logmsg "Converting $infile ($$settings{infileFormat}) to file $outfile";
  my $in=Bio::AlignIO->new(-file=>$infile,-format=>$$settings{infileFormat});
  my $out=Bio::AlignIO->new(-file=>">$outfile",-format=>$$settings{outfileformat});
  my $alnCounter=0;
  if($$settings{concatenateAlignment}){
    my @expectedId=findAllUniqueIdsInAln($infile,$settings);
    my %alnSequence;
    while(my $aln=$in->next_aln){
      # concatenate sequences
      foreach my $seq($aln->each_seq){
        $alnSequence{$seq->id}.=$seq->seq.$$settings{linker};
      }
 
      # keep the alignment flush, even if I have to add gaps
      my $currentAlnLength=max(map(length($_),values(%alnSequence)));
      for(@expectedId){
        my $lackOfSequence=$currentAlnLength-length($alnSequence{$_});
        $alnSequence{$_}.='-'x$lackOfSequence;
      }
    }
 
    # write the complete alignment to a file
    my $concatAln=Bio::SimpleAlign->new();
    for(@expectedId){
      my $stringfh;
      open($stringfh, "<", \$alnSequence{$_}) or die "Could not open string for reading: $!";
      my $seq=new Bio::LocatableSeq(-seq=>$alnSequence{$_},-id=>$_); # must be locatableSeq to be added
      $concatAln->add_seq($seq);
    }
    $out->write_aln($concatAln);
  } else { # it's pretty simple to just do a conversion to a different file
    while(my $aln=$in->next_aln){
      $out->write_aln($aln);
      $alnCounter++;
    }
  }
  return $alnCounter;
}
 
sub findAllUniqueIdsInAln{
  my($infile,$settings)=@_;
  logmsg "Finding all expected sequence IDs";
  my %genome;
  my $alnin=Bio::AlignIO->new(-file=>$infile,-format=>$$settings{infileFormat});
  while(my $aln=$alnin->next_aln){
    foreach my $seq($aln->each_seq){
      $genome{$seq->id}++;
    }
  }
  return keys(%genome);
}
 
sub guess_format{
  my ($filename,$settings)=@_;
  for my $format (qw(pfam xmfa selex fasta stockholm prodom clustalw msf mase bl2seq nexus phylip)){
    eval{
      my $in=Bio::AlignIO->new(-file=>$filename,-format=>$format);
      my $aln=$in->next_aln;
      $aln->length;
    };
    if($@){
      my $error=$@;
      next;
    }
    return $format;
  }
  die "Could not guess the format of $filename\n";
}
 
sub usage{
  "Converts an alignment to another alignment format.
  $0 -i alignmentfile -o outputPrefix [-f outputformat]
  -i the alignment file to input
  -o the output alignment file or directory
    Specify a directory by a trailing slash.
    If a directory, the output format will be determined by -f. Default: fasta.
  -f output format
    possible values are derived from bioperl.
    e.g. fasta, clustalw, phylip, xmfa
  -g input format to force the correct input format, but it's ok to let it guess
  -c to concatenate the alignment into one solid entry
  -l linkerSequence, to be used with -c, to separate entries.
    Default is no linker but a useful linker could be NNNNNNNNNN
  -h this helpful menu
  ";
}
