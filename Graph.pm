package Text::Graph;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '0.21';


sub new
 {
  my $class = shift;
  my $style = shift || 'Bar';

  my $obj = { _initialize($style),
              # data display
	      log       => 0,
	      # data limit
	      maxval    => undef,
	      minval    => undef,
	      maxlen    => undef,
	      # graph display
              separator => ' :',
	      right     => 0,
	      showval   => 0,
              @_
	    };
  $obj->{fill} = $obj->{marker} unless defined $obj->{fill};
  
  bless $obj, $class;
 }

sub _initialize ($)
 {
  my $style = shift;
  my $lstyle = lc $style;

  if('bar' eq $lstyle)
   {
    ( style => 'Bar', marker => '*', line => ' ' );
   }
  elsif('line' eq $lstyle)
   {
    ( style => 'Line', marker => '*', fill => ' ', line => '.' );
   }
  else
   {
    die "Unknown style '$style'.\n";
   }
 }

# Data Display Options
sub  get_marker  ($)  { $_[0]->{marker}; }
sub  get_fill    ($)  { $_[0]->{fill}; }
sub  get_line    ($)  { $_[0]->{line}; }
sub  is_log      ($)  { $_[0]->{log}; }

# Data Limit Options
sub  get_maxlen  ($)  { $_[0]->{maxlen}; }
sub  get_maxval  ($)  { $_[0]->{maxval}; }
sub  get_minval  ($)  { $_[0]->{minval}; }

# Graph Display Options
sub  get_separator ($) { $_[0]->{separator}; }
sub  is_right_justified ($) { $_[0]->{right}; }
sub  show_value    ($) { $_[0]->{showval}; }


sub  make_lines ($;$)
 {
  my $self = shift;
  my $data = _make_graph_data( @_ );

  my @lines = _histogram( $data, $self );

  wantarray ? @lines : \@lines;
 }


sub  make_labelled_lines ($;$)
 {
  my $self = shift;
  my $data = _make_graph_data( @_ );

  my @labels = _fmt_labels( $self->{right}, $data->get_labels() );
  my @lines  = $self->make_lines( $data );
  for(my $i = 0; $i < @lines; ++$i)
   {
    $lines[$i] = $labels[$i] . $self->{separator} . $lines[$i];
   }

  wantarray ? @lines : \@lines;
 }


sub  to_string ($;$)
 {
  my $self = shift;
  
  join( "\n", $self->make_labelled_lines( @_ ) ) . "\n";
 }



#--------------------------------------------
#  INTERNAL: Convert input parameters to a graph data object as needed.
sub _make_graph_data (@)
 {
  if('Text::Graph::DataSet' eq ref $_[0])
   {
    return shift;
   }
  else
   {
    return Text::Graph::DataSet->new( @_ );
   }
 }

#--------------------------------------------
#  INTERNAL: This routine pads the labels as needed.
sub _fmt_labels ($@)
 {
  my $right = shift;
  my $len   = 0;
  my @labels;

  foreach(@_)
   {
    $len = length if length > $len;
   }

  if($right)
   {
    @labels = map { (' ' x ($len-length)).$_ } @_;
   }
  else
   {
    my $pad = ' ' x $len;

    @labels = map { substr( ($_.$pad), 0, $len ) } @_;
   }

  @labels;
 }

#--------------------------------------------
#  INTERNAL: This is the workhorse routine that actually builds the
#  histogram bars.
sub  _histogram
 {
  my $dset  = shift;
  my $parms = { %{$_[0]}, labels => [$dset->get_labels] };
  my @values;

  $parms->{fill} ||= $parms->{marker};

  my @orig = $dset->get_values;
  if($parms->{log})
   {
    @values = map { log } @orig;

    $parms->{minval} = 1 if defined $parms->{minval} and !$parms->{minval};

    $parms->{minval} = log $parms->{minval} if $parms->{minval};
    $parms->{maxval} = log $parms->{maxval} if $parms->{maxval};
   }
  else
   {
    @values = @orig;
   }


  unless(defined($parms->{minval}) and defined($parms->{maxval}))
   {
    my ($min,$max) = _minmax( \@values );
    $parms->{minval} = $min unless defined $parms->{minval};
    $parms->{maxval} = $max unless defined $parms->{maxval};
   }

  $parms->{maxlen} = $parms->{maxval} - $parms->{minval} + 1
                                    unless defined $parms->{maxlen};
  my $scale = $parms->{maxlen}/($parms->{maxval} - $parms->{minval} + 1);

  @values = map { _makebar( ($_-$parms->{minval})*$scale, 
                            $parms->{marker}, 
                            $parms->{fill} )
                }
            map { _make_within( $_, $parms->{minval}, $parms->{maxval} ) } 
            @values;

  if($parms->{showval})
   {
    foreach(0..$#values)
     {
      $values[$_] .= (' ' x ($parms->{maxlen}-length $values[$_]))
	             .'  ('. $orig[$_] . ')';
     }
   }

  @values;
 }


#--------------------------------------------
#  INTERNAL: This routine finds both the minimum and maximum of
#  an array of values.
sub  _minmax
 {
  my $list = shift;
  my ($min, $max);

  $min = $max = $list->[0];

  foreach(@{$list})
   {
    if($_ > $max)    {$max = $_;}
    elsif($_ < $min) {$min = $_;}
   }

  ($min, $max);
 }



#--------------------------------------------
#  INTERNAL: This routine expects a number, a minimum, and a maximum.
#  It returns a number with the range.
sub _make_within
 {
  ($_[0]<$_[1]) ? $_[1] : ($_[0]>$_[2] ? $_[2] : $_[0]);
 }


#--------------------------------------------
#  INTERNAL: This routine builds the actual histogram bar.
sub  _makebar
 {
  my ($val, $m, $f, $s) = @_;

  $val = int($val + 0.5);

  $val>0 ? (($f x ($val-1)) . $m) : '';
 }

1;
__END__

=head1 NAME

Text::Graph - Perl extension for generating text-based graphs.

=head1 SYNOPSIS

  use Text::Graph;
  blah blah blah

=head1 DESCRIPTION

Some data is easier to analyze graphically than in its raw form. In many
cases, however, a full-blown multicolor graphic representation is overkill.
In these cases, a simple graph can provide an appropriate graphical
representation.

The Text::Graph module provides a simple text-based graph of a dataset.
Although this approach is B<not> appropriate for all data analysis, it can be
useful in some cases.

=head1 AUTHOR

G. Wade Johnson, wade@anomaly.org

=head1 Functions

=head2 new

The list below describes the parameters. 

=over 4

=item *

B<minval> - Minimum value cutoff. All values below I<minval> are considered
equal to I<minval>. The default value for I<minval> is 0. Setting the 
I<minval> to C<undef> causes C<TextHistogram::Bars> to use the minimum of
I<values> as I<minval>.

=item *

B<maxval> - Maximum value cutoff. All values above I<maxval> are considered
equal to I<maxval>. The default value for I<maxval> is C<undef> which causes
C<TextHistogram::Bars> to use the maximum of I<values> as I<maxval>.

=item *

B<maxlen> - Maximum length of a histogram bar. This parameter is used to scale
the histogram to a particular size. The default value for I<maxlen> is
(C<maxval - minval + 1>).

=item *

B<marker> - Character to be used for the highest point on each bar of the 
histogram. The default value for I<marker> is '*'.

=item *

B<fill> - Character to be used for drawing the bar of the histogram, 
except the highest point. The default value for I<fill> is  the value
of I<marker>.

=item *

B<log> - Flag determining if the graph is logarithmic or linear. The default
value for I<log> is 0 for a linear histogram.

=item *

B<showval> - Flag determining if the value of each bar is displayed to the
right of the bar. The default value for I<showval> is 0, which does not
display the value.

=item *

B<separator> - String which separates the labels from the histogram bars. The 
default value of I<separator> is ' :'.

=item *

B<right> - Flag which specifies the labels should be right-justified. By
default, this flag is 0, specifying that the labels are left justified.

=back

=head2 make_lines

The C<make_lines> method converts a dataset into a list of strings representing
the dataset. The C<make_lines> takes either a C<Text::Graph::DataSet> object
or the parameters needed to construct such an object. If used in array
context, it returns an array of bars. If used in scalar context, it returns
a reference to an array of bars.

=head2 make_labelled_lines

The C<make_lines> method converts a dataset into a list of strings representing
the dataset. The C<make_lines> takes either a C<Text::Graph::DataSet> object
or the parameters needed to construct such an object. Unlike C<make_lines>,
each line in this returned list is labelled as described in the
C<Text::Graph::DataSet> object. If used in array context, it returns an array of
bars. If used in scalar context, it returns a reference to an array of bars.

=head2 to_string

The C<to_string> method creates a displayable Graph for the supplied dataset.
The Graph is labelled as specified in the DataSet. The C<to_string> method
accepts all of the same parameters as C<make_lines>.

=head1 Examples

=head2 Bar Graph of an Array

  use Text::Graph;
  my $graph = Text::Graph->new( 'Bar' );
  print $graph->to_string( [1,2,4,5,10,3,5],
                           labels => [ qw/aaaa bb ccc dddddd ee f ghi/ ],
                         );

Generates the following output:

  aaaa   :
  bb     :*
  ccc    :***
  dddddd :****
  ee     :*********
  f      :**
  ghi    :****


=head2 Line Graph of an Array

  use Text::Graph;
  my $graph = Text::Graph->new( 'Line' );
  print $graph->to_string( [1,2,4,5,10,3,5],
                           labels => [ qw/aaaa bb ccc dddddd ee f ghi/ ],
                         );

Generates the following output:

  aaaa   :
  bb     :*
  ccc    :  *
  dddddd :   *
  ee     :        *
  f      : *
  ghi    :   *


=head2 Bar Graph of an Anonymous Hash

  use Text::Graph;
  my $graph = Text::Graph->new( 'Bar' );
  print $graph->to_string( { a=>1, b=>5, c=>20, d=>10, e=>17 } );

Generates the following output:

  a :
  b :****
  c :*******************
  d :*********
  e :****************

=head2 Bar Graph of an Anonymous Hash in Reverse Order

  use Text::Graph;
  use Text::Graph::DataSet;
  my $graph = Text::Graph->new( 'Bar' );
  my $dataset = Text::Graph::DataSet->new ({ a=>1, b=>5, c=>20, d=>10, e=>17 },
                                        sort => sub { sort { $b cmp $a } @_ });
  print $graph->to_string( $dataset );

Generates the following output:

  e :****************
  d :*********
  c :*******************
  b :****
  a :

=head2 Bar Graph of Part of an Anonymous Hash

  use Text::Graph;
  use Text::Graph::DataSet;
  my $graph = Text::Graph->new( 'Bar' );
  my $dataset = Text::Graph::DataSet->new ({ a=>1, b=>5, c=>20, d=>10, e=>17 },
                                        labels => [ qw(e b a d) ]);
  print $graph->to_string( $dataset );

Generates the following output:

  e :****************
  b :****
  a :
  d :*********

=head2 Filled Line Graph With Advanced Formatting

  use TextHistogram;
  TextHistogram::Print( [1,22,43,500,1000,300,50],
                          labels => [ qw/aaaa bb ccc dddddd ee f ghi/ ],
                          right  => 1,         # right-justify labels
                          fill => '.',         # change fill-marker
                          log => 1,            # logarithmic graph
                          showval => 1         # show actual values
                        );
  use Text::Graph;
  use Text::Graph::DataSet;
  my $dataset = Text::Graph::DataSet->new ([1,22,43,500,1000,300,50],
                                        [ qw/aaaa bb ccc dddddd ee f ghi/ ]);
  my $graph = Text::Graph->new( 'Line',
                                right  => 1,    # right-justify labels
                                fill => '.',    # change fill-marker
                                log => 1,       # logarithmic graph
                                showval => 1    # show actual values
                              );
  print $graph->to_string( $dataset );

Generates the following output:

    aaaa :        (1)
      bb :.*      (22)
     ccc :..*     (43)
  dddddd :....*   (500)
      ee :.....*  (1000)
       f :....*   (300)
     ghi :..*     (50)

=head1 SEE ALSO

perl(1).

=head1 COPYRIGHT

Copyright 2002-2004 G. Wade Johnson

This module is free software; you can distribute it and/or modify it under
the same terms as Perl itself.

perl(1).

=cut
