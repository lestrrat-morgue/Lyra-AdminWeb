package Lyra::API::Admin::Asset;
use Moose;
use TheSchwartz;
use Sys::Hostname ();
use namespace::autoclean;

has async_worker => (
    is => 'ro',
    isa => 'TheSchwartz',
    required => 1,
);

sub process_csv_async {
    my ($self, $args) = @_;

    my $uniqkey = $args->{uniqkey} or
        confess "No uniqkey given";
    my $group_id = $args->{group_id} or 
        confess "No group_id given";
    my $filename = $args->{filename} or
        confess "No filename given";
    my $format = $args->{format} or
        confess "No format given";

    # send processing to the background job queue, and
    # get the job ID

    # Keep the file somewhere safe
    my $job = $self->async_worker->insert(
        TheSchwartz::Job->new(
            uniqkey => $uniqkey,
            funcname => 'Lyra::Worker::ProcessCSV',
            coalesce => $group_id,
            arg => [
                join(':', Sys::Hostname::hostname(), $filename),
                $format,
            ]
        )
    );

    return $job;
}

__PACKAGE__->meta->make_immutable();

1;


