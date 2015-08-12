#!/usr/bin/perl

while(<>){
    chomp;
    @_=split /\t/;
    @{$index{$_[0]}{$_[1]}} = $_[2];
}

print "Unitig/Single\tSb\tZm\tOs\tBd\n";
foreach $unitig (sort keys %index){
    print "$unitig";
    foreach $plant ("Sorghum","Zea","Oryza","Brachypodium"){
	if($index{$unitig}{$plant}[0]){
	    print "\t$index{$unitig}{$plant}[0]";
	}
	else{
	    print "\t-";
	}
    }
    print "\n";
}
