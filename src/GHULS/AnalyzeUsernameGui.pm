package GHULS::AnalyzeUsernameGui;
use warnings;
use diagnostics;
use strict;
use base 'Wx::App';
use GHULS::Utility;

sub OnInit {
    my $self = shift;
    my $frame = Wx::Frame->new(undef, -1, 'GHULS', $Wx::wxDefaultPosition, $Wx::wxDefaultSize, $Wx::wxMAXIMIZE_BOX | $Wx::CLOSE_BOX);
    $frame->Show(1);

    my $username = Wx::TextCtrl->new($frame, -1, 'Username to analyze', [325, 625], $Wx::wxDefaultSize, $Wx::wxTE_SINGLELINE);
    my $analyzebutton = Wx::Button->new($frame, -1, 'Login', [325, 575], [-1, -1]);

    Wx::Event->EVT_BUTTON($self, $analyzebutton, GHULS::Utility->analyze($username));
    return 1;
}
1;
