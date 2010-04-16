package Lyra::AdminWeb::Controller::Asset;
use Moose;
use Lyra::Form::Asset::AdUpload;
use Sys::Hostname ();
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
    with 'Lyra::Trait::Catalyst::Controller::WithAuth';
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
        my $group_id = $c->model('Asset')->process_csv_uploads( {
            format  => $format,
            uploads => [ $req->upload('file') ],
            member_id => $c->user->id,
        } );
        $c->res->redirect(
            $c->uri_for( '/asset/ad/processing', {
                job => $group_id,
            } )
        );
    }
}

sub ad_upload_processing
    :Path('/asset/ad/processing')
{
    my ($self, $c) = @_;

    my $job_id = $c->req->param('job');
    my @jobs = $c->model('DBIC')->resultset('UploadHistory')->search(
        {
            group_id => $job_id
        },
        {
            order_by => 'created_on DESC',
        }
    )->all;
    $c->stash(job_id => $job_id, jobs => \@jobs);
}

__PACKAGE__->meta->make_immutable();

1;
