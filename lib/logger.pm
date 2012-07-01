package logger;
use strict;
use warnings;

use lib::debug::debug;
use lib::base;
our @ISA = qw(debug base);

sub new {
    my ($class, $settings) = @_;
    my $self = $class->SUPER::new($settings);
    my $child = {
            version => 1,
            revision => 1,
    };
    foreach (keys %$child) {
        $self->{$_} = $child->{$_};
    }
    bless $self, $class;
}
sub log {
    my ($self, $msg) = @_;
    if ($self->{debug}) {
        return $self->SUPER::log($msg);
    }
}
sub dump {
    my ($self, $msg, $struct) = @_;
    if ($self->{debug}) {
        return $self->SUPER::dump($msg, $struct);
    }
}
# Getters and setters
sub debug {
    my $self = shift;
    if (@_) {
        $self->{debug} = shift;
    }
    return $self->{debug};
}

1;