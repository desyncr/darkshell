use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::state') };
require_ok('lib::state');

my $state = new state();

isa_ok($state, 'state', 'OK ISA_OK state');

$state->version(1);
is($state->version, 1, 'OK setting');

is($state->spec(),'config/state.json','OK spec');

$state->spec('t/state.json');
is($state->spec(), 't/state.json', 'OK spec 2');


$state->load();
is($state->get("stateTest"), "1234", 'OK Test Get');

$state->set("44444", "4321");
is($state->get("44444"), "4321", 'OK Test Set/Get 2');
