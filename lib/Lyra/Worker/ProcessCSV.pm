package Lyra::Worker::ProcessCSV;
use Moose;
use Text::CSV_XS;
use Sys::Hostname ();
use namespace::autoclean;

extends 'Lyra::Worker';

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
    if ($hostname ne Sys::Hostname::hostname()) {
        # copy from $hostname
    }

    my $csv = $self->csv_parser();
    open( my $fh, '<', $filename ) or
        die "Could not open $filename : $!";

    # most likely this is in CP932
    binmode( $fh, ':encoding(cp932)' );

    # start txn
warn "START $filename";

    while ( my $row = $csv->getline($fh) ) {
        # write to database
use Data::Dumper;
warn Dumper($row);
    }

    if (! $csv->eof) {
        die $csv->error_diag;
    }

    unlink $filename;

}

1;
