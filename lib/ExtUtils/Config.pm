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

sub set {
	my ($self, $key, $val) = @_;
	$self->{values}{$key} = $val;
}

sub clear {
	my ($self, $key) = @_;
	return delete $self->{values}{$key};
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

1;

__END__

# ABSTRACT: A wrapper for perl's configuration

=head1 SYNOPSIS

 my $config = ExtUtils::Config->new();
 $config->set('installsitelib', "$ENV{HOME}/lib");

=head1 DESCRIPTION

ExtUtils::Config is an abstraction around the %Config hash.

=method new(\%config)

Create a new ExtUtils::Config object. The values in C<\%config> are used to initialize the object.

=method get($key)

Get the value of C<$key>. If not overriden it will return the value in %Config.

=method exists($key)

Tests for the existence of $key in either .

=method set($key, $value)

Set/override the value of C<$key> to C<$value>.

=method clear($key)

Reset the value of C<$key> to its original value.

=method values_set

Get a hashref of all overridden values.

=method all_config

Get a hashref of the complete configuration, including overrides.
