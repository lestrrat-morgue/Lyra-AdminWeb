package Lyra::Trait::Catalyst::Controller::WithAuth;
use MooseX::MethodAttributes::Role;
use namespace::autoclean;

has auth_action => (
    is => 'ro',
    isa => 'Str',
    default => '/auth/login'
);

has default_auth => (
    is => 'ro',
    isa => 'Bool',
    default => 1
);

has authmap => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { +{} },
);

sub auto
    :Private
{
    my ($self, $c) = @_;

    if ($c->user_exists) {
        return 1;
    }

    my $action = $c->action;
    my $action_name = $action->name;

    if ($c->debug) {
        $c->log->debug( "Checing for auth on $action_name with " . blessed $self );
    }

    if (blessed $self ne $action->class) {
        if ($c->debug) {
            $c->log->debug( "Action $action_name should be auth-checked elsewhere than " . blessed $self);
        }
        return 1;
    }

    my $authmap = $self->authmap;
    my $redirect = 0;
    my $redirect_uri = $c->res->redirect(
        $c->uri_for($self->auth_action, { next_uri => $c->req->uri })
    );
    if (exists $authmap->{ $action_name }) {
        if ($authmap->{ $action_name }) {
            $redirect = 1;
        }
    } elsif ($self->default_auth) {
        $redirect = 1;
    }

    if ($redirect) {
        $c->res->redirect( $redirect_uri );
        return ();
    }
    return 1;
}


1;