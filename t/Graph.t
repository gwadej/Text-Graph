#!/usr/bin/perl -w

use strict;
use Test::More tests => 14;
use Data::Dumper;

BEGIN { use_ok( 'Text::Graph' ); }

can_ok( 'Text::Graph', qw(new get_marker get_fill get_line is_log
                          get_maxlen get_maxval get_minval
                          get_separator is_right_justified show_value
			  make_lines to_string) );

# test default construction
my $graph = Text::Graph->new();

ok( defined $graph, "default constructed" );
isa_ok( $graph, 'Text::Graph' );
is( $graph->get_marker, '*' );
is( $graph->get_fill, '*' );
is( $graph->get_line, ' ' );

# test Data Display Options
ok( !$graph->is_log );

# test Data Limit Options
ok( !defined $graph->get_maxlen );
ok( !defined $graph->get_maxval );
ok( !defined $graph->get_minval );

# test Graph Display Options
is( $graph->get_separator, ' :' );
ok( !$graph->is_right_justified );
ok( !$graph->show_value );

