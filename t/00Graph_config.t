#!/usr/bin/perl -w

use strict;
use Test::More tests => 29;
use Data::Dumper;

use Text::Graph;

# test default construction
my $graph = Text::Graph->new( 'Bar' );

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*', "Default Bar marker" );
is( $graph->get_fill, '*', "Default Bar fill" );
is( $graph->get_line, ' ', "Default Bar line" );

# test Line construction
$graph = Text::Graph->new( 'Line' );

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*', "Default Line marker" );
is( $graph->get_fill, ' ', "Default Line fill" );
is( $graph->get_line, '.', "Default Line line" );

# Test complete configuration
$graph = Text::Graph->new( 'Bar', marker => '+', fill => '-', line => ',',
                                  log => 1,
				  maxval => 100, minval => 2, maxlen => 50,
				  separator => ' :: ', right => 1,
				  showval => 1);

is( $graph->get_marker, '+', "New marker" );
is( $graph->get_fill, '-', "New fill" );
is( $graph->get_line, ',', "New line" );

# test Data Display Options
ok( $graph->is_log, "is a log graph" );

# test Data Limit Options
is( $graph->get_maxlen, 50, "max length is correct" );
is( $graph->get_maxval, 100, "max value is correct" );
is( $graph->get_minval, 2, "min value is correct" );

# test Graph Display Options
is( $graph->get_separator, ' :: ', "Separator is set" );
ok( $graph->is_right_justified, "right justified" );
ok( $graph->show_value, "show values" );

# test individual flags
$graph = Text::Graph->new( 'Bar', log => 1 );

# test Data Display Options
ok( $graph->is_log, "Display log" );
ok( !$graph->is_right_justified, "Display labels left justified" );
ok( !$graph->show_value, "Don't show values" );

$graph = Text::Graph->new( 'Bar', right => 1 );

# test Data Display Options
ok( !$graph->is_log, "Display linear" );
ok( $graph->is_right_justified, "Display labels right justified" );
ok( !$graph->show_value, "Don't show values" );

$graph = Text::Graph->new( 'Bar', showval => 1 );

# test Data Display Options
ok( !$graph->is_log, "Display linear" );
ok( !$graph->is_right_justified, "Display labels left justified" );
ok( $graph->show_value, "Show values" );
