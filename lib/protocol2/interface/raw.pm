package raw;
use strict;
use warnings;

use lib::network::network;
use lib::base;
use lib::logger;
our @ISA = qw(logger base);

sub new {
    my ($class, $settings) = @_;

    my $self = $class->SUPER::new($settings);
    my $child = {
        network  => $settings->{network} || new network($settings),

        url      => undef,
        version  => 1,
        revision => 1,
    };
    foreach (keys %$child) {
        $self->{$_} = $child->{$_};
    }
    bless $self, $class;
}

# auth({'user'=>'name', 'password'=>'123'});
sub auth {
    my ($self, $settings) = @_;
    $self->{url} = $settings->{url};
    return {response => $self->{network}->post($settings->{url}, $settings->{auth})};
}
sub sendPacket {
    my ($self, $settings) = @_;
    $self->log("sendPacket protocol");
    return {response => $self->{network}->post($self->{url}, $settings)};
}

1;
