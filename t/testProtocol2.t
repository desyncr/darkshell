use strict;
use warnings;
use Test::More qw(no_plan);
use t::testnet;

BEGIN{ use_ok('lib::protocol2::protocol') };
require_ok('lib::protocol2::protocol');

my $net = new testnet();

my $protocol = new protocol(
	{protocol=>'raw', network=>$net}
	);

isa_ok($protocol, 'protocol', 'Object correctly instantiated');

my $derp = {url=>'http://localhost/', auth=>{user=>'asphyxia',password=>'123'}};

is_deeply($protocol->auth($derp),
	{response=>'Posting to `http://localhost/`'}, 'Auth OK'
	);

