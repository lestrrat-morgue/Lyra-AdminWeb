package Lyra::AdminWeb::Model::Asset;
use Moose;
use Lyra::API::Admin::Asset;
use namespace::autoclean;

extends 'Catalyst::Model';

has asset_api => (
    is => 'rw',
    isa => 'Lyra::API::Admin::Asset',
);

sub ACCEPT_CONTEXT {
    my ($self, $c) = @_;
    return $self->asset_api || $self->build_asset_api( $c );
}

sub build_asset_api {
    my ($self, $c) = @_;
    my $asset_api = Lyra::API::Admin::Asset->new(
        async_worker => $c->model('Schwartz'),
    );
    $self->asset_api( $asset_api );
}

__PACKAGE__->meta->make_immutable();

1;
