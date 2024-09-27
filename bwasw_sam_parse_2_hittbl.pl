#!/usr/bin/perl
use strict;
use warnings;

# Hash to store the alignment information
my %index;

# Reading from standard input (SAM file)
while (<>) {
    chomp;
    
    # Split the line into fields based on tab delimiters
    my @fields = split /\t/;
    
    # Store the third field (score) in the hash using the first two fields (unitig and genome) as keys
    $index{$fields[0]}{$fields[1]} = $fields[2];
}

# Print the header for the output table
print "Unitig/Single\tSb\tZm\tOs\tBd\n";

# Process each unitig in sorted order
foreach my $unitig (sort keys %index) {
    
    # Print the unitig name
    print "$unitig";
    
    # Loop through the genomes (Sorghum, Zea, Oryza, Brachypodium)
    foreach my $genome ("Sorghum", "Zea", "Oryza", "Brachypodium") {
        
        # Print the score for the genome if it exists, otherwise print '-'
        if (exists $index{$unitig}{$genome}) {
            print "\t$index{$unitig}{$genome}";
        } else {
            print "\t-";
        }
    }
    
    # Move to the next line after printing all genomes data for the current unitig
    print "\n";
}
