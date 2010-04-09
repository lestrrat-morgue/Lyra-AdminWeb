package Lyra::Form::Asset::AdUpload;
use HTML::FormHandler::Moose;
use namespace::autoclean;

extends 'HTML::FormHandler';

has '+enctype' => (
    default => 'multipart/form-data'
);

has_field file => (
    label => 'ファイル',
    type => 'Upload'
);
has_field submit => (
    type => 'Submit',
    value => 'アップロード'
);

__PACKAGE__->meta->make_immutable();

1;
