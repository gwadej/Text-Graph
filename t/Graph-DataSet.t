#!/usr/bin/perl -w

use strict;
use Test::More tests => 28;
use Data::Dumper;

BEGIN { use_ok( 'Text::Graph::DataSet' ); }

can_ok( 'Text::Graph::DataSet', qw(new get_values get_labels) );

# test default construction
my $gdat = Text::Graph::DataSet->new();

ok( defined $gdat, "default constructed" );
isa_ok( $gdat, 'Text::Graph::DataSet' );
my $vals = $gdat->get_values();
is_deeply( $vals, [], "no values by default" );
my $lbls = $gdat->get_labels();
is_deeply( $lbls, [], "no labels by default" );

# test construction with just values
$gdat = Text::Graph::DataSet->new( [ 1..4 ] );

ok( defined $gdat, "just values constructed" );
$vals = $gdat->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $gdat->get_labels();
is_deeply( $lbls, [ ('') x 4 ], "default labels" );

# test construction with values and labels
$gdat = Text::Graph::DataSet->new( [ 1..4 ], [ 'a'..'d' ] );

ok( defined $gdat, "values and labels constructed" );
$vals = $gdat->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $gdat->get_labels();
is_deeply( $lbls, [ 'a' .. 'd' ], "Supplied labels" );

# test construction with values and too few labels
$gdat = Text::Graph::DataSet->new( [ 1..4 ], [ 'a', 'd' ] );

ok( defined $gdat, "values and labels constructed" );
$vals = $gdat->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $gdat->get_labels();
is_deeply( $lbls, [ 'a', 'd', '', '' ], "Supplied too few labels" );

# test get_values
isa_ok( scalar $gdat->get_values(), 'ARRAY', "get_values in scalar context" );
my @vals = $gdat->get_values();
is_deeply( \@vals, $vals, "same values" );

# test get_labels
isa_ok( scalar $gdat->get_labels(), 'ARRAY', "get_labels in scalar context" );
my @lbls = $gdat->get_labels();
is_deeply( \@lbls, $lbls, "same labels" );

# test construction with a hash
$gdat = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 } );

ok( defined $gdat, "constructed from a hash" );
$vals = $gdat->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $gdat->get_labels();
is_deeply( $lbls, [ qw/a bb cac dd/ ], "keys as labels" );

# test construction with a hash with labels
$gdat = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 },
                                [ qw/bb a dd/ ]
                              );

ok( defined $gdat, "constructed from a hash with labels" );
$vals = $gdat->get_values();
is_deeply( $vals, [ 2, 1, 4 ], "values match" );
$lbls = $gdat->get_labels();
is_deeply( $lbls, [ qw/bb a dd/ ], "keys as labels" );


# test construction with a hash with sort
$gdat = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 },
                                sort => sub { sort { $b cmp $a } @_; }
                              );

ok( defined $gdat, "constructed from a hash with sorted keys" );
$vals = $gdat->get_values();
is_deeply( $vals, [ 4, 3, 2, 1 ], "values match" );
$lbls = $gdat->get_labels();
is_deeply( $lbls, [ qw/dd cac bb a/ ], "keys as labels" );

