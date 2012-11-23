package shellutils;
use lib::shell::parser;
use lib::base;
use lib::logger;
our @ISA = qw(logger base);

sub new {
    my ($class, $settings) = @_;
    my $self = $class->SUPER::new($settings);
    my $child = {
        parser  => new parser(),

        version => 1,
        revision => 1,
    };
    foreach (keys %$child) {
        $self->{$_} = $child->{$_};
    }
    bless $self, $class;
    return $self;
}

sub processInput {
    my ($self, $cmd) = @_;
    $self->log("processInput()");
    my $command;
    if (defined $cmd) {
        chomp($command = $cmd);
    }else{
        undef $command;
        chomp($command = <STDIN>);
    }

    return $self->parser()->parse($command);
}

sub displayPrompt {
    my ($self) = @_;
    print '>';
}

sub hasHook {
    my ($self, $hooks, $cmd, $params) = @_;
    $self->log("hasHook (..,$cmd,..)");
    if (!defined($hooks->{$cmd})) {
        return 0;
    }else{
        return $hooks->{$cmd};
    }
}

sub callHook {
    my ($self, $instance, $cmd, $params) = @_;
    $self->log("callHook(.., $cmd, ..)");
    return $instance->$cmd($params);
}

# Getters and setters
sub parser {
    my $self = shift;
    if (@_) {
        $self->{parser} = shift;
    }
    return $self->{parser};
}
1;