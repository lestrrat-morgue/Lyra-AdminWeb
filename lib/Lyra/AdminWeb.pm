package Lyra::AdminWeb;
use Moose;
use Lyra::Extlib;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Catalyst qw/
    -Debug
    ConfigLoader

    Authentication
    Session
    Session::State::Cookie
    Session::Store::DBI
    Static::Simple
    Unicode
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

__PACKAGE__->config(
    name => 'Lyra::AdminWeb',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    default_view => 'TT',
    'Plugin::Session' => {
        dbi_dbh => 'DBIC',
        expires => 3600,
        dbi_table => 'lyra_sessions',
    },
);

# Start the application
__PACKAGE__->setup();

1;
