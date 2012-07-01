use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::comm') };
require_ok('lib::comm');

my $link = new comm();

isa_ok($link, 'comm', 'Object correctly instantiated');

is($link->version(), 2, 'version OK');
is($link->revision(), 1, 'version OK');

