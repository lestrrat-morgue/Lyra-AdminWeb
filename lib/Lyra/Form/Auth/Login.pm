package Lyra::Form::Auth::Login;
use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';

has '+action' => (
    default => '/auth/login'
);

has_field username => (
    label => 'ユーザーID',
    type => 'Text',
    required => 1,
);

has_field password => (
    label => 'パスワード',
    type => 'Password',
    required => 1,
);

has_field submit => (
    type => 'Submit',
    value => 'ログイン',
);

has_field 'next_uri' => (
    type => 'Hidden',
);

__PACKAGE__->meta->make_immutable();

1;
