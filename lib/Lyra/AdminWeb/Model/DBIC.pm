package Lyra::AdminWeb::Model::DBIC;
use Moose;
use namespace::autoclean;

extends 'Catalyst::Model::DBIC::Schema';

has '+schema_class' => (
    default => 'Lyra::Schema',
);

__PACKAGE__->meta->make_immutable();

1;