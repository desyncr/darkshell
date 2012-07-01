use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::logger') };
require_ok('lib::logger');

my $logger = new logger({echo => 1, verbosity=>1});
isa_ok($logger, 'logger', 'Object correctly instantiated');

is($logger->version(), 1, 'Version OK');
is($logger->revision(), 1, 'Revision OK');

is($logger->verbosity(), '1', 'verbosity OK');
is($logger->logfile(), undef, 'Log file OK');

like($logger->log('shit'), qr/.*shit/, 'Log OK');