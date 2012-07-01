package protocol;
use strict;
use warnings;
use lib::base;
use base qw(base);

sub new {
	my ($class, $settings) = @_;
	my $protocol = $settings->{interface} || 'raw';
	require $ENV{'PWD'} . "/lib/protocol2/interface/$protocol.pm";
	my $self = {
		protocol => $protocol->new($settings) || undef,

		version  => 2,
		revision => 1,
	};

	bless $self, $class;
}

# auth({'url'=>'127.0.0.1', 'auth'=>{user'=>'name', 'password'=>'123'});
sub auth {
	my ($self, $settings) = @_;
	return $self->{protocol}->auth($settings);
}
sub sendPacket {
	my ($self, $settings) = @_;
	return $self->{protocol}->sendPacket($settings);
}
1;
