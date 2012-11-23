package json;
use strict;
use warnings;

use lib::debug::debug;
use JSON;

sub new {
    my ($class, $settings) = @_;
    my $self = {
        json    => JSON->new->allow_nonref,
        debug   => new debug({log => $class,
                                verbosity => 0 && $settings->{verbosity}}),
    };

    bless $self, $class;
    return $self;
}

sub load {
    my ($self, $db) = @_;
    $self->{debug}->log("Setting up db: $db");
    $self->{db} = $db;

    open FILE, "<", $db || $self->{debug}->log($!) && return 0;

    my @lines = <FILE>;

    $self->{debug}->log("File contents: @lines");

    close FILE;
    my $decode = $self->{json}->decode(@lines);
    $self->{debug}->dump("Loaded data:", $decode);
    return $decode;

}

sub save {
    my ($self, $data) = @_;
    if (!defined $self->{db}) {
        $self->{debug}->log("Trying to access an uninitialized object.");
    }
    $self->{debug}->dump("saving data back to file: ", $data);
    open FILE, ">", $self->{db} || $self->{debug}->log($!);
    my $newdata = $self->{json}->encode($data);

    $self->{debug}->log("Data to save: $newdata");
    print FILE $newdata;
    close FILE;
}

sub encode {
    my ($self, $data) = @_;
    $self->{debug}->log("Encoding '$data'");
    return $self->{json}->encode($data);
}

sub decode {
    my ($self, $data) = @_;
    $self->{debug}->dump("Decoding ", $data);
    eval{ return $self->{json}->decode($data); };
}
1;
