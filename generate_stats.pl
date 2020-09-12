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
my $c_mx_wrn=0;
my $c_mx_err=0;
my $mx_wrn;
my $mx_err;

# find most frequent warning
foreach my $key (keys %warnings){
    my $val = $warnings{$key};
    if($val > $c_mx_wrn)
    {
        $c_mx_wrn=$val;
        $mx_wrn=$key;
    }
}

# find most frequent error
foreach my $key (keys %errors){
    my $val = $errors{$key};
    if($val > $c_mx_err)
    {
        $c_mx_err=$val;
        $mx_err=$key;
    }
}

print OF "Total commits checked: ".$c_commit."\n";
print OF "Warnings generated: ".$c_warning."\n";
print OF "Errors generated: ".$c_error."\n\n";

print OF "Most frequent warning: ".$mx_wrn."\n";
print OF "Count: ".$c_mx_wrn."\n\n";

print OF "Most frequent error: ".$mx_err."\n";
print OF "Count: ".$c_mx_err."\n";

close(IF);
close(OF);
