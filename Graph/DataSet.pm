package Text::Graph::DataSet;

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
  my $obj = {
              values => [],
	      labels => undef,
	      hash   => undef,
	      sort   => sub { sort @_ }
	    };

  if(@_)
   {
    if('ARRAY' eq ref $_[0])
     {
      $obj->{values} = shift;
     }
    elsif('HASH' eq ref $_[0])
     {
      $obj->{hash}   = shift;
     }
    $obj->{labels} = shift if 'ARRAY' eq ref $_[0];
   }

  if(@_ and 0 == (@_ % 2))
   {
    $obj = { %$obj, @_ };
   }

  $obj = bless $obj, $class;

  $obj->_initialize();

  $obj;
 }


sub get_values ($)
 {
  my $self = shift;

  wantarray ? @{$self->{values}} : $self->{values};
 }


sub get_labels ($)
 {
  my $self = shift;
  
  wantarray ? @{$self->{labels}} : $self->{labels};
 }


sub _initialize ($)
 {
  my $self = shift;

  if(defined $self->{hash})
   {
    unless(defined $self->{labels})
     {
      if(defined $self->{sort})
       {
        $self->{labels} = [ $self->{sort}->( keys %{$self->{hash}} ) ];
       }
     }
     
    $self->{values} = [ @{$self->{hash}}{@{$self->{labels}}} ];
   }
  elsif(defined $self->{values})
   {
    unless(defined $self->{labels})
     {
      $self->{labels} = [ ('') x scalar(@{$self->{values}}) ];
     }
   }

  $self->{labels} ||= [];

  if(scalar @{$self->{values}} > scalar @{$self->{labels}})
   {
    push @{$self->{labels}},
         ('') x (scalar @{$self->{values}} - scalar @{$self->{labels}});
   }
 }

1;
__END__

=head1 NAME

Text::Graph::Data - Encapsulate data for Text::Graph

=head1 SYNOPSIS

  use Text::Graph::Data;

  my $gdat = Text::Graph::Data->new( \@values, \@labels );

=head1 DESCRIPTION

Encapsulate the description of the data used by the C<Text::Graph> object.

The C<Text::Graph> object needs data values and labels for each data
value to generate appropriate graphs. The C<Text::Graph::Data> object allows
several methods of constructing this data and provides a simple interface
for retrieving it.

=head1 METHODS

=head2 new

The C<new> method creates a C<Text::Graph::Data> object. The C<new> method can
create this object from several different kinds of input.

If the first parameter is a single array reference, this becomes the values
for the C<Text::Graph::Data> object. If the first and second parameters are
array references, they become the values and labels for the
C<Text::Graph::Data> object, respectively.

If the first parameter is a hash reference, it is used to construct the value
and labels for the C<Text::Graph::Data> object. If there are no other
parameters, the keys of the hash will be sorted ASCIIbetically to generate the
labels, and the values will be the corresponding values from the hash. If the
second parameter is an array reference, it will be used as the labels for the
the C<Text::Graph::Data> object, and the values will be the corresponding
values from the hash.

After the above parameters are taken care of, or if they did not exist, any
remaining parameters are used to customize the data set. Those parameters are
taken as name/value pairs to set various options on the object. The defined
options are

=over 4

=item values

A reference to an array of values to use for this data set.

=item labels

A reference to an array of labels to use for this data set.

=item hash

A reference to a hash containing the values and labels for this data set.

=item sort

A reference to a subroutine that takes the list of labels and sorts them into
the appropriate order. The default value is an ASCIIbetical sort.

=back

=head2 get_values

In scalar context, C<get_values> returns a reference to the array containing
the values in this data set. In list context, it returns the values as a list.

=head2 get_labels

In scalar context, C<get_labels> returns a reference to the array containing
the labels in this data set. In list context, it returns the labels as a list.

=head1 AUTHOR

G. Wade Johnson, wade@anomaly.org

=head1 COPYRIGHT

Copyright 2004 G. Wade Johnson

This module is free software; you can distribute it and/or modify it under
the same terms as Perl itself.

perl(1).

=cut
