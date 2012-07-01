package state;
use strict;
use warnings;
use lib::db::json;

sub new {
	my ($class, $spec, $encoder, $debugger) = @_;
	my $self = {
		spec	=> $spec 	 || 'config/state.json',
		encoder => $encoder  || json->new(),
		debug 	=> $debugger || undef,

		_state  => undef,

		version => 1,
		revision => 1,
	};

	bless $self, $class;

	$self->load();
	return $self;
}
sub get {
	my ($self, $key) = @_;
	return $self->{_state}->{$key};	
}
sub set {
	my ($self, $key, $value) = @_;
	$self->{_state}->{$key} = $value;
}
sub load {
	my $self = shift;
	$self->{_state} = $self->encoder()->load($self->spec());
}
sub save {
	my $self = shift;
	$self->{encoder}->save($self->{_state});
}

# Getters and setters
sub encoder {
	my $self = shift;
	return $self->{encoder};
}

sub spec {
	my $self = shift;
	if (@_) {
		$self->{spec} = shift;
	}
	return $self->{spec};
}

sub version {
	my $self = shift;
	return $self->{version};
}

sub revision {
	my $self = shift;
	return $self->{revision};
}
1;
