#!/usr/bin/perl

#unitig_1        8       Brachypodium    5
#unitig_1        25      Oryza   1


while(<>){
    chomp;
    @_=split /\t/;
    @{$index{$_[0]}{$_[2]}} = ($_[3],$_[1]) if $index{$_[0]}{$_[2]}[1] <= $_[1];
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
