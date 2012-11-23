package comm;
use strict;
use warnings;

use lib::protocol2::protocol;
use lib::network::network;
use lib::base;
use lib::logger;
use base qw(logger base);
sub new {
	my ($class, $settings) = @_;

	my $self = $class->SUPER::new($settings);
	my $child = {
		protocol 	=> $settings->{protocol} || new protocol(
			{network => new network($settings)}),

		version => 2,
		revision => 1,

	};
	foreach (keys %$child) {
		$self->{$_} = $child->{$_};
	}

	bless $self, $class;
	return $self;
}
sub login {
	my ($self, $user, $password, $url) = @_;
	my $packet = {
		url		=> $url,
		auth 	=> {
			user 		=> $user,
			password 	=> $password,
		}
	};
	return $self->protocol()->auth($packet);
}
sub sendCommand {
	my ($self, $cmd, $params) =  @_;
	$self->log("sendCommand($cmd, ...)");
	my $packet = {
		cmd 	=> $cmd,
		params 	=> "@$params",
	};

	return $self->protocol()->sendPacket($packet);
}

# Getters and setters
sub protocol {
	my $self = shift;
	return $self->{protocol};
}

# deprecated
sub sendInternal {
	my ($self, $cmd, $params) = @_;
	return $self->sendCommand($cmd, $params);
}
# deprecated
sub connect {
	my ($self, $user, $password, $url) = @_;
	return $self->login($user, $password, $url);
}
# deprecated
sub disconnect {
	my ($self, $url) = @_;
	# fuck this shit up
}
# deprecated
sub download {
	my ($self, $url, $local) = @_;
	$self->log("Download $self->{protocol}{url}$url to $local");
	return $self->{protocol}->{network}->download($self->{protocol}{url} . $url, $local);
}
# deprecated
sub upload {
	my ($self, $file) = @_;
	$self->log("Uploading $file...");

	$self->{protocol}{data}{cmd}		= 'drop';
	$self->{protocol}{data}{action} 	= 'INTERNAL';
	$self->{protocol}{data}{file}		= [$file];
	#my $old = $self->{protocol}->{url};
	#$self->{protocol}->{url} = 'http://localhost/drop.php';
	
	my $return = $self->{protocol}->{network}->upload($self->{protocol}->{url}, $self->{protocol}{data});

	#$self->{protocol}->{url} = $old;
	return $return;
}

1;
