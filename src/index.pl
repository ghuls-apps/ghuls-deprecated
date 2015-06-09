package GHULS;
use warnings;
use diagnostics;
use strict;
use Data::Dumper;
use Net::GitHub::V3;
use List::MoreUtils;
use List::Util;
use JSON;
use Term::ReadKey;

use Gtk2;
use Glib qw/TRUE FALSE/;

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

sub read_secure {
    my $file = 'secure.txt';
    open my $fh, '<', $file or die "Could not open '$file' $ERROR\n";
    my @lines = <$fh>;
    close $fh;
    chomp @lines;
    return @lines;
}

sub delete_event {
    return FALSE;
    exit 0;
}

sub use_un_pw {
    
}

sub use_code {

}

sub gui {
    Gtk2->init();
    
    my $which_window = Gtk2::Window->new('toplevel');
    
    $which_window->signal_connect(
        delete_event => delete_event()
    );
    $which_window->signal_connect(
        destroy => sub { Gtk2->main_quit(); }
    );
    
    $which_window->set_border_width(50);
    $which_window->set_title('GHULS Authorization');
    
    my $choose = Gtk2::TextView->new();
    my $choose_buffer = $choose->get_buffer();
    my $login_button = Gtk2::Button->new('Use GitHub username and password');
    my $code_button = Gtk2::Button->new3('Use GitHub authorization code');
    
    $choose_buffer->set_text('How would you like to authorize yourself with GHULS/GitHub?');
    $login_button->signal_connect(
        clicked => use_un_pw()
    );
    $code_button->signal_connect(
        clicked => use_code()
    );
    
    $which_window->add($choose);
    $which_window->add($login_button);
    $which_window->add($code_button);
    $login_button->show();
    $code_button->show();
    $which_window->show_all();
    
    Gtk2->main();
}
