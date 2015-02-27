use warnings;
use diagnostics;
use strict;
use Data::Dumper;
use Net::GitHub::V3;
use List::MoreUtils;

my $ERROR = $!;

sub main {
    my $sum = 0;
    print 'Enter a username: ';
    my $user = <>;
    chomp $user;

    print "Would you like to include forks in the calculations for $user?\nINCLUDING FORKS MAY MAKE THE CODE TAKE AN IMMENSE AMOUNT OF TIME, AND PROVIDE INACCURATE RESULTS. USE AT YOUR OWN RISK.\n(y/n)\n";
    my $includeforks = <>;
    chomp $includeforks;

    my @langs = ();
    my @secure = read_secure();
    my $git = Net::GitHub::V3->new(
        access_token => $secure[0]
    );
    my $repos = $git->repos;
    my @repos_list = $repos->list_user($user);
    my @forks = ();

    foreach my $this (@repos_list) {
        if ($this->{fork} == 1 and $includeforks =~ m/^n$/i) {
            push @forks, $this;
        } else {
            my %lang_names = $repos->languages($user, $this->{name});
            foreach my $lang_name (keys %lang_names) {
                print "$this->{name}: $lang_name $lang_names{$lang_name}\n";
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
            my %lang_names = $repos->languages($user, $repo->{name});
            if (exists $lang_names{$lang}) {
                $sum += $lang_names{$lang};
            }
        }
        print "$lang: $sum\n";
        push @lang_sums, $sum;
        $sum = 0;
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
