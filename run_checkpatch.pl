#!/usr/bin/perl
use warnings;
use strict;

my $infile  = './commits.txt';
my $outfile = './checkpatch_out.txt';

# opens file for reading 
open(IF, '<', $infile) or die $!;

# opens file for writing
open(OF, '>', $outfile) or die $!;

while(<IF>){
    # extracts the first word from line
    my $hash = (split / /, $_)[0];

    $ calls checkpatch on the commit denoted by $hash
    my $out = `perl ./scripts/checkpatch.pl --show-types -g $hash`;

    print OF $out."\n";
}

close(IF);
close(OF);
