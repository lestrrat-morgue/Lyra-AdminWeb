package Lyra::AdminWeb;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Catalyst qw/
    -Debug
    Authentication
    ConfigLoader
    Session
    Session::State::Cookie
    Session::Store::File
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
    'Plugin::Authentication' => {
        default_realm => 'debug',
        realms => {
            debug => {
                credential => {
                    class => 'Password',
                    password_field => 'password',
                    password_type => 'clear',
                },
                store => {
                    class => 'Minimal',
                    users => {
                        admin => {
                            password => 'admin',
                            roles => [ qw(admin) ]
                        }
                    }
                }
            }
        }
    }
);

# Start the application
__PACKAGE__->setup();

1;
