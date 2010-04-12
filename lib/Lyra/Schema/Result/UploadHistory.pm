package Lyra::Schema::Result::UploadHistory;
use strict;
use base qw(Lyra::Schema::Result);

__PACKAGE__->load_components( qw(UUIDColumns TimeStamp Core) );
__PACKAGE__->table( 'lyra_upload_history' );
__PACKAGE__->add_columns(
    id => {
        data_type => 'CHAR',
        size => 36,
        is_nullable => 0,
    },
    member_id => {
        data_type => 'CHAR',
        size => 36,
        is_nullable => 0,
    },
    group_id => {
        data_type => 'CHAR',
        size => 36,
        is_nullable => 0,
    },
    job_id => {
        data_type => 'INT',
        is_nullable => 0,
    },
    status => {
        data_type => 'INT',
        is_nullable => 0,
        default_value => 1,
    },
    message => {
        data_type => 'TEXT',
    },
    created_on => {
        data_type => 'DATETIME',
        set_on_create => 1,
        is_nullable => 0,
    },
    modified_on => {
        data_type => 'TIMESTAMP',
        set_on_update => 1,
        set_on_create => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->uuid_columns('id');

1;
