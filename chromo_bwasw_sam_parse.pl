#!/usr/bin/perl

while(<>){
    next if /^\@/;
    chomp;
    @samline=@{[split /\t/]}[0,2,11];
    next if $samline[1] eq '*';
    $samline[2]=~s/AS:i://;
    $index{$samline[0]}{$samline[1]}+=$samline[2];
}

open CHROMO,"/media/nfs/moleculo/work/boxing/id2chromosome.tsv";
while(<CHROMO>){
    chomp;
    @_=split /\t/;
    $ids{$_[0]}=[$_[1],$_[2]];
}

foreach $unitig (sort keys %index){
    $chrom=
	@{[
	sort {
	    $index{$unitig}{$b} <=> $index{$unitig}{$a}
	}
	keys
	%{
	    $index{$unitig}
	}
	]}[0];
    print "$unitig\t$ids{$chrom}[0]\t$ids{$chrom}[1]\n";
}
