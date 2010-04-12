package App::Lyra::Worker;
use Moose;
use TheSchwartz;
use Lyra::Extlib;
use namespace::autoclean;

with qw(MooseX::Getopt MooseX::SimpleConfig);

has '+configfile' => (
    default => './lyra_worker.yaml'
);

has databases => (
    traits => [ 'NoGetopt' ],
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
);

has worker_classes => (
    traits => [ 'NoGetopt' ],
    is => 'ro',
    isa => 'ArrayRef',
    required => 1,
);

sub run {
    my $self = shift;

    my $client = TheSchwartz->new(
        databases => $self->databases,
    );
    foreach my $class (@{ $self->worker_classes }) {
        my $args;
        if (ref $class eq 'HASH') {
            $args  = $class;
            $class = delete $args->{class};
        } else {
            $args  = {};
        }
        Class::MOP::load_class($class);
        my $worker = $class->initialize(
            app => $self,
            %$args,
        );
        $client->can_do($class);
    }

    $client->work;
}

1;

__END__

=head1 SYNOPSIS

    databases:
        - dsn: dbi:mysql:dbname=worker1
          user: ...
          pass: ...
        - dsn: dbi:mysql:dbname=worker2
          user: ...
          pass: ...
    worker_classes:
        - My::Worker1
        - My::Worker2

=cut