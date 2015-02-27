use warnings;
use diagnostics;
use strict;
use Data::Dumper;
use Net::GitHub::V3;
use List::MoreUtils;

my $ERROR = $!;

#This method has an excessive amount of fruity loops.
sub main {
    my $sum = 0;
    print 'Enter a username: ';
    my $user = <>;
    chomp $user;

    my @langs = ();
    my @secure = read_secure();
    my $git = Net::GitHub::V3->new(
        access_token => $secure[0]
    );
    my $repos = $git->repos;
    my @repos_list = $repos->list_user($user);
    my @forks = ();

    foreach my $repo (@repos_list) {
        if ($repo->{fork} == 1) {
            push @forks, $repo;
        } else {
            my %lang_names = $repos->languages($user, $repo->{name});
            foreach my $lang_name (keys %lang_names) {
                print "$repo->{name}: $lang_name $lang_names{$lang_name}\n";
                push @langs, $lang_name;
            }
        }
    }

    @langs = List::MoreUtils::uniq(@langs);
    my $join = join ', ', @langs;
    my $num_langs = scalar @langs;
    print "$user has repositories written in $num_langs langauges: $join\n";

    my @lang_sums = ();
    foreach my $lang (@langs) {
        foreach my $repo (@repos_list) {
            if ($repo->{fork} == 0) {
                my %lang_names = $repos->languages($user, $repo->{name});
                if (exists $lang_names{$lang}) {
                    print "$lang: $lang_names{$lang}... ";
                    $sum += $lang_names{$lang};
                    print "$lang: $sum\n";
                    push @lang_sums, $sum;
                }
            }
        }
        $sum = 0;
    }

    my $lang_sums_total = 0;
    $lang_sums_total += $_ for @lang_sums;
    print "Total: $lang_sums_total\n";

    my @percents = ();
    foreach my $sum (@lang_sums) {
        foreach my $lang (@langs) {
            foreach my $repo (@repos_list) {
                if ($repo->{fork} == 0) {
                    my %lang_names = $repos->languages($user, $repo->{name});
                    if (exists $lang_names{$lang}) {
                        my $percent = calc_percentage($sum, $lang_sums_total);
                        push @percents, $percent;
                    }
                    foreach my $percent (@percents) {
                        print "$lang: $percent ($repo->{name})\n";
                    }
                }
            }
        }
    }
}

sub calc_percentage {
    my ($part, $whole) = @_;
    my $percent = $part / $whole * 100;
    return "$percent %";
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
