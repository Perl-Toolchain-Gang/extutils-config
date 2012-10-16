package ExtUtils::Config;

use strict;
use warnings;
use Config;
use Data::Dumper ();

sub new {
	my ($pack, $args) = @_;
	return bless {
		values => ($args ? { %$args } : {}),
	}, $pack;
}

sub clone {
	my $self = shift;
	return __PACKAGE__->new($self->{values});
}

sub get {
	my ($self, $key) = @_;
	return exists $self->{values}{$key} ? $self->{values}{$key} : $Config{$key};
}

sub set {
	my ($self, $key, $val) = @_;
	$self->{values}{$key} = $val;
	delete $self->{serialized};
	return;
}

sub clear {
	my ($self, $key) = @_;
	delete $self->{values}{$key};
	delete $self->{serialized};
	return;
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
	return $self->{serialized} ||= Data::Dumper->new([$self->values_set])->Terse(1)->Sortkeys(1)->Dump;
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

Tests for the existence of $key.

=method set($key, $value)

Set/override the value of C<$key> to C<$value>.

=method clear($key)

Reset the value of C<$key> to its original value.

=method values_set()

Get a hashref of all overridden values.

=method all_config()

Get a hashref of the complete configuration, including overrides.

=method clone()

Clone the current configuration object.

=method serialize()

This method serializes the object to some kind of string.

