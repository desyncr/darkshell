#!/usr/bin/perl
use strict;
use warnings;
use HTTP::Request;
use HTTP::Response;
use LWP::UserAgent;
use Test::More qw(no_plan);

my $ua = LWP::UserAgent->new;
my %post = (
		name => 'cunt',
		file => ["1.dat"],
	);

SKIP:{
	skip('because');
my $response = $ua->post("http://localhost/drop.php",
					Content_Type => 'multipart/form-data',
        			Content => [%post]);
print $response->decoded_content;
}