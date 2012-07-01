use strict;
use warnings;
use Test::More qw(no_plan);

BEGIN{ use_ok('lib::network::interface::www') };
require_ok('lib::network::interface::www');

my $net = new www();
isa_ok($net, 'www', 'Object correctly instantiated');

is($net->{test}, undef, 'Test test OK');

is($net->{proxy}, undef, "Test proxy");
is($net->{proto}, undef, "Test proto");
is($net->{timeout}, 60, "Test timeout");
is($net->{tries}, 10, "test tries");
is($net->{agent}, 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1', "test agent");
is($net->{config}, './config/', "test config");
is($net->{downloads}, './downloads/', "test downloads");
is($net->{debug}, undef, "test debug");

is($net->version(), 2, "Test version");
is($net->revision(), 1, "Test revision");

is($net->get('http://127.0.0.1/virtual/testShell/echo.php?echo=Hello'), 'Hello',
	'Get OK'
	);

is($net->post('http://127.0.0.1/virtual/testShell/echo.php', {sleep=>'less',empty=>'life'}), 'life|less',
	'Post OK'
	);