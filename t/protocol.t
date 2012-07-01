use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::protocol2::protocol') };
require_ok('lib::protocol2::protocol');

my $proto = new protocol({interface => 'raw'});

isa_ok($proto, 'protocol', 'OK ISA_OK protocol');

$proto->{version} = 1;
is($proto->{version}, 1, 'OK setting');
