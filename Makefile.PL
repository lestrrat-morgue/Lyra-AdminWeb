#!/usr/bin/env perl
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Lyra-AdminWeb';
all_from 'lib/Lyra/AdminWeb.pm';

requires 'Catalyst::Runtime' => '5.80021';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Authentication::Credential::Password';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Model::DBIC::Schema';
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::DBI';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode';
requires 'Catalyst::View::TT';
requires 'DBIx::Class';
requires 'DBIx::Class::TimeStamp';
requires 'HTML::FormHandler';
requires 'Moose';
requires 'namespace::autoclean';
test_requires 'Test::More' => '0.88';

catalyst;

bundle_local_lib;
auto_set_repository;

postamble <<EOM;
gitmodules:
\tcd modules/core && \$(FULLPERLRUN) Makefile.PL && make
EOM

WriteAll;

if (-f 'Makefile') {
    open my $fh, '+<', 'Makefile' or
        die "Failed to open Makefile: $!";
    my $content = do { local $/; <$fh> };
    seek $fh, 0, 0;

    $content =~ s/pure_all :: config pm_to_blib subdirs linkext/pure_all :: config pm_to_blib subdirs linkext gitmodules/;
    $content =~ s/"-e" "(test_harness\(\$\(TEST_VERBOSE\), )/"-I\$(INST_LIB)" "-I\$(INST_ARCHLIB)" "-Mlocal::lib=extlib" "-Imodules\/core\/lib" "-MLyra::Test=start_daemons" "-e" "my \\\$\$guard = start_daemons; $1't\/lib', /;

    print $fh $content;
    close $fh;
}

