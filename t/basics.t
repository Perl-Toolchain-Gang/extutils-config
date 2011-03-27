#!/usr/bin/perl -w

use strict;
use warnings FATAL => 'all';
use Test::More tests => 10;

use Config;

use ExtUtils::Config;

is(ExtUtils::Config->get('config_args'), $Config{config_args}, "'config_args' is the same for ExtUtils::Config");

my $config = ExtUtils::Config->new;

is($config->get('config_args'), $Config{config_args}, "'config_args' is the same for \$config");

ok(!defined $config->get('nonexistent'), "'nonexistent' is nonexistent");

is_deeply($config->all_config, \%Config, 'all_config is \%Config');

{
	my %myconfig = %Config;
	$config->set('more', 'nomore');
	$myconfig{more} = 'nomore';

	is_deeply($config->values_set, { more => 'nomore' }, 'values_set is { more => \'nomore\'}');

	is_deeply($config->all_config, \%myconfig, 'allconfig is myconfig');
}

$config->pop('more');

is_deeply($config->all_config, \%Config, 'all_config is \%Config again');

$config->push('more', 'more1');
$config->push('more', 'more2');

is($config->get('more'), 'more2', "'more' is now 'more2");
$config->pop('more');
is($config->get('more'), 'more1', "'more' is now 'more1");

my $config2 = ExtUtils::Config->new(values => { more => 'more3'});

is_deeply($config2->values_set, { more => 'more3' }, "\$config2 has 'more' set to 'more3'");
