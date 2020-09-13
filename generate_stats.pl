#!/usr/bin/perl
use warnings;
use strict;

my $infile  = './checkpatch_out.txt';
my $outfile = './stats.txt';

# opens file for reading 
open(IF, '<', $infile) or die $!;

# opens file for writing
open(OF, '>', $outfile) or die $!;

# store error,warning,commit count
my $c_error   = 0;
my $c_warning = 0;
my $c_commit   = 0;

# hash mapping errors and warnings to count
my %errors;
my %warnings;

while(<IF>){
    my @words = (split /[ :]/, $_);
    my $length = @words;
    
    if($length < 2){
        next;
    }
     
    my $fw = $words[0];
    my $sw = $words[1];

    if ($fw eq "WARNING")  { 
        $c_warning++; 
        if(exists($warnings{$sw})) {
            $warnings{$sw}++;
        }
        else{
            $warnings{$sw}=1;
        }
    }
    if ($fw eq "ERROR") { 
        $c_error++;   
        if(exists($errors{$sw})){
            $errors{$sw}++;
        }
        else{
            $errors{$sw}=1;
        }
    }
    if ($fw eq "Commit") { 
        $c_commit++; 
    }
}

# store the max warnings, errors
# and their respective frequencies
my $c_mx_wrn=-1;
my $c_mx_err=-1;
my $mx_wrn;
my $mx_err;

# find warnings and most frequent warnings
print OF "Warnings:\n\n";
foreach my $key (sort { $b cmp $a }keys %warnings){
    my $val = $warnings{$key};
    print OF $key.": ".$val."\n";
    if ($c_mx_wrn==-1)
    {
        $c_mx_wrn=$val;
        $mx_wrn=$key;
    }
}

# find errors and most frequent error
print OF "\nErrors:\n\n";
foreach my $key (sort { $b cmp $a }keys %errors){
    my $val = $errors{$key};
    print OF $key.": ".$val."\n";
    if ($c_mx_err==-1)
    {
        $c_mx_err=$val;
        $mx_err=$key;
    }
}

print OF "\n\nTotal commits checked: ".$c_commit."\n";
print OF "Warnings generated: ".$c_warning."\n";
print OF "Errors generated: ".$c_error."\n\n";

print OF "Most frequent warning: ".$mx_wrn."\n";
print OF "Count: ".$c_mx_wrn."\n\n";

print OF "Most frequent error: ".$mx_err."\n";
print OF "Count: ".$c_mx_err."\n";

close(IF);
close(OF);
