package Lyra::Worker;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'TheSchwartz::Worker';

our $INSTANCE;

sub initialize {
    my ($class, %args) = @_;
    $INSTANCE ||= $class->new(%args);
}

sub work {
    my ($class, $job) = @_;
    eval {
        $INSTANCE->work_once($job);
    };
    if ($@) {
        $job->add_failure($@);
    } else {
        $job->completed;
    }
}

__PACKAGE__->meta->make_immutable();

1;
