package Lyra::Schema::Result::MemberRole;
use strict;
use warnings;
use base qw(Lyra::Schema::Result);

__PACKAGE__->load_components( qw(UUIDColumns TimeStamp Core) );
__PACKAGE__->table( 'lyra_member_role' );
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
    rolename => {
        data_type => 'CHAR',
        size => 32,
        is_nullable => 0,
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
__PACKAGE__->belongs_to('member' => 'Lyra::Schema::Result::Member' => 'member_id');

1;