package Lyra::AdminWeb::Controller::Asset;
use Moose;
use Data::UUID;
use Lyra::Form::Asset::AdUpload;
use Sys::Hostname ();
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
    with 'Lyra::Trait::Catalyst::Controller::WithAuth';
}

has data_dir => (
    is => 'ro',
    isa => 'Str',
    required => 1,
);

has uuid_gen => (
    is => 'ro',
    isa => 'Data::UUID',
    lazy_build => 1,
);

sub _build_uuid_gen {
    return Data::UUID->new();
}

sub ad_upload
    :Path('/asset/ad/upload')
    :Args(0)
{
    my ($self, $c) = @_;

    my $req = $c->req;
    my $format = $req->param('format') || 'default';

    my $form = Lyra::Form::Asset::AdUpload->new();
    $c->stash(form => $form);

    # XXX include HTML::FormHandler
    if ($req->method eq 'POST') {
        my $group_id = $self->uuid_gen->create_str();
        foreach my $upload ($req->upload('file')) {
            my $uniqkey = $self->uuid_gen->create_str();
            my $dest = File::Spec->catfile( $self->data_dir, $uniqkey );
            $upload->copy_to( $dest );
            my $job = $c->model('Asset')->process_csv_async({
                filename => $dest,
                uniqkey  => $uniqkey,
                group_id => $group_id,
                format   => $format,
            });

            if (! $job) {
                confess "Could not insert job to any database";
            }
        }

        $c->res->redirect(
            $c->uri_for( '/asset/ad/processing', {
                job => $group_id,
            } )
        );
    }
}


__PACKAGE__->meta->make_immutable();

1;
