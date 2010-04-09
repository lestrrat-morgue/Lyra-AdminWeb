package Lyra::AdminWeb::Model::Schwartz;
use Moose;
use TheSchwartz;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Model';
}

has databases => (
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
);

has prioritize => (
    is => 'ro',
    isa => 'Bool',
    default => 1,
);

has schwartz => (
    is => 'ro',
    isa => 'TheSchwartz',
    lazy_build => 1,
);

sub _build_schwartz {
    my $self = shift;
use Data::Dumper;
warn Dumper($self->databases);
    return TheSchwartz->new(
        databases => $self->databases,
        prioritize => $self->prioritize,
    );
}

sub ACCEPT_CONTEXT {
    my $self = shift;
    return $self->schwartz();
}

__PACKAGE__->meta->make_immutable();

1;