use warnings;
use diagnostics;
use strict;
use Data::Dumper;
use Net::GitHub::V3;
use List::MoreUtils;
use List::Util;
use JSON;
use Term::ReadKey;
use GHULS::LoginGui;
use GHULS::GHULS;

my $ERROR = $!;

sub main {
    my $sum = 0;
    my $login_loop_control = 0;

    while (42) {
        print "Would you like to use an auth key or login? (1/2)\n";
        my $authoruser = <>;
        chomp $authoruser;

        #my @secure = read_secure();
        if ($authoruser eq '1') {
            $login_loop_control = 1;
            print "Please enter your auth code. This will never be shown to anyone, not even the developer of this software: \n";
            ReadMode 2;
            my $auth = <>;
            ReadMode 0;
            chomp $auth;
            our $git = Net::GitHub::V3->new(
                access_token => $auth
            ) or $login_loop_control = 0;
        }

        if ($authoruser eq '2') {
            $login_loop_control = 2;
            print 'Please enter your username: ';
            my $authuser = <>;
            chomp $authuser;
            print "Please enter your password. This will never be shown to anyone, not even the developer of this software: \n";
            ReadMode 2;
            my $pass = <>;
            ReadMode 0;
            chomp $pass;
            our $git = Net::GitHub::V3->new(
                login => $authuser,
                pass => $pass
            ) or $login_loop_control = 0;
        }

        if ($authoruser ne '1' and $authoruser ne '2') {
            $login_loop_control = 0;
        }

        if ($login_loop_control == 1 or $login_loop_control == 2) {
            last;
        }
    }

    print 'Enter a username to analyze: ';
    my $user = <>;
    chomp $user;

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

            # Drop this if you don't need it any more
            foreach my $lang_name (keys %lang_names) {
                print "$repo->{name}: $lang_name $lang_names{$lang_name}\n";
            }
        }
    }


    my $num_langs = keys %all_languages;
    my $join = join ', ', keys %all_languages;
    print "$user has repositories written in $num_langs languages: $join\n";

    my $all_sum = List::Util->sum0(values %all_languages);
    print "Total: $all_sum\n";

    my %percents = map { $_ => calc_percentage($all_languages{$_}, $all_sum) } keys %all_languages;

    print "$_: $percents{$_}%\n" for keys %percents;

    #If necessary by the JavaScript, use %percents instead.
    my $json = encode_json \%all_languages;

    open my $fh, '>', "tmp/$user.json" or die $ERROR;
    print $fh $json;
    close $fh;
}

sub calc_percentage {
    my ($part, $whole) = @_;
    my $percent = $part / $whole * 100;
    $percent = sprintf "%.2f", $percent; #round to 2 decimal places
    return $percent;
}

print "main or main_with_gui? (1/2)\n";
my $main = <>;
chomp $main;

if ($main eq '1') {
    GHULS::GHULS->main();
    exit 0;
} elsif ($main eq '2') {
    GHULS::GHULS->main_with_gui();
    exit 0;
} else {
    die "the fuck bitch";
}

exit 0;
