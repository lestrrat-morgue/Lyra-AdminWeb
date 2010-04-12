package Lyra::Worker::ProcessCSV;
use Moose;
use Lyra::Extlib;
use Text::CSV_XS;
use Sys::Hostname ();
use namespace::autoclean;

extends 'Lyra::Worker';
with 'Lyra::Trait::WithDBIC';

has csv_parser => (
    is => 'ro',
    isa => 'Text::CSV_XS',
    lazy_build => 1,
);

sub _build_csv_parser {
    return Text::CSV_XS->new({
        binary => 1
    });
}

sub work_once {
    my ($self, $job) = @_;

    my $args = $job->arg;
    my ($hostname, $filename) = split(/:/, $args->[0]);
    my $format = $args->[1];
    my $member_id = $args->[2];
    if ($hostname ne Sys::Hostname::hostname()) {
        # copy from $hostname
    }

    eval {
        $self->parse_and_store( $filename, $member_id );
    };
    if (my $e = $@) {
        $self->resultset('UploadHistory')->search(
            {
                job_id => $job->jobid,
            },
        )->update(
            {
                status => 99,
                message => $e,
            }
        );
        die $e;
    }

    $self->resultset('UploadHistory')->search(
        {
            job_id => $job->jobid,
        },
    )->update(
        {
            status => 0,
        }
    );

    unlink $filename;
}

sub parse_and_store {
    my ($self, $filename, $member_id) = @_;

    my $csv = $self->csv_parser();
    open( my $fh, '<', $filename ) or
        die "Could not open $filename : $!";

    # most likely this is in CP932
    binmode( $fh, ':encoding(cp932)' );

    my $guard  = $self->txn_guard();
    my $rs     = $self->resultset('AdsMaster');

    # start txn
    while ( my $row = $csv->getline($fh) ) {
        my %h;
        @h{ qw(landing_uri title content) } = @$row;
        $rs->create( { %h, member_id => $member_id } );
    }

    if (! $csv->eof) {
        my $message = "Failed to parse CSV file " . $csv->error_diag;
        die $message;
    }

    $guard->commit;
}

1;
