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
requires 'Catalyst::Plugin::Authentication';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Session';
requires 'Catalyst::Plugin::Session::State::Cookie';
requires 'Catalyst::Plugin::Session::Store::File';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Plugin::Unicode';
requires 'Catalyst::View::TT';
requires 'HTML::FormHandler';
requires 'Moose';
requires 'namespace::autoclean';
test_requires 'Test::More' => '0.88';

catalyst;

bundle_local_lib;
auto_set_repository;

WriteAll;
