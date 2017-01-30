#!/usr/bin/perl -w

package Math::BigInt::Named;

require 5.005_02;
use strict;

use Exporter;
use Math::BigInt::Named;
use vars qw($VERSION @ISA $PACKAGE @EXPORT_OK
            $accuracy $precision $round_mode $div_scale);

@ISA = qw(Exporter Math::BigInt);

$VERSION = 0.02;

# Globals
$accuracy = $precision = undef;
$round_mode = 'even';
$div_scale = 40;

use Math::BigInt::Named::English;		# default

# Not all of them exist yet
my $LANGUAGE = {
  en => 'english',
  de => 'german',
  sp => 'spanish',
  fr => 'french',
  ro => 'Romana',
  };

my $LOADED = { };

sub name
  {
  # output the name of the number
  my ($x) = shift;

  return 'NaN' if $x->is_nan();

  my $opt;
  if (ref($_[0]) eq 'HASH')
    {
    $opt = shift;
    }
  else
    {
    $opt = { @_ };
    }
  my $lang = $opt->{language} || 'english';
  $lang = $LANGUAGE->{$lang} if exists $LANGUAGE->{$lang};	# en => english

  $lang = 'Math::BigInt::Named::' . ucfirst($lang);

  if (!defined $LOADED->{$lang})
    {
    eval "use $lang;"; $LOADED->{$lang} = 1;
    }
  my $y = $lang->new($x);
  return $y->name();
  }

sub from_name
  {
  # create a Math::BigInt::Name from a name string
  my $name = shift;

  my $x = Math::BigInt->bnan();
  }

#sub import
#  {
#  my $self = shift;
#  Math::BigInt->import(@_);
#  $self->SUPER::import(@_);                     # need it for subclasses
#  #$self->export_to_level(1,$self,@_);           # need this ?
#  }

1;

__END__

=head1 NAME

Math::BigInt::Named - Math::BigInts that know their name in some languages

=head1 SYNOPSIS

  use Math::BigInt::Named;

  $x = Math::BigInt::Named->new($str);

  print $x->name(),"\n";			# default is english
  print $x->name( language => 'de' ),"\n";	# but German is possible
  print $x->name( language => 'German' ),"\n";	# like this
  print $x->name( { language => 'en' } ),"\n";	# this works, too

  print Math::BigInt::Named->from_name('einhundert dreiundzwanzig),"\n";

=head1 DESCRIPTION

This is a subclass of Math::BigInt and adds support for named numbers. 

=head2 MATH LIBRARY

Math with the numbers is done (by default) by a module called
Math::BigInt::Calc. This is equivalent to saying:

	use Math::BigInt::Named lib => 'Calc';

You can change this by using:

	use Math::BigInt::Named lib => 'BitVect';

The following would first try to find Math::BigInt::Foo, then
Math::BigInt::Bar, and when this also fails, revert to Math::BigInt::Calc:

	use Math::BigInt::Named lib => 'Foo,Math::BigInt::Bar';

=head1 BUGS

None know yet. Please see also L<Math::BigInt>.

=head1 LICENSE

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<Math::BigFloat> and L<Math::Big> as well as L<Math::BigInt::BitVect>,
L<Math::BigInt::Pari> and  L<Math::BigInt::GMP>.

The package at
L<http://search.cpan.org/search?dist=Math-BigInt-Named> may
contain more documentation and examples as well as testcases.

=head1 AUTHORS

(C) by Tels in late 2001, early 2002. Based on work by Chris London Noll.

=cut
