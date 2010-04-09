#!/usr/bin/env perl
use strict;
use warnings;
use Lyra::AdminWeb;

Lyra::AdminWeb->setup_engine('PSGI');
my $app = sub { Lyra::AdminWeb->run(@_) };

