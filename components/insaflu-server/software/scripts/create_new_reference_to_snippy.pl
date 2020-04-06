use Bio::SeqIO;

my ($reference, $out_file) = @ARGV;
 
if (not defined $reference) {
  die "Need reference name\n";
}
 
if (not defined $out_file) {
  die "Need out_file name\n";
}


my $in = Bio::SeqIO->new(-file=>$reference, -format=>'genbank') or err("Could not open --reference: $reference");
my $out = Bio::SeqIO->new(-file=>">$out_file", -format=>'fasta');
my $nseq = 0;
my $nfeat = 0;
my %refseq;
while (my $seq = $in->next_seq) {
  exists $refseq{$seq->id} and err("Duplicate sequence ".$seq->id." in $reference");
  $refseq{ $seq->id } = uc($seq->seq); # keep for masking later
  $out->write_seq($seq);
  $nseq++;
  for my $f ($seq->get_SeqFeatures) {
    next if $f->primary_tag =~ m/^(source|misc_feature|gene|RBS)$/;
    $f->source_tag($EXE);
    # it seems to be writeing phase=1 (aka frame) instead of 0 (0-based)
    # i suspect it is using /codon_start= incorrectly (1-based) !!!
    $f->frame(0);
    if ($f->has_tag('locus_tag')) {
      my($id) = $f->get_tag_values('locus_tag');
      $f->add_tag_value('ID', $id);
    }
    if ($f->has_tag('gene')) {
      my($gene) = $f->get_tag_values('gene');
      $f->add_tag_value('Name', $gene);
    }
    $nfeat++;
  }
}


