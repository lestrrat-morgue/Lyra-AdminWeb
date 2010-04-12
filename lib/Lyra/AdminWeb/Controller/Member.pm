# Members are the people who will be submitting the ads.
# they will submit/modify their ads, and let

package Lyra::AdminWeb::Controller::Member;
use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller';
    with 'Lyra::Trait::Catalyst::Controller::WithAuth';
}

sub index
    :Path :Args(0)
{
    my ($self, $c) = @_;

    my $assets = $c->model('Asset')->load_for({
        member_id => $c->user->id,
    });
    $c->stash(
        assets => $assets
    );
}

__PACKAGE__->meta->make_immutable();

1;
