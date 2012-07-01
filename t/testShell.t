use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::shell::shell') };
require_ok('lib::shell::shell');

my $shell = new shell();

isa_ok($shell, 'shell', 'OK ISA_OK shell');

is($shell->version(), 2, 'version OK');
$shell->version(1);
is($shell->version(), 1, 'OK setting');

#is($shell->promptEx, '`pwd`', 'OK prompt');

$shell->debug('debug test');
is($shell->debug, 'debug test', 'OK debug');

$shell->attachHooks('t/hooksDef.json', 't/handlers.pm');
isnt($shell->hooksDefinition(), "", "OK Hooks defs");
isnt($shell->hooksInstance(), "", "OK Hooks defs");

is($shell->utils()->callHook($shell->hooksInstance(), "TestSub"), "TestSub 1", "OK Test Hook 1");
is($shell->utils()->callHook($shell->hooksInstance(), "TestSub2", "Shittttt"), "Shittttt", "OK Test Hook 2");

is($shell->execute("TestSub2", "Shittt"), "Shittt", "OK Call function");