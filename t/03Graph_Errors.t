#!/usr/bin/perl -w
# Test building graphs with an invalid style.

use strict;
use Test::More tests => 1;
use Data::Dumper;

use Text::Graph;
use Text::Graph::DataSet;

eval {
my $graph = Text::Graph->new( 'Fred' );
};

is( $@, "Unknown style 'Fred'.\n", "A bad style should fail." );

