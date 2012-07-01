use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('t::testnet') };
require_ok('t::testnet');

my $net = new testnet();

isa_ok($net, 'testnet', 'Object correctly instantiated');

is($net->get('www.google.com'), 'Getting `www.google.com`', 'Getting OK');
is($net->download('www.google.com/favico.ico'), 'Downloading `www.google.com/favico.ico`', 'Downloading OK');

is_deeply($net->post('www.google.com', {sleep => 'less'}),
	'Posting to `www.google.com`', 'Posting OK');

is($net->upload('http://fuck.you/files/', 'rape.jpg'), 'Uploading `rape.jpg` to `http://fuck.you/files/`', 'Uploading OK');
