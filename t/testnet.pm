package testnet;
use strict;
use warnings;

sub new {
	my $class = shift;
	my $self = {
		version => 1,
		revision => 1,
	};
	bless $self, $class;
}
sub get {
	my ($self, $url) = @_;
	return "Getting `$url`";
}
sub post {
	my ($self, $url, $post) = @_;
	return "Posting to `$url`";
	#print Dumper $post;
}

sub download {
	my ($self, $url) = @_;
	return "Downloading `$url`";	
}
sub upload {
	my ($self, $url, $file) = @_;
	return "Uploading `$file` to `$url`";
}

# Getters and setters
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