package Lyra::API::Admin::Asset;
use Moose;
use Data::UUID;
use TheSchwartz;
use Sys::Hostname ();
use namespace::autoclean;

with 'Lyra::Trait::WithDBIC';

has async_worker => (
    is => 'ro',
    isa => 'TheSchwartz',
    required => 1,
);

has data_dir => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has uuid_gen => (
    is => 'ro',
    isa => 'Data::UUID',
    lazy_build => 1,
);

sub _build_uuid_gen {
    return Data::UUID->new();
}

sub process_csv_uploads {
    my ($self, $args) = @_;

    my $format = $args->{format} or
        confess "No format specified for process_csv_uploads"
    ;
    my $uploads = $args->{uploads} or
        confess "No uploads specified for process_csv_uploads"
    ;
    my $member_id = $args->{member_id} or 
        confess "No member_id given";

    my $group_id = $self->uuid_gen->create_str();

    foreach my $upload (@$uploads) {
        my $uniqkey = $self->uuid_gen->create_str();
        my $dest = File::Spec->catfile( $self->data_dir, $uniqkey );
        $upload->copy_to( $dest );

        my $job = $self->process_csv_async({
            filename => $dest,
            uniqkey  => $uniqkey,
            group_id => $group_id,
            format   => $format,
            member_id => $member_id,
        });

        if (! $job) {
            confess "Could not insert job to any database";
        }
    }
    return $group_id;
}

sub process_csv_async {
    my ($self, $args) = @_;

    my $uniqkey = $args->{uniqkey} or
        confess "No uniqkey given";
    my $group_id = $args->{group_id} or 
        confess "No group_id given";
    my $member_id = $args->{member_id} or 
        confess "No member_id given";
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
                $member_id,
            ]
        )
    );

    if ($job) {
        $self->resultset('UploadHistory')->create(
            {
                member_id => $member_id,
                group_id  => $group_id,
                job_id    => $job->jobid,
            }
        );
    }

    return $job;
}

sub load_for {
    my ($self, $args) = @_;

    my @ads = $self->resultset('AdsMaster')->search(
        {
            member_id => $args->{member_id}
        },
    );
    return [ @ads ];
}

__PACKAGE__->meta->make_immutable();

1;


