package base;
sub new {
	my $class = shift;
	my $self  = {
		version	=> 1,
		revision => 1,
	};
	bless $self, $class;
}
sub version {
	my $self = shift;
	if (@_) {
		$self->{version} = shift;
	}
	return $self->{version};
}
sub revision {
	my $self = shift;
	if (@_) {
		$self->{revision} = shift;
	}
	return $self->{revision};
}
1;