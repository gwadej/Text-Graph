#!/usr/bin/perl -w

use strict;
use Test::More tests => 35;
use Data::Dumper;

BEGIN { use_ok( 'Text::Graph::DataSet' ); }

can_ok( 'Text::Graph::DataSet', qw(new get_values get_labels) );

# test default construction
my $dset = Text::Graph::DataSet->new();

ok( defined $dset, "default constructed" );
isa_ok( $dset, 'Text::Graph::DataSet' );
my $vals = $dset->get_values();
is_deeply( $vals, [], "no values by default" );
my $lbls = $dset->get_labels();
is_deeply( $lbls, [], "no labels by default" );

# test construction with just values
$dset = Text::Graph::DataSet->new( [ 1..4 ] );

ok( defined $dset, "just values constructed" );
$vals = $dset->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ ('') x 4 ], "default labels" );

# test construction with values and labels
$dset = Text::Graph::DataSet->new( [ 1..4 ], [ 'a'..'d' ] );

ok( defined $dset, "values and labels constructed" );
$vals = $dset->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ 'a' .. 'd' ], "Supplied labels" );

# test construction with values and too few labels
$dset = Text::Graph::DataSet->new( [ 1..4 ], [ 'a', 'd' ] );

ok( defined $dset, "values and labels constructed" );
$vals = $dset->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ 'a', 'd', '', '' ], "Supplied too few labels" );

# test get_values
isa_ok( scalar $dset->get_values(), 'ARRAY', "get_values in scalar context" );
my @vals = $dset->get_values();
is_deeply( \@vals, $vals, "same values" );

# test get_labels
isa_ok( scalar $dset->get_labels(), 'ARRAY', "get_labels in scalar context" );
my @lbls = $dset->get_labels();
is_deeply( \@lbls, $lbls, "same labels" );

# test construction with a hash
$dset = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 } );

ok( defined $dset, "constructed from a hash" );
$vals = $dset->get_values();
is_deeply( $vals, [ 1..4 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ qw/a bb cac dd/ ], "keys as labels" );

# test construction with a hash with labels
$dset = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 },
                                [ qw/bb a dd/ ]
                              );

ok( defined $dset, "constructed from a hash with labels" );
$vals = $dset->get_values();
is_deeply( $vals, [ 2, 1, 4 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ qw/bb a dd/ ], "keys as labels" );


# test construction with a hash with sort
$dset = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 },
                                sort => sub { sort { $b cmp $a } @_; }
                              );

ok( defined $dset, "constructed from a hash with sorted keys" );
$vals = $dset->get_values();
is_deeply( $vals, [ 4, 3, 2, 1 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ qw/dd cac bb a/ ], "keys as labels" );

$dset = Text::Graph::DataSet->new( hash => { a => 1, bb => 2, cac => 3, dd => 4 },
                                sort => sub { sort { $b cmp $a } @_; }
                              );
ok( defined $dset, "constructed from a hash with sorted keys" );
$vals = $dset->get_values();
is_deeply( $vals, [ 4, 3, 2, 1 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( $lbls, [ qw/dd cac bb a/ ], "keys as labels" );


$dset = Text::Graph::DataSet->new( { a => 1, bb => 2, cac => 3, dd => 4 },
                                sort => undef
                              );
ok( defined $dset, "constructed from a hash with keys" );
$vals = $dset->get_values();
is_deeply( [ sort @{$vals} ], [ 1, 2, 3, 4 ], "values match" );
$lbls = $dset->get_labels();
is_deeply( [ sort @{$lbls} ], [ qw/a bb cac dd/ ], "keys as labels" );

eval {
    $dset = Text::Graph::DataSet->new( 10 );
};

ok( $@, "invalid number of parameters" );
