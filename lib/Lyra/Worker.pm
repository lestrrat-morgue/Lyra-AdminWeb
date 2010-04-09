package Lyra::Worker;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'TheSchwartz::Worker';

our $INSTANCE;

sub work {
    my ($class, $job) = @_;
warn "START @_";
    eval {
    $INSTANCE ||= $class->new();
warn "HERE";
        $INSTANCE->work_once($job);
    };
    if ($@) {
warn "FAILED $@";
        $job->add_failure($@);
    } else {
warn "COMPLETED";
        $job->completed;
    }
}

__PACKAGE__->meta->make_immutable();

1;
