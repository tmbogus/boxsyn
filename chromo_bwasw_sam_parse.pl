#!/usr/bin/perl
use strict;
use warnings;

# Hashes to store alignment information and chromosome mappings
my %index;
my %ids;

# Process each line of the input SAM file
while (<>) {
    # Skip header lines starting with '@'
    next if /^\@/;

    chomp;
    
    # Split the SAM line and extract relevant fields (unitig, reference, alignment score)
    my @samline = @{[split /\t/]}[0, 2, 11];
    
    # Skip entries with no valid reference (denoted by '*')
    next if $samline[1] eq '*';
    
    # Remove the 'AS:i:' prefix from the alignment score
    $samline[2] =~ s/AS:i://;
    
    # Accumulate alignment scores for each unitig and reference
    $index{$samline[0]}{$samline[1]} += $samline[2];
}

# Open the file containing chromosome mappings
open my $chrom_fh, '<', 'id2chromosome.tsv' or die "Could not open chromosome mapping file: $!";

# Process each line of the chromosome mapping file
while (<$chrom_fh>) {
    chomp;
    
    # Split the line into fields (reference, chromosome, chromosome_name)
    my @fields = split /\t/;
    
    # Store the chromosome and chromosome_name for each reference
    $ids{$fields[0]} = [$fields[1], $fields[2]];
}

close $chrom_fh;

# For each unitig, determine the reference with the highest alignment score
foreach my $unitig (sort keys %index) {
    # Find the reference with the maximum accumulated alignment score
    my $best_reference = (
        sort { $index{$unitig}{$b} <=> $index{$unitig}{$a} }
        keys %{ $index{$unitig} }
    )[0];
    
    # Output the unitig, best reference chromosome, and chromosome name
    print "$unitig\t$ids{$best_reference}[0]\t$ids{$best_reference}[1]\n";
}
