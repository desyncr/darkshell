package network;
use lib::base;
use base qw(base);

sub new
{
	my ($class, $settings) = @_;
	my $network = $settings->{network} || 'www';
	require $ENV{"PWD"} . "/lib/network/interface/$network.pm";

	my $self = {
		socket 	=> $network->new($settings),	# socket name

		version => 2,
		revision => 1,
	};
	
	bless $self, $class;
	return $self;
}
# Interface
sub get
{
	my ($self, $url) = @_;
	return $self->{socket}->get($url);
}
sub post
{
	my ($self, $url, $post) = @_;
	return $self->{socket}->post($url, $post);
}

sub download
{
	my ($self, $url, $dest) = @_;
	return $self->{socket}->download($url, $dest);
}
sub upload
{
	my ($self, $url, $post) = @_;
	return $self->{socket}->upload($url, $post);	
}

# Getters and setters
sub proxy {
	my $self = shift;
	if (@_) {
		$self->{socket}->{proxy} = shift;
	}
	return $self->{socket}->{proxy};
}
sub proto {
	my $self = shift;
	if (@_) {
		$self->{socket}->{proto} = shift;
	}
	return $self->{socket}->{proto};
}
sub timeout {
	my $self = shift;
	if (@_) {
		$self->{socket}->{timeout} = shift;
	}
	return $self->{socket}->{timeout};
}
sub tries {
	my $self = shift;
	if (@_) {
		$self->{socket}->{tries} = shift;
	}
	return $self->{socket}->{tries};
}
sub agent {
	my $self = shift;
	if (@_) {
		$self->{socket}->{agent} = shift;
	}
	return $self->{socket}->{agent};
}
sub cookies {
	my $self = shift;
	if (@_) {
		$self->{socket}->{cookies} = shift;
	}
	return $self->{socket}->{cookies};
}
sub config {
	my $self = shift;
	if (@_) {
		$self->{socket}->{config} = shift;
	}
	return $self->{socket}->{config};
}
sub downloads {
	my $self = shift;
	if (@_) {
		$self->{socket}->{downloads} = shift;
	}
	return $self->{socket}->{downloads};
}
sub debug {
	my $self = shift;
	if (@_) {
		$self->{socket}->{debug} = shift;
	}
	return $self->{socket}->{debug};
}
1;
