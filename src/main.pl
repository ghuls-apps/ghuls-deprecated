use warnings;
use diagnostics;
use strict;
use Data::Dumper;
use Net::GitHub::V3;

my $ERROR = $!;

sub main {
    print 'Enter a username: ';
    my $user = <>;
    chomp $user;
    my @secure = read_secure();
    my $git = Net::GitHub::V3->new(
        access_token => $secure[0]
    );
    my $repos = $git->repos;
    my @repos_list = $repos->list_user($user);

    foreach my $this (@repos_list) {
        my %lang_names = $repos->languages($user, $this->{name});
        foreach my $lang_name (keys %lang_names) {
            print "$this->{name}: $lang_name $lang_names{$lang_name}\n";
        }
    }
}

sub read_secure {
    my $file = 'secure.txt';
    open my $fh, '<', $file or die "Could not open '$file' $ERROR\n";
    my @lines = <$fh>;
    close $fh;
    chomp @lines;
    return @lines;
}

main();
exit 0;
