use strict;
use Lyra::Extlib;
use Test::More tests => 2;

use_ok "App::Lyra::DeployDB";

eval {
    # Deploy to master DB
    App::Lyra::DeployDB->new(
        data_source => 'Lyra::Test::Fixture::TestDB',
        drop_table => 1,
    )->run();
};
ok(! $@, "Done deploy") or diag($@);
