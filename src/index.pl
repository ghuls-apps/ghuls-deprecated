package GHULS;
use warnings;
use diagnostics;
use strict;
use Data::Dumper;
use Net::GitHub::V3;
use List::MoreUtils;
use List::Util qw/sum0/;
use Term::ReadKey;
use JSON;

my $ERROR = $!;

sub main {
    my $sum = 0;
    my @login_data = read_secure();
    #if (scalar @login_data == 2) {
        our $git = Net::GitHub::V3->new(
            login => $login_data[0],
            pass => $login_data[1]
        );
        analyze($login_data[2]);
    # } else {
        # our $git = Net::GitHub::V3->new(
            # access_token => $login_data[0]
        # );
        # analyze($login_data[1]);
    # }

}

sub analyze {
    my ($user) = @_;
    my $repos = $GHULS::git->repos;
    my @repos_list = $repos->list_user($user);
    my @forks;

    my %all_languages;

    foreach my $repo (@repos_list) {
        if ($repo->{fork} == 1) {
            push @forks, $repo;
        } else {
            my %lang_names = $repos->languages($user, $repo->{name});
            $all_languages{$_} += $lang_names{$_} for keys %lang_names;
        }
    }

    my $all_sum = sum0(values %all_languages);
    my %percents = map { $_ => calc_percentage($all_languages{$_}, $all_sum) } keys %all_languages;

    #If necessary by the JavaScript, use %percents instead.
    my $json = encode_json \%all_languages;

    open my $fh, '>', "tmp/$user.json" or die $ERROR;
    print $fh "\{\n\t\"langs\"\: $json\n\}";
    close $fh;
}

sub calc_percentage {
    my ($part, $whole) = @_;
    my $percent = $part / $whole * 100;
    $percent = sprintf "%.2f", $percent; #round to 2 decimal places
    return $percent;
}

sub read_secure {
    my $file = 'info.txt';
    open my $fh, '<', $file or die "Could not open '$file' $ERROR\n";
    my @lines = <$fh>;
    close $fh;
    chomp @lines;
    return @lines;
}

main();
exit 0;
