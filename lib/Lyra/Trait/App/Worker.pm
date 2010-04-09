package Lyra::Trait::App::Worker;
use Moose::Role;
use namespace::autoclean;

has funcnames => (
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
    lazy_build => 1,
);

has databases => (
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
);

sub run {
    my $self = shift;

    my $client = TheSchwartz->new(
        databases => $self->database
    );

    foreach my $ability ($self->funcnames) {
        $client->can_do( $ability );
    }
    $client->work;
}

1;
