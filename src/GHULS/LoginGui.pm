package GHULS::LoginGui;
use Wx;
use warnings;
use diagnostics;
use strict;
use base 'Wx::App';
use GHULS::Utility;
use GHULS::AnalyzeUsernameGui;

sub OnInit {
    my $self = shift;
    my $window = Wx::Window->new(undef, -1, 'GHULS', [-1, -1], [650, 675]);
    $window->Show(1);

    my $text_login = Wx::StaticText->new($window, -1, 'Login to GitHub', [325, 650], -1);
    my $usernamectrl = Wx::TextCtrl->new($window, -1, 'Username', [325, 625], $Wx::wxDefaultSize, $Wx::wxTE_SINGLELINE);
    my $passwordctrl = Wx::TextCtrl->new($window, -1, 'Password', [325, 600], $Wx::wxDefaultSize, $Wx::wxTE_PASSWORD);
    my $loginbutton = Wx::Button->new($window, -1, 'Login', [325, 575], [-1, -1]);

    Wx::Event->EVT_BUTTON($self, $loginbutton, get_login_data_file($usernamectrl, $passwordctrl, $window));
    return 1;
}

sub get_login_data_file {
    my ($usernamectrl, $passwordctrl, $window) = @_;
    my $username = $usernamectrl->GetValue();
    my $password = $passwordctrl->GetValue();

    open my $fh, '>', 'login.txt';
    print $fh "$username\n";
    print $fh "$password";
    close $fh;
    if (GHULS::Utility->login == 1) {
        error();
    } elsif (GHULS::Utility->login == 0) {
        $window->Close();
        my $analyzegui = GHULS::AnalyzeUsernameGui->new();
        $analyzegui->MainLoop();
    }
}
1;
