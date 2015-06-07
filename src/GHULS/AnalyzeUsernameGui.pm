package GHULS::AnalyzeUsernameGui;
use warnings;
use diagnostics;
use strict;
use base 'Wx::App';
use GHULS::Utility;

sub OnInit {
    my $self = shift;
    our $window = Wx::Window->new(undef, -1, 'GHULS', [-1, -1], [650, 675]);
    $window->Show(1);

    my $username = Wx::TextCtrl->new($window, -1, 'Username to analyze', [325, 625], $Wx::wxDefaultSize, $Wx::wxTE_SINGLELINE);
    my $analyzebutton = Wx::Button->new($window, -1, 'Login', [325, 575], [-1, -1]);

    Wx::Event->EVT_BUTTON($self, $analyzebutton, GHULS::Utility->analyze($username));
    return 1;
}
1;
