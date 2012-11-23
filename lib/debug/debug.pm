package debug;
use Data::Dumper;

use lib::base;
use base qw(base);

sub new
{
    my ($class, $settings) = @_;
    my ($filename, $dirname, $fullpath);
    if ($settings->{log}) {
        $filename    = $settings->{log}         || $class . ".log";
        $dirname     = $settings->{directory}   || "./log/";
        $fullpath    = "$dirname$filename";
    }

    my $self = {
        label           => $class,
        logfile         => $filename,
        dirname         => $dirname,
        fullpath        => $fullpath,
        verbosity       => $settings->{verbosity} || 0,
        handle          => eval("DEBUG" . `echo \$RANDOM`),
        echo            => $settings->{echo}  || undef,
        debug           => $settings->{verbosity} || undef,

        version         => 1,
        revision        => 2,
    };
    bless $self, $class;
}

sub openlog {
    my ($self, $file) = @_;
    if ($self->{handle}) {
        $self->closelog();
    }
    open($self->{handle}, ">>" . $self->fullpath()) || print $!;
}
sub closelog {
    my $self = shift;
    if ($self->{handle}) {
        close ($self->{handle}) || print $!;
    }
}
sub dump
{
    my ($self, $msg, $dump) = @_;
    my ($logfile);
    if ($self->{logfile}) {
        $logfile = "[ $self->{logfile} ]";
    }
    $message = '[ ' . scalar localtime(time()) . " ][ $self->{label} ]$logfile $msg\n";
    if ($self->{verbosity} >= 1)
    {
        print $message;
        print Dumper $dump;
    }
    if ($self->{log}) {
        print { $self->{handle} } $message;
        print { $self->{handle} } Dumper $dump;
    }
    if ($self->{echo}) {
        return {message => $message,
                dump => Dumper $dump};
    }
    
}
sub log
{
    my ($self, $message) = @_;
    my ($logfile);
    if ($self->{logfile}) {
        $logfile = "[ $self->{logfile} ]";
    }
    #[ Fri Nov 4 04:10:47 2011 ] Connecting through 127.0.0.1:80
    $message = '[ ' . scalar localtime(time()) . " ][ $self->{label} ]$logfile $message\n";

    if ($self->{verbosity} >= 1)
    {
        print $message;
    }
    if ($self->{log}) {
        print {$self->{handle}} $message;
    }
    if ($self->{echo}) {
        return $message;
    }
}

# Getters and setters
sub logfile {
    my $self = shift;
    if (@_) {
        $self->{logfile} = shift;
    }
    return $self->{logfile};
}
sub dirname {
    my $self = shift;
    if (@_) {
        $self->{dirname} = shift;
    }
    return $self->{dirname};
}
sub fullpath {
    my $self = shift;
    if (@_) {
        $self->{fullpath} = shift;
    }
    return $self->{fullpath};
}
sub verbosity {
    my $self = shift;
    if (@_) {
        $self->{verbosity} = shift;
    }
    return $self->{verbosity};
}

1;