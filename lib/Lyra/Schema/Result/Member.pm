package Lyra::Schema::Result::Member;
use strict;
use warnings;
use base qw(Lyra::Schema::Result);

__PACKAGE__->load_components( qw(UUIDColumns TimeStamp Core) );
__PACKAGE__->table( 'lyra_member' );
__PACKAGE__->add_columns(
    id => {
        data_type => 'CHAR',
        size => 36,
        dynamic_default_on_create => 'uuid',
        is_nullable => 0,
    },
    email => {
        data_type => 'CHAR',
        size => 72,
        is_nullable => 0,
    },
    password => {
        data_type => 'CHAR',
        size => 40,
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
__PACKAGE__->add_unique_constraint(unique_email => [ 'email' ]);
__PACKAGE__->uuid_columns('id');
__PACKAGE__->has_many('roles' => 'Lyra::Schema::Result::MemberRole' => 'member_id');

1;