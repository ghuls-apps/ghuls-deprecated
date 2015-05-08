package GHULS::LoginGui;
use Wx;
use base 'Wx::App';

sub OnInit {
    my $self = shift;
    my $frame = Wx::Frame->new(undef, -1, 'GHULS', [-1, -1], [650, 675]);
    $frame->Show(1);
    
    my $text_login = Wx::StaticText->new($frame, -1, "Login to GitHub", [325, 650], -1);
    my $usernamectrl = Wx::TextCtrl->new($frame, -1, "Username", [325, 625], wxDefaultSize, wxTE_SINGLELINE);
    my $passwordctrl = Wx::TextCtrl->new($frame, -1, "Password", [325, 600], wxDefaultSize, wxTE_PASSWORD);
    return 1;
}
