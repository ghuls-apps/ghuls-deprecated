use warnings;
use diagnostics;
use strict;
use WWW::Mechanize;
use Data::Dumper;

print 'Enter a username: ';
my $user = <>;
chomp $user;
my $repos_url = "https://api.github.com/users/$user/repos";
my $www = WWW::Mechanize->new();
my $repos = $www->get($repos_url);
my $repos_decoded = $repos->decoded_content();
my @repos_list = ($repos_decoded =~ m/\"name\"\:\"(.*?)\"/g);

foreach (@repos_list) {
    my $this = $_;
    my $this_url = "https://api.github.com/repos/$user/$this/languages";
    my $lang = $www->get($this_url);
    my $lang_decoded = $lang->decoded_content();
    my @lang_names = ($lang_decoded =~ m/\"(.*?)\":/g);
    foreach (@lang_names) {
        my $this_lang = $_;
        my $lang_num = $lang_decoded =~ m/\"$this_lang\": (.*?)(\,\n\})/;
        print "$this_lang: $lang_num";
    }
}

exit 0;
