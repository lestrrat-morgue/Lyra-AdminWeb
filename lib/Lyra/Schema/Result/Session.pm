package Lyra::Schema::Result::Session;
use strict;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('lyra_sessions');
__PACKAGE__->add_columns(
    id => {
        data_type => 'CHAR',
        size => 72,
        is_nullable => 0,
    },
    session_data => {
        data_type => 'TEXT',
    },
    expires => {
        data_type => 'INT',
        size => 8,
    }
);
__PACKAGE__->set_primary_key('id');

1;
