#!/usr/bin/perl
use warnings;
use strict;
use threads;
use threads::shared;
use Thread::Semaphore;
use Fcntl qw(:flock SEEK_END);

sub lockf {
	my ($fh) = @_;
	flock($fh, LOCK_EX) or die "Cannot lock file - $!\n";
	seek($fh, 0, SEEK_END) or die "Cannot seek - $!\n";
}
sub unlockf {
	my ($fh) = @_;
	flock($fh, LOCK_UN) or die "Cannot unlock file - $!\n";
}

my $infile:shared  = './commits.txt';
my $outfile:shared = './checkpatch_out.txt';

open(IF, '<', $infile) or die $!;
open(my $OF, '>', $outfile) or die $!;

my $c :shared = 0;
my $running :shared = 1;
my $sem = Thread::Semaphore->new(10);
my $active :shared = 0;

# Disable buffering
$|++;

# show progress
my $progresst = threads->create(\&progress);
$progresst -> detach;

while(<IF>){
    # extracts the first word from line
    my $hash = (split / /, $_)[0];

	# use semaphores to restrict thread creation
    $sem->down();
    my $thread = threads->create(\&run, $hash);
    $thread->detach;
    lock($active);
    $active++;
}

while($active)
{
	sleep(1);
}

sub run {
	my $hash=$_[0];
	my $out = `perl ./scripts/checkpatch.pl --show-types -g $hash`;
	
	lockf($OF);
    print $OF $out."\n";
    unlockf($OF);
    
    lock($c);
    lock($active);
	$c++;	
	$active--;
    $sem->up();
}

sub progress {
	while($running){
		print "Commits processed: ".$c."\n";
		sleep(2);
	}
}

$running=0;
close(IF);
close($OF);
