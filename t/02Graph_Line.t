#!/usr/bin/perl -w
# Test building Line graphs

use strict;
use Test::More tests => 19;
use Data::Dumper;

use Text::Graph;
use Text::Graph::DataSet;

my $dset = Text::Graph::DataSet->new( [1 .. 4, 10, 20, 5],
                                   [ qw/Monday Tuesday Wednesday Thursday
				        Friday Saturday Sunday/ ]
				 );
my $graph = Text::Graph->new( 'Line' );

my @expected = (
                '',
                '*',
                ' *',
                '  *',
                '        *',
                '                  *',
                '   *',
               );

my $out = $graph->make_lines( $dset );

is_deeply( $out, \@expected, "Default Line" );

@expected = (
             'Monday    :',
             'Tuesday   :*',
             'Wednesday : *',
             'Thursday  :  *',
             'Friday    :        *',
             'Saturday  :                  *',
             'Sunday    :   *',
            );

$out = $graph->make_labelled_lines( $dset );

is_deeply( $out, \@expected, "Default Line graph" );

my $expected = join( "\n", @expected, '' );

$out = $graph->to_string( $dset );

is( $out, $expected, "Default Line graph" );

# test right-justified labels
$expected = <<'EOF';
   Monday :
  Tuesday :*
Wednesday : *
 Thursday :  *
   Friday :        *
 Saturday :                  *
   Sunday :   *
EOF

# Raw numbers, not a dataset
$out = $graph->make_labelled_lines( [1 .. 4, 10, 20, 5] );

my @unlabelledExpected = (
             ' :',
             ' :*',
             ' : *',
             ' :  *',
             ' :        *',
             ' :                  *',
             ' :   *',
            );


is_deeply( $out, \@unlabelledExpected, "Make lines without a dataset object" );

$expected = join( "\n", @unlabelledExpected, '' );

$out = $graph->to_string( [1 .. 4, 10, 20, 5] );

is( $out, $expected, "Graph without a dataset object." );

# test right-justified labels
$expected = <<'EOF';
   Monday :
  Tuesday :*
Wednesday : *
 Thursday :  *
   Friday :        *
 Saturday :                  *
   Sunday :   *
EOF


$graph = Text::Graph->new( 'Line', right => 1 );

$out = $graph->to_string( $dset );

is( $out, $expected, "right justified labels" );

# test different separator
$expected = <<'EOF';
Monday   |
Tuesday  |*
Wednesday| *
Thursday |  *
Friday   |        *
Saturday |                  *
Sunday   |   *
EOF

$graph = Text::Graph->new( 'Line', separator => '|' );

$out = $graph->to_string( $dset );

is( $out, $expected, "different separator" );

# test showing values
$expected = <<'EOF';
Monday    :                      (1)
Tuesday   :*                     (2)
Wednesday : *                    (3)
Thursday  :  *                   (4)
Friday    :        *             (10)
Saturday  :                  *   (20)
Sunday    :   *                  (5)
EOF

$graph = Text::Graph->new( 'Line', showval => 1 );

$out = $graph->to_string( $dset );

is( $out, $expected, "showing values" );

# test different marker
$expected = <<'EOF';
Monday    :
Tuesday   :+
Wednesday : +
Thursday  :  +
Friday    :        +
Saturday  :                  +
Sunday    :   +
EOF

$graph = Text::Graph->new( 'Line', marker => '+' );

$out = $graph->to_string( $dset );

is( $out, $expected, "+ as marker" );

# test different fill
$expected = <<'EOF';
Monday    :
Tuesday   :*
Wednesday :.*
Thursday  :..*
Friday    :........*
Saturday  :..................*
Sunday    :...*
EOF

$graph = Text::Graph->new( 'Line', fill => '.' );

$out = $graph->to_string( $dset );

is( $out, $expected, ". as fill" );

# test min/max value
$expected = <<'EOF';
Monday    :*
Tuesday   : *
Wednesday :  *
Thursday  :   *
Friday    :         *
Saturday  :              *
Sunday    :    *
EOF

$graph = Text::Graph->new( 'Line', minval => 0, maxval => 15 );

$out = $graph->to_string( $dset );

is( $out, $expected, "min/max values" );

# test max len
$expected = <<'EOF';
Monday    :
Tuesday   :*
Wednesday :*
Thursday  : *
Friday    :    *
Saturday  :         *
Sunday    : *
EOF

$graph = Text::Graph->new( 'Line', minval => 0, maxlen => 10 );

$out = $graph->to_string( $dset );

is( $out, $expected, "showing values" );

# test maxval
$expected = <<'EOF';
Monday    :
Tuesday   :*
Wednesday : *
Thursday  :  *
Friday    :        *
Saturday  :                  *
Sunday    :   *
EOF

$graph = Text::Graph->new( 'Line', maxval => 20 );

$out = $graph->to_string( $dset );

is( $out, $expected, "maxval only" );

# test log chart
$expected = <<'EOF';
Monday    :    *
Tuesday   :*
Wednesday : *
Thursday  : *
Friday    :  *
Saturday  :   *
Sunday    :
EOF

$dset = Text::Graph::DataSet->new( [1000, 20, 30, 40, 100, 200, 5],
                                [ qw/Monday Tuesday Wednesday Thursday
		                     Friday Saturday Sunday/ ]
				 );
$graph = Text::Graph->new( 'Line', log => 1 );

$out = $graph->to_string( $dset );

is( $out, $expected, "log graph" );


# test log chart with data display
$expected = <<'EOF';
Monday    :    *   (1000)
Tuesday   :*       (20)
Wednesday : *      (30)
Thursday  : *      (40)
Friday    :  *     (100)
Saturday  :   *    (200)
Sunday    :        (5)
EOF

$graph = Text::Graph->new( 'Line', log => 1, showval => 1 );

$out = $graph->to_string( $dset );

is( $out, $expected, "log graph, showing values" );

# test log chart with 0 minval
$expected = <<'EOF';
Monday    :      *
Tuesday   :  *
Wednesday :  *
Thursday  :   *
Friday    :    *
Saturday  :    *
Sunday    : *
EOF

$dset = Text::Graph::DataSet->new( [1000, 20, 30, 40, 100, 200, 5],
                                [ qw/Monday Tuesday Wednesday Thursday
		                     Friday Saturday Sunday/ ]
				 );
$graph = Text::Graph->new( 'Line', log => 1, minval => 0 );

$out = $graph->to_string( $dset );

is( $out, $expected, "log graph, 0 minval" );

# test log chart with 1 minval
$expected = <<'EOF';
Monday    :      *
Tuesday   :  *
Wednesday :  *
Thursday  :   *
Friday    :    *
Saturday  :    *
Sunday    : *
EOF

$dset = Text::Graph::DataSet->new( [1000, 20, 30, 40, 100, 200, 5],
                                [ qw/Monday Tuesday Wednesday Thursday
		                     Friday Saturday Sunday/ ]
				 );
$graph = Text::Graph->new( 'Line', log => 1, minval => 1 );

$out = $graph->to_string( $dset );

is( $out, $expected, "log graph, 1 minval" );

# test log chart with 1 minval and 1000 maxval
$expected = <<'EOF';
Monday    :      *
Tuesday   :  *
Wednesday :  *
Thursday  :   *
Friday    :    *
Saturday  :    *
Sunday    : *
EOF

$dset = Text::Graph::DataSet->new( [1000, 20, 30, 40, 100, 200, 5],
                                [ qw/Monday Tuesday Wednesday Thursday
		                     Friday Saturday Sunday/ ]
				 );
$graph = Text::Graph->new( 'Line', log => 1, minval => 1, maxval => 1000 );

$out = $graph->to_string( $dset );

is( $out, $expected, "log graph, minval and maxval" );

# test clip both ends of range
$expected = <<'EOF';
Monday    :
Tuesday   :
Wednesday :*
Thursday  : *
Friday    :       *
Saturday  :         *
Sunday    :  *
EOF

$dset = Text::Graph::DataSet->new( [1 .. 4, 10, 20, 5],
                                   [ qw/Monday Tuesday Wednesday Thursday
				        Friday Saturday Sunday/ ]
				 );
$graph = Text::Graph->new( 'Line', minval => 2, maxval => 12 );

$out = $graph->to_string( $dset );

is( $out, $expected, "clip both ends" );

