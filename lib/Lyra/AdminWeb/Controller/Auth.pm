package Lyra::AdminWeb::Controller::Auth;
use Moose;
use Lyra::Form::Auth::Login;
use namespace::autoclean;
BEGIN {
    extends 'Catalyst::Controller';
}

sub login
    :Local
    :Args(0)
{
    my ($self, $c) = @_;

    my $form = Lyra::Form::Auth::Login->new();
    $c->stash( form => $form );

    if ($c->req->method eq 'POST') {
        $form->process(params => $c->req->params);
        if ($form->validated) {
            if ($c->authenticate({
                password => $form->field('password')->value,
                email => $form->field('email')->value,
            } ) ) {
                my $next_uri = URI->new($form->field('next_uri')->value || '/');
                $next_uri->scheme(undef);
                $next_uri->host(undef) if $next_uri->can('host');
                $next_uri->port(undef) if $next_uri->can('port');
            
                $c->res->redirect( $c->uri_for( "$next_uri" ) );
                return;
            }
        }
    } else {
        $form->field('next_uri')->value( $c->req->param('next_uri') || '/' );
    }
}

sub logout
    :Local
    :Args(0)
{
    my ($self, $c) = @_;
    $c->logout;
    $c->res->redirect( $c->uri_for('/') );
}

__PACKAGE__->meta->make_immutable();

1;