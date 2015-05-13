package GHULS::LoginGui;
use Wx;
use base 'Wx::App';

sub OnInit {
    my $self = shift;
    my $frame = Wx::Frame->new(undef, -1, 'GHULS', [-1, -1], [650, 675]);
    $frame->Show(1);
    
    my $text_login = Wx::StaticText->new($frame, -1, 'Login to GitHub', [325, 650], -1);
    my $usernamectrl = Wx::TextCtrl->new($frame, -1, 'Username', [325, 625], wxDefaultSize, wxTE_SINGLELINE);
    my $passwordctrl = Wx::TextCtrl->new($frame, -1, 'Password', [325, 600], wxDefaultSize, wxTE_PASSWORD);
    my $loginbutton = Wx::Button->new($frame, -1, 'Login', [325, 575], [-1, -1]);
    
    Wx::Event->EVT_BUTTON($self, $loginbutton, get_login_data_file($usernamectrl, $passwordctrl);
    return 1;
}

sub get_login_data_file {
    my ($usernamectrl, $passwordctrl) = @_;
    my $username = $usernamectrl->GetValue();
    my $password = $passwordctrl->GetValue();
    
    open my $fh, '>', 'login.txt';
    print $fh "$username\n";
    print $fh "$password\n";
    close $fh;
}
