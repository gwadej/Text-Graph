#!/usr/bin/perl -w

use strict;
use Test::More tests => 30;
use Data::Dumper;

BEGIN { use_ok( 'Text::Graph' ); }

can_ok( 'Text::Graph', qw(new get_marker get_fill get_line is_log get_spacing
                          get_maxlen get_maxval get_minval
                          get_separator is_right_justified show_value) );

# test default construction
my $graph = Text::Graph->new();

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*' );
is( $graph->get_fill, '*' );
is( $graph->get_line, ' ' );

# test Data Display Options
ok( !$graph->is_log );
ok( !$graph->get_spacing );

# test Data Limit Options
ok( !defined $graph->get_maxlen );
ok( !defined $graph->get_maxval );
ok( !defined $graph->get_minval );

# test Graph Display Options
is( $graph->get_separator, ' :' );
ok( !$graph->is_right_justified );
ok( !$graph->show_value );

# test Bar construction
$graph = Text::Graph->new( 'Bar' );

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

# test Bar construction
$graph = Text::Graph->new( 'Filled' );

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*' );
is( $graph->get_fill, '.' );
is( $graph->get_line, ' ' );

