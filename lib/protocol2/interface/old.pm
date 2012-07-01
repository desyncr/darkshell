package old;
use strict;
use warnings;

use lib::network::network;
use lib::base;
use lib::logger;
use lib::db::json;
our @ISA = qw(logger base);

sub new {
	my ($class, $settings) = @_;

	my $self = $class->SUPER::new($settings);
	my $child = {
		network  => $settings->{network} || new network($settings),
		json     => new json($settings),

		url		 => undef,
		user	 => undef,
		password => undef,

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
	$self->{user} = $settings->{auth}{user};
	$self->{password} = $settings->{auth}{password};

	return {status_code => 200};
}
sub sendPacket {
	my ($self, $settings) = @_;
	$self->log("sendPacket protocol");

	$settings->{user} = $self->{user};
	$settings->{password} = $self->{password};
	$settings->{action} = $self->getCommandScope($settings->{cmd});
	
	my $response = $self->{network}->post($self->{url}, $settings);
	return $self->{json}->decode($response);
}
sub getCommandScope {
	my ($self, $cmd) = @_;
	my @internals = qw(set unset get drop shell login);
	foreach my $item (@internals) {
		if ($cmd eq $item) {
			return 'INTERNAL';
		}
	}
	return 'CMD';
}
1;
