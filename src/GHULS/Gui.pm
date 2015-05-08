package GHULS::Gui;
use Wx;
use base 'Wx::App';

sub OnInit {
    my $self = shift;
    my $frame = Wx::Frame->new(undef, -1, 'GHULS', [-1, -1], [650, 675]);
    $frame->Show(1);
    return 1;
}
