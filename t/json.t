use strict;
use warnings;

use Test::More qw(no_plan);
use Data::Dumper;

BEGIN { use_ok ( 'lib::db::json' ) };
require_ok('lib::db::json');

# Test instantiation
my $db = 't/data.json';

#`:>$db`;
#my $init='\"{hello:world}\"';
#`echo $init>$db`;

my $json = json->new();
isa_ok($json, "json", "Instantiation correct");

# test this
my $data = $json->load($db);
my $test=$data->{test1};
is($test, "Test string 1", "Testing Json 1");
#isa_ok($test, "hashref", "isa ok");

#print $data;
#print Dumper $data;

#die;
# Testing ?

$json->save($data);
$data = $json->load($db);

$data->{hash} = {'mommy' => 'dead'};
$json->save($data);

$data = $json->load($db);
is($data->{hash}{'mommy'}, 'dead', 'IS OK');


# Test that a given string in encoded correctly
my $test_data = "Hello world, Im a lazy programmer.\n\t";
my $expected = $test_data;
my $call = $json->encode($test_data);
is($test_data, $expected, "encode() successfully tested");

$test_data = '{"hello":"World"}';
$expected = {"hello"=>"World"};
$data = $json->decode($test_data);
is($data->{hello}, $expected->{hello}, "encode() successfully tested");
