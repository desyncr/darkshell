package handlers;
sub new {
	my ($class) = @_;
	my $self = {
		version => 1,
		revision => 1,
	};
	bless $self, $class;
}
sub TestSub {
	return "TestSub 1";
}
sub TestSub2 {
	my ($self, $param) = @_;
	return $param;
}
sub Sub3{
	return "FALSE";
}
1;