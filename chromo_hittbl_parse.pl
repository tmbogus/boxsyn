#!/usr/bin/perl
use strict;
use warnings;

# Input format example:
# unitig_1        8       Brachypodium    5
# unitig_1        25      Oryza           1

# Hash to store the alignment information
my %index;

# Read the input hit table line by line
while (<>) {
    chomp;

    # Split the line into fields based on tab delimiters
    my @fields = split /\t/;
    
    # If the score is higher than the previous one, store it
    if (!defined $index{$fields[0]}{$fields[2]} || $index{$fields[0]}{$fields[2]}[1] <= $fields[1]) {
        $index{$fields[0]}{$fields[2]} = [$fields[3], $fields[1]];
    }
}

# Print the header for the output table
print "Unitig/Single\tSb\tZm\tOs\tBd\n";

# Process each unitig in sorted order
foreach my $unitig (sort keys %index) {
    
    # Print the unitig name
    print "$unitig";
    
    # Loop through the genomes (Sorghum, Zea, Oryza, Brachypodium)
    foreach my $genome ("Sorghum", "Zea", "Oryza", "Brachypodium") {
        
        # Print the alignment score for the genome if it exists, otherwise print '-'
        if (exists $index{$unitig}{$genome}) {
            print "\t$index{$unitig}{$genome}[0]";
        } else {
            print "\t-";
        }
    }
    
    # Move to the next line after printing all genomes data for the current unitig
    print "\n";
}
