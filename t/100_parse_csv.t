use strict;
use Test::More;
use Lyra::Extlib;
use Lyra::Test qw(dbic_schema);

use_ok "Lyra::Worker::ProcessCSV";


my $schema = dbic_schema();

eval {
    my $worker = Lyra::Worker::ProcessCSV->new(
        schema => $schema,
    );

    $worker->parse_and_store( 't/100_parse_csv.csv', '0e2feb66-45e0-11df-afbd-37ecf713782' );
};
ok( !$@, "Should be no error: ($@)" );
done_testing;