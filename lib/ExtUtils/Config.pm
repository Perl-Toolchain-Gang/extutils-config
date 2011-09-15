package ExtUtils::Config;

use strict;
use warnings;
use Config;

sub new {
	my ($pack, $args) = @_;
	return bless {
		stack => {},
		values => $args || {},
	}, $pack;
}

sub get {
	my ($self, $key) = @_;
	return $self->{values}{$key} if ref($self) && exists $self->{values}{$key};
	return $Config{$key};
}

sub set {
	my ($self, $key, $val) = @_;
	$self->{values}{$key} = $val;
}

sub exists {
	my ($self, $key) = @_;
	return (ref $self && exists $self->{values}{$key}) || exists $Config{$key};
}

sub push {
	my ($self, $key, $val) = @_;
	push @{$self->{stack}{$key}}, $self->{values}{$key} if exists $self->{values}{$key};
	$self->{values}{$key} = $val;
}

sub pop {
	my ($self, $key) = @_;

	my $val = delete $self->{values}{$key};
	if ( exists $self->{stack}{$key} ) {
		$self->{values}{$key} = pop @{$self->{stack}{$key}};
		delete $self->{stack}{$key} unless @{$self->{stack}{$key}};
	}

	return $val;
}

sub values_set {
	my $self = shift;
	return undef unless ref($self);
	return { %{$self->{values}} };
}

sub all_config {
	my $self = shift;
	my $v = ref($self) ? $self->{values} : {};
	return {%Config, %$v};
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

Tests for the existence of $key in either 

=method set($key, $value)

Set/override the value of C<$key> to C<$value>.

=method push($key, $value)

Set the value of C<$key> to C<$value> until the next C<pop> of that key.

=method pop($key)

Reset C<$key> to the value it had before the last C<push>.

=method values_set

Get a hashref of all overridden values.

=method all_config

Get a hashref of the complete configuration, including overrides.
