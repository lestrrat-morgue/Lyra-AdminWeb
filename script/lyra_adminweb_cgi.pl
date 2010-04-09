#!/usr/bin/env perl

use Catalyst::ScriptRunner;
Catalyst::ScriptRunner->run('Lyra::AdminWeb', 'CGI');

1;

=head1 NAME

lyra_adminweb_cgi.pl - Catalyst CGI

=head1 SYNOPSIS

See L<Catalyst::Manual>

=head1 DESCRIPTION

Run a Catalyst application as a cgi script.

=head1 AUTHORS

Catalyst Contributors, see Catalyst.pm

=head1 COPYRIGHT

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

