package GHULS::LoginGui;
use Wx;
use warnings;
use diagnostics;
use strict;
use base 'Wx::App';
use Wx;
use GHULS::Utility;
use GHULS::AnalyzeUsernameGui;

sub OnInit {
    my $self = shift;
    my $frame = Wx::Frame->new(undef, -1, 'GHULS', $Wx::wxDefaultPosition, $Wx::wxDefaultSize);
    $frame->Show();

    my $text_login = Wx::StaticText->new($frame, -1, 'Login to GitHub', [325, 650]);
    my $usernamectrl = Wx::TextCtrl->new($frame, -1, 'Username', [325, 625], $Wx::wxDefaultSize, $Wx::wxTE_SINGLELINE);
    my $passwordctrl = Wx::TextCtrl->new($frame, -1, 'Password', [325, 600], $Wx::wxDefaultSize, $Wx::wxTE_PASSWORD);
    my $loginbutton = Wx::Button->new($frame, -1, 'Login', [325, 575], [-1, -1]);

    Wx::Event->EVT_BUTTON($self, $loginbutton, get_login_data_file($usernamectrl, $passwordctrl, $frame));
    return 1;
}

sub get_login_data_file {
    my ($usernamectrl, $passwordctrl, $frame) = @_;
    my $username = $usernamectrl->GetValue();
    my $password = $passwordctrl->GetValue();

    open my $fh, '>', 'login.txt';
    print $fh "$username\n";
    print $fh "$password";
    close $fh;
    if (GHULS::Utility->login == 1) {
        error();
    } elsif (GHULS::Utility->login == 0) {
        $frame->Close();
        my $analyzegui = GHULS::AnalyzeUsernameGui->new();
        $analyzegui->MainLoop();
    }
}
1;
