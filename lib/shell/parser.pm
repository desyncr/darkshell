package parser;
use strict;
use warnings;
use lib::logger;
use lib::base;
our @ISA = qw(logger base);

sub new {
    my ($class) = @_;
    
    my $self = $class->SUPER::new();
    my $child = {
        version => 1,
        revision => 1,      
    };
    foreach (keys %$child) {
        $self->{$_} = $child->{$_};
    }
    bless $self, $class;
}

sub parse {
    my ($self, $cmd) = @_;

    my (@item, $command, @params);
    @item = split (/[\'\"]/, $cmd);
    if ($#item == 0) {
        @item = split (/[ ;]/, $cmd);   
    }

    $item[0] =~ s/\s//g;
    chomp($command = $item[0]);
    foreach (@item) {
        $_ =~ s/\s+$//g;
        $_ =~ s/^\s+//g;
        push(@params, $_ );
    }
    shift(@params);
    
    return {command => $command, params => \@params};   
}
1;
