package shell;
use strict;
use warnings;

use lib::logger;
use lib::base;
use lib::db::json;
use lib::state;
use lib::comm;

use lib::shell::shellutils;

our @ISA = qw(logger base);

sub new {
    my ($class, $settings) = @_;

    my $self = $class->SUPER::new($settings);
    # FIX Shell class won't inherit properties from SUPER (logger)
    my $child = {
        comm    => $settings->{comm}  || new comm($settings),
        state   => $settings->{state} || new state(),
        utils   => $settings->{utils} || new shellutils($settings),

        debug   => $settings->{debug} || undef,

        result  => {},

        hooksInstance   => undef,
        hooksDefinition => undef,

        settings => $settings,
        version => 2,
        revision => 1,
    };
    foreach (keys %$child) {
        $self->{$_} = $child->{$_};
    }
    bless $self, $class;
}

sub shellLogin {
    my ($self, $cmd) = @_;
    my $login = functions::parseuri($cmd);
    return $self->comm()->login($login->{user}, $login->{pass}, $login->{url});
}

sub issueCommand {
    my ($self, $cmd, $params) = @_;
    my ($hook, $result);
    $self->log("issueCommand($cmd, ...)");
    if ($hook = $self->utils()->hasHook($self->hooksDefinition(), $cmd, $params)) {
        $result = $self->utils()->callHook($self->hooksInstance(), $hook, $params);     
    }
    if (!$result) {
        $result = $self->comm()->sendCommand($cmd, $params);
    }
    return $self->result($result);
}
sub attachHooks {
    my ($self, $definition, $hooks) = @_;
    my $json = json->new();
    $self->hooksDefinition($json->load($definition));

    require "$ENV{'PWD'}/$hooks";
    $self->hooksInstance(handlers->new($self, $self->{settings}));
}
sub saveState {
    my ($self) = @_;
    $self->state()->save();
}

# deprecated
sub attach {
    my ($self, $data, $handlers) = @_;
    $self->attachHooks($data, $handlers);
}
sub process {
    my $self = shift;
    $self->utils()->processInput();
}
sub execute {
    my ($self, $cmd, $params) = @_;
    return $self->issueCommand($cmd, $params);
}
sub prompt {
    my $self = shift;
    $self->utils()->displayPrompt();
}

# Getters & setters
sub comm {
    my $self = shift;
    if (@_) {
        $self->{comm} = shift;
    }
    return $self->{comm};
}
sub state {
    my $self = shift;
    if (@_) {
        $self->{state} = shift;
    }
    return $self->{state};
}
sub debug {
    my $self = shift;
    if (@_) {
        $self->{debug} = shift;
    }
    return $self->{debug};
}
sub utils {
    my $self = shift;
    if (@_) {
        $self->{utils} = shift;
    }
    return $self->{utils};
}
sub result {
    my $self = shift;
    if (@_) {
        $self->{result} = shift;
    }
    return $self->{result};
}
sub hooksDefinition{
    my $self = shift;
    if (@_) {
        $self->{hooksDefinition} = shift;
    }
    return $self->{hooksDefinition};
}
sub hooksInstance{
    my $self = shift;
    if (@_) {
        $self->{hooksInstance} = shift;
    }
    return $self->{hooksInstance};
}
1;
