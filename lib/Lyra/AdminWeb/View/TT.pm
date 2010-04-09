package Lyra::AdminWeb::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

Lyra::AdminWeb::View::TT - TT View for Lyra::AdminWeb

=head1 DESCRIPTION

TT View for Lyra::AdminWeb.

=head1 SEE ALSO

L<Lyra::AdminWeb>

=head1 AUTHOR

牧 大輔

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
