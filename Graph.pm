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
$VERSION = '0.1';


sub new
 {
  my $self = shift;
  my $class = ref $self || $self;
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
  my $style = lc shift;
  if('bar' eq $style)
   {
    ( style => 'Bar', marker => '*', line => ' ' );
   }
  elsif('line' eq $style)
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



sub _make_graph_data (@)
 {
  if('Text::Graph::Data' eq ref $_[0])
   {
    return shift;
   }
  else
   {
    return Text::Graph::Data->new( @_ );
   }
 }

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
  my $gdata = shift;
  my $parms = { %{$_[0]}, labels => [$gdata->get_labels] };
  my @values;

  $parms->{fill} ||= $parms->{marker};

  die "Data set must be a Text::Graph::Data object.\n"
      unless 'Text::Graph::Data' eq ref $gdata;

  my @orig = $gdata->get_values;
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

=head2 Bars

The C<TextHistogram::Bars> function converts a dataset into a list of 
strings representing the bars of a histogram. The C<TextHistogram::Bars> 
takes a reference to an array of data to be histogrammed and an optional
list of named parameters which modifies its function. If used in array
context, it returns an array of bars. If used in scalar context, it returns
a reference to an array of bars.

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

=back

=head2 String

The C<TextHistogram::String> function converts a set of values into a
histogram and returns that histogram as a string. The histogram is labelled
as specified in the parameters. The C<TextHistogram::String> function
accepts all of the same parameters as C<TextHistogram::Bars>, with a few 
extras, described below.

In addition, the first parameter to the function may be either an array
reference or a hash reference. If it is an array reference, it works the
same as described for C<TextHistogram::Bars>.

However, if the first parameter is a reference to a hash, the values are
taken from the hash. If I<labels> is supplied, only the values specified 
by the I<labels> are used from the hash. If I<labels> is not supplied,
the I<labels> are taken from the C<keys> of the hash reference.

=over 4

=item *

B<labels> - Reference to an array of labels for the bars of the histogram.
Must be the same length as the I<values> array. (Required, unless the
the first parameter is a hash reference.)

=item *

B<separator> - String which separates the labels from the histogram bars. The 
default value of I<separator> is ' :'.

=item *

B<right> - Flag which specifies the labels should be right-justified. By
default, this flag is 0, specifying that the labels are left justified.

=item *

B<sort> - Subroutine reference used to determine the order of the labels when
the input is a hash reference. If no I<sort> is specified, the labels are
sorted ASCIIbetically. The value of the I<sort> parameter is a subroutine
reference which sorts its argument array into the appropriate order.

=back

=head2 Print

The C<TextHistogram::Print> function prints a set of values as a histogram.
The histogram is labelled as specified in the parameters. The
C<TextHistogram::Print> function accepts all of the same parameters as 
C<TextHistogram::String>.

=head1 Examples

=head2 Histogram an Array

  use TextHistogram;
  TextHistogram::Print( [1,2,4,5,10,3,5],
                         labels => [ qw/aaaa bb ccc dddddd ee f ghi/ ],
                       );

Generates the following output:

  aaaa   :*
  bb     :**
  ccc    :****
  dddddd :*****
  ee     :**********
  f      :***
  ghi    :*****


=head2 Histogram an Anonymous Hash

  use TextHistogram;
  TextHistogram::Print( { a=>1, b=>5, c=>20, d=>10, e=>17 } );

Generates the following output:

  a :*
  b :*****
  c :********************
  d :**********
  e :*****************

=head2 Histogram an Anonymous Hash in Reverse Order

  use TextHistogram;
  TextHistogram::Print( { a=>1, b=>5, c=>20, d=>10, e=>17 },
                         sort => sub { sort { $b cmp $a } @_ }
                       );

Generates the following output:

  e :*****************
  d :**********
  c :********************
  b :*****
  a :*

=head2 Histogram Part of an Anonymous Hash

  use TextHistogram;
  TextHistogram::Print( { a=>1, b=>5, c=>20, d=>10, e=>17 },
                         labels => [ qw(e b a d) ]
                       );

Generates the following output:

  e :*****************
  b :*****
  a :*
  d :**********

=head2 Histogram With Advanced Formatting

  use TextHistogram;
  TextHistogram::Print( [1,22,43,500,1000,300,50],
                          labels => [ qw/aaaa bb ccc dddddd ee f ghi/ ],
                          right  => 1,         # right-justify labels
                          fill => '.',         # change fill-marker
                          log => 1,            # logarithmic graph
                          showval => 1         # show actual values
                        );

Generates the following output:

    aaaa :         (1)
      bb :..*      (22)
     ccc :...*     (43)
  dddddd :.....*   (500)
      ee :......*  (1000)
       f :.....*   (300)
     ghi :...*     (50)

=head1 SEE ALSO

perl(1).

=head1 COPYRIGHT

Copyright 2002-2004 G. Wade Johnson

This module is free software; you can distribute it and/or modify it under
the same terms as Perl itself.

perl(1).

=cut
