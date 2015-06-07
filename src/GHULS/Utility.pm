package GHULS::Utility;
use warnings;
use diagnostics;
use strict;

my $ERROR = $!;

sub login {
    open my $fh, '<', 'login.txt';
    my @filelines = <$fh>;
    close $fh;
    chomp @filelines;
    our $git = Net::GitHub::V3->new(
        login => $filelines[0],
        pass => $filelines[1]
    ) or return 1;
    return 0;
}

sub analyze {
    my ($username) = @_;
    # TODO: Rewrite index.pl->main() here to allow for the data to be sent to the GUI
}

sub read_secure {
    my $file = 'secure.txt';
    open my $fh, '<', $file or die "Could not open '$file' $ERROR\n";
    my @lines = <$fh>;
    close $fh;
    chomp @lines;
    return @lines;
}
1;
