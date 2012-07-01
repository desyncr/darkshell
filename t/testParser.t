use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::shell::parser') };
require_ok('lib::shell::parser');

my $parser = new parser();

isa_ok($parser, 'parser', 'OK ISA_OK');

is_deeply($parser->parse('echo "shit"'), {command=>'echo', params=>['shit']}, 'parsing OK');

is_deeply($parser->parse('rm -rf * WOOOT'), {command=>'rm', params=>['-rf', '*', 'WOOOT']}, 'parsing OK');

is_deeply($parser->parse('echo \'die\''),
							{command=>'echo', params=>['die']}, 'parsing OK');

is_deeply($parser->parse('OO ""dff \' FFF \'\'d sdfsdf \'\'d \"" dsf ""'),
							{command=>'OO',
							params=>['', 'dff', 'FFF', '', 'd sdfsdf', '', 'd \\', '', 'dsf']},
							'parsing OK');