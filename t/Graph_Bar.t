#!/usr/bin/perl
# Test building Bar graphs

use strict;
use warnings;
use Test::More tests => 23;
use Data::Dumper;

use Text::Graph;
use Text::Graph::DataSet;

sub test_dataset
{
    return Text::Graph::DataSet->new(
        [ 1 .. 4, 10, 20, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
}

{
    my $graph = Text::Graph->new( 'Bar' );

    my @expected = ( '', '*', '**', '***', '*********', '*******************', '****', );

    my $out = $graph->make_lines( test_dataset() );

    is_deeply( $out, \@expected, "Default Bars" )
        or note explain $out;
}

{
    my $graph = Text::Graph->new( 'Bar' );

    my @expected = (
        'Monday    :',
        'Tuesday   :*',
        'Wednesday :**',
        'Thursday  :***',
        'Friday    :*********',
        'Saturday  :*******************',
        'Sunday    :****',
    );

    my $dset = test_dataset();
    my $out = $graph->make_labelled_lines( $dset );

    is_deeply( $out, \@expected, "Default Bar graph" )
        or note explain $out;

    my $expected = join( "\n", @expected, '' );
    is( $graph->to_string( $dset ), $expected, "Default Bar graph" );
}

# test right-justified labels
{
    my $graph = Text::Graph->new( 'Bar', right => 1 );

    my $expected = <<'EOF';
   Monday :
  Tuesday :*
Wednesday :**
 Thursday :***
   Friday :*********
 Saturday :*******************
   Sunday :****
EOF
    is( $graph->to_string( test_dataset() ), $expected, "right justified labels" );
}

{
    # test different separator
    my $expected = <<'EOF';
Monday   |
Tuesday  |*
Wednesday|**
Thursday |***
Friday   |*********
Saturday |*******************
Sunday   |****
EOF

    my $graph = Text::Graph->new( 'Bar', separator => '|' );
    is( $graph->to_string( test_dataset() ), $expected, "different separator" );
}

{
    # test showing values
    my $expected = <<'EOF';
Monday    :                      (1)
Tuesday   :*                     (2)
Wednesday :**                    (3)
Thursday  :***                   (4)
Friday    :*********             (10)
Saturday  :*******************   (20)
Sunday    :****                  (5)
EOF

    my $graph = Text::Graph->new( 'Bar', showval => 1 );
    is( $graph->to_string( test_dataset() ), $expected, "showing values" );
}

{
    # test different marker
    my $expected = <<'EOF';
Monday    :
Tuesday   :#
Wednesday :##
Thursday  :###
Friday    :#########
Saturday  :###################
Sunday    :####
EOF

    my $graph = Text::Graph->new( 'Bar', marker => '#' );
    is( $graph->to_string( test_dataset() ), $expected, "# as marker" );
}

{
    # test different fill
    my $expected = <<'EOF';
Monday    :
Tuesday   :*
Wednesday :#*
Thursday  :##*
Friday    :########*
Saturday  :##################*
Sunday    :###*
EOF

    my $graph = Text::Graph->new( 'Bar', fill => '#' );
    is( $graph->to_string( test_dataset() ), $expected, "# as fill" );
}

{
    # test min/max value
    my $expected = <<'EOF';
Monday    :*
Tuesday   :**
Wednesday :***
Thursday  :****
Friday    :**********
Saturday  :***************
Sunday    :*****
EOF

    my $graph = Text::Graph->new( 'Bar', minval => 0, maxval => 15 );
    is( $graph->to_string( test_dataset() ), $expected, "min/max values" );
}

{
    # test max len
    my $expected = <<'EOF';
Monday    :
Tuesday   :*
Wednesday :*
Thursday  :**
Friday    :*****
Saturday  :**********
Sunday    :**
EOF

    my $graph = Text::Graph->new( 'Bar', minval => 0, maxlen => 10 );
    is( $graph->to_string( test_dataset() ), $expected, "showing values" );
}

{
    # test maxval
    my $expected = <<'EOF';
Monday    :
Tuesday   :*
Wednesday :**
Thursday  :***
Friday    :*********
Saturday  :*******************
Sunday    :****
EOF

    my $graph = Text::Graph->new( 'Bar', maxval => 20 );
    is( $graph->to_string( test_dataset() ), $expected, "maxval only" );
}

{
    # test log chart
    my $expected = <<'EOF';
Monday    :*****
Tuesday   :*
Wednesday :**
Thursday  :**
Friday    :***
Saturday  :****
Sunday    :
EOF

    my $dset = Text::Graph::DataSet->new(
        [ 1000, 20, 30, 40, 100, 200, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
    my $graph = Text::Graph->new( 'Bar', log => 1 );
    is( $graph->to_string( $dset ), $expected, "log graph" );
}

{
    # test log chart with data display
    my $expected = <<'EOF';
Monday    :*****   (1000)
Tuesday   :*       (20)
Wednesday :**      (30)
Thursday  :**      (40)
Friday    :***     (100)
Saturday  :****    (200)
Sunday    :        (5)
EOF

    my $dset = Text::Graph::DataSet->new(
        [ 1000, 20, 30, 40, 100, 200, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
    my $graph = Text::Graph->new( 'Bar', log => 1, showval => 1 );
    is( $graph->to_string( $dset ), $expected, "log graph, showing values" );
}

{
    # test log chart with 0 minval
    my $expected = <<'EOF';
Monday    :*******
Tuesday   :***
Wednesday :***
Thursday  :****
Friday    :*****
Saturday  :*****
Sunday    :**
EOF

    my $dset = Text::Graph::DataSet->new(
        [ 1000, 20, 30, 40, 100, 200, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
    my $graph = Text::Graph->new( 'Bar', log => 1, minval => 0 );
    is( $graph->to_string( $dset ), $expected, "log graph, 0 minval" );
}

{
    # test log chart with 1 minval
    my $expected = <<'EOF';
Monday    :*******
Tuesday   :***
Wednesday :***
Thursday  :****
Friday    :*****
Saturday  :*****
Sunday    :**
EOF

    my $dset = Text::Graph::DataSet->new(
        [ 1000, 20, 30, 40, 100, 200, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
    my $graph = Text::Graph->new( 'Bar', log => 1, minval => 1 );
    is( $graph->to_string( $dset ), $expected, "log graph, 1 minval" );
}

{
    # Raw numbers, not a dataset
    my $graph = Text::Graph->new( 'Bar' );
    my @unlabelledExpected =
        ( ' :', ' :*', ' :**', ' :***', ' :*********', ' :*******************', ' :****', );

    my $out = $graph->make_labelled_lines( [ 1 .. 4, 10, 20, 5 ] );

    is_deeply( $out, \@unlabelledExpected, "Not a dataset" )
        or note explain $out;

    my $expected = join( "\n", @unlabelledExpected, '' );
    $out = $graph->to_string( [ 1 .. 4, 10, 20, 5 ] );
    is( $out, $expected, "Not a dataset" );
}

{
    # No fill
    my $graph = Text::Graph->new( 'Bar', fill => '' );
    my $dset = Text::Graph::DataSet->new(
        [ 1 .. 4, 10, 20, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
    my @expected = (
        'Monday    :',
        'Tuesday   :*',
        'Wednesday :**',
        'Thursday  :***',
        'Friday    :*********',
        'Saturday  :*******************',
        'Sunday    :****',
    );

    my $out = $graph->make_labelled_lines( $dset );
    is_deeply( $out, \@expected, "No fill" )
        or note explain $out;

    my $expected = join( "\n", @expected, '' );
    is( $graph->to_string( $dset ), $expected, "No Fill" );
}

{
    # No fill, no marker
    my $graph = Text::Graph->new( 'Bar', fill => '', marker => '' );
    my $dset = test_dataset();
    my @expected = (
        'Monday    :',
        'Tuesday   :',
        'Wednesday :',
        'Thursday  :',
        'Friday    :',
        'Saturday  :',
        'Sunday    :',
    );

    my $out = $graph->make_labelled_lines( $dset );

    is_deeply( $out, \@expected, "No fill or marker" )
        or note explain $out;

    my $expected = join( "\n", @expected, '' );
    is( $graph->to_string( $dset ), $expected, "No Fill or marker" );
}

{
    # test log chart with 1 minval and 1000 maxval
    my $expected = <<'EOF';
Monday    :*******
Tuesday   :***
Wednesday :***
Thursday  :****
Friday    :*****
Saturday  :*****
Sunday    :**
EOF

    my $dset = Text::Graph::DataSet->new(
        [ 1000, 20, 30, 40, 100, 200, 5 ],
        [
            qw/Monday Tuesday Wednesday Thursday
                Friday Saturday Sunday/
        ]
    );
    my $graph = Text::Graph->new( 'Bar', log => 1, minval => 1, maxval => 1000 );
    is( $graph->to_string( $dset ), $expected, "log graph, minval and maxval" );
}

{
    # test clip both ends of range
    my $expected = <<'EOF';
Monday    :
Tuesday   :
Wednesday :*
Thursday  :**
Friday    :********
Saturday  :**********
Sunday    :***
EOF

    my $graph = Text::Graph->new( 'Bar', minval => 2, maxval => 12 );
    is( $graph->to_string( test_dataset() ), $expected, "clip both ends" );
}
