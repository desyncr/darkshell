use strict;
use warnings;
use Test::More qw(no_plan);

use_ok('lib::base');
require_ok('lib::base');

my $base = new base();
isa_ok($base, 'base', 'OK base');

is($base->version(), 1, "Base version");
is($base->revision(), 1, "Base revision");
