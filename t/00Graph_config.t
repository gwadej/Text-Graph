#!/usr/bin/perl -w

use strict;
use Test::More tests => 29;
use Data::Dumper;

use Text::Graph;

# test default construction
my $graph = Text::Graph->new( 'Bar' );

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*' );
is( $graph->get_fill, '*' );
is( $graph->get_line, ' ' );

# test Line construction
$graph = Text::Graph->new( 'Line' );

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*' );
is( $graph->get_fill, ' ' );
is( $graph->get_line, '.' );

# Test complete configuration
$graph = Text::Graph->new( 'Bar', marker => '+', fill => '-', line => ',',
                                  log => 1,
				  maxval => 100, minval => 2, maxlen => 50,
				  separator => ' :: ', right => 1,
				  showval => 1);

is( $graph->get_marker, '+' );
is( $graph->get_fill, '-' );
is( $graph->get_line, ',' );

# test Data Display Options
ok( $graph->is_log );

# test Data Limit Options
is( $graph->get_maxlen, 50 );
is( $graph->get_maxval, 100 );
is( $graph->get_minval, 2 );

# test Graph Display Options
is( $graph->get_separator, ' :: ' );
ok( $graph->is_right_justified );
ok( $graph->show_value );

# test individual flags
$graph = Text::Graph->new( 'Bar', log => 1 );

# test Data Display Options
ok( $graph->is_log );
ok( !$graph->is_right_justified );
ok( !$graph->show_value );

$graph = Text::Graph->new( 'Bar', right => 1 );

# test Data Display Options
ok( !$graph->is_log );
ok( $graph->is_right_justified );
ok( !$graph->show_value );

$graph = Text::Graph->new( 'Bar', showval => 1 );

# test Data Display Options
ok( !$graph->is_log );
ok( !$graph->is_right_justified );
ok( $graph->show_value );


