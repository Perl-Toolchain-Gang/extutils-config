package ExtUtils::Config;

use strict;
use warnings;
use Config;

sub new {
	my ($pack, $args) = @_;
	return bless {
		values => ($args ? { %$args } : {}),
	}, $pack;
}

sub get {
	my ($self, $key) = @_;
	return exists $self->{values}{$key} ? $self->{values}{$key} : $Config{$key};
}

sub exists {
	my ($self, $key) = @_;
	return exists $self->{values}{$key} || exists $Config{$key};
}

sub values_set {
	my $self = shift;
	return { %{$self->{values}} };
}

sub all_config {
	my $self = shift;
	return { %Config, %{ $self->{values}} };
}

sub serialize {
	my $self = shift;
	require Data::Dumper;
	return $self->{serialized} ||= Data::Dumper->new($self->{values})->Terse(1)->Sortkeys(1)->Dump;
}

sub but {
	my ($self, $args) = @_;
	my %new = %{ $self->{values} };
	for my $key (keys %$args) {
		if (defined $args->{$key}) {
			$new{$key} = $args->{$key}
		}
		else {
			delete $new{$key};
		}
	}
	return bless { values => \%new }, ref $self;
}

1;

# ABSTRACT: A wrapper for perl's configuration

=head1 SYNOPSIS

 my $config = ExtUtils::Config->new();
 $config->get('installsitelib');

=head1 DESCRIPTION

ExtUtils::Config is an abstraction around the %Config hash. By itself it is not a particularly interesting module by any measure, however it ties together a family of modern toolchain modules.

=method new(\%config)

Create a new ExtUtils::Config object. The values in C<\%config> are used to initialize the object.

=method get($key)

Get the value of C<$key>. If not overridden it will return the value in %Config.

=method exists($key)

Tests for the existence of $key.

=method but(\%keys)

This creates a new C<ExtUtils::Config> object based on the current one, but with the values in %keys replacing the current values. Any undefined value means it will be removed from the overriden set.

=method values_set()

Get a hashref of all overridden values.

=method all_config()

Get a hashref of the complete configuration, including overrides.

=method serialize()

This method serializes the object to some kind of string. This can be useful for various caching purposes.
