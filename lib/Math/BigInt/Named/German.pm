#!/usr/bin/perl -w

package Math::BigInt::Named::German;

require 5.005_02;
use strict;

use Exporter;
use Math::BigInt;
use vars qw($VERSION @ISA $PACKAGE @EXPORT_OK
            $accuracy $precision $round_mode $div_scale);

@ISA = qw(Exporter Math::BigInt);

$VERSION = 0.01;

# Globals
$accuracy = $precision = undef;
$round_mode = 'even';
$div_scale = 40;

sub name
  {
  # output the name of the number
  my ($x) = shift;
  $x = Math::BigInt->new($x) unless ref($x);
 
  my $self = ref($x);

  return '' if $x->is_nan();

  my $index = 0;

  my $ret = '';
  my $y = $x->copy(); my $rem;
  if ($y->sign() eq '-')
    {
    $ret = 'minus ';
    $y->babs();
    }
  if ($y < 1000) 
    {
    return $ret . $self->_triple($y,1,0);
    }
  my $triple;
  while (!$y->is_zero())
    {
    ($y,$rem) = $y->bdiv(1000);
    $ret = $self->_triple($rem,0,$index)
          .' ' . $self->_triple_name($index,$rem) . ' ' . $ret;
    $index++;
    }
  $ret =~ s/\s+$//;	# trailing spaces
  return $ret;
  }

sub from_name
  {
  # create a Math::BigInt::Name from a name string
  my $name = shift;

  my $x = Math::BigInt->bnan();
  }

my $SMALL = [ qw/ 
  null
  eins
  zwei
  drei
  vier
  fuenf
  sechs
  sieben
  acht
  neun
  zehn
  oelf
  zwoelf
  dreizehn
  vierzehn 
  fuenfzehn
  sechzehn
  siebzehn
  achtzehn
  neunzehn
  / ];

my $ZEHN = [ qw /
  zehn
  zwanzig
  dreissig
  vierzig
  fuenfzig
  sechzig
  siebzig
  achtzig
  neunzig
  / ];  

my $HUNDERT = [ qw /
  ein
  zwei
  drei
  vier
  fuenf
  sechs
  sieben
  acht
  neun
  / ];  

my $TRIPLE = [ qw /
  mi
  bi
  tri
  quadri
  penti
  hexi
  septi
  octi
  / ];

sub _triple_name
  {
  my ($self,$index,$number) = @_;
  
  return '' if $index == 0 || $number->is_zero();
  return 'tausend' if $index == 1;
 
  my $postfix = 'llion'; my $plural = 'en';
  if ($index & 1 == 1)
    {
    $postfix = 'lliarde'; $plural = 'n';
    }
  $postfix .= $plural unless $number->is_one();
  $index -= 2;
  return $TRIPLE->[$index >> 1] . $postfix;
  }

sub _triple
  {
  # return name of a triple (aka >= 0, and <= 1000)
  # input: number 	>= 0, < 1000)
  #        only    	true if triple is the only triple ever ($nr < 1000)
  #	   index	0 for last triple, 1 for tausend, 2 for million etc
  my ($self,$number,$only,$index) = @_;

  # eins, ein hundert, ein tausend, eine million
  # zwei, zwei hundert, zwei tausend, zwei million

  my $eins = 'ein';
  $eins = 'eins' if $index == 0;
  $eins = 'eine' if $index > 2;

  return '' if $number->is_zero() && !$only;	# 0 => null, but only for one
  return $eins if $number->is_one();
  return $SMALL->[$number] if $number < scalar @$SMALL;	# known name

  my $hundert = $number / 100;
  my $rem = $number % 100;
  my $rc = '';
  $rc = "$HUNDERT->[$hundert-1]hundert" if !$hundert->is_zero();

  my $concat = ''; $concat = 'und' if $rc ne ''; 
  return $rc if $rem->is_zero();
  return $rc . $concat . $SMALL->[$rem] if $rem < scalar @$SMALL;
  
  my $zehn; ($zehn,$rem) = $rem->bdiv(10);
 
  $rc .= $concat . $HUNDERT->[$rem-1] if !$rem->is_zero(); # 31, 32..
  $concat = ''; $concat = 'und' if $rc ne ''; 
  $rc .= $concat . $ZEHN->[$zehn-1] if !$zehn->is_zero();  # 1,2,3..
  
  $rc;
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

Math::BigInt::Named::German - Math::BigInts that know their name in German

=head1 SYNOPSIS

  use Math::BigInt::Named::German;

  $x = Math::BigInt::Named::German->new($str);

  print $x->name(),"\n";

  print Math::BigInt::Named::German->from_name('einhundert dreiundzwanzig),"\n";

=head1 DESCRIPTION

This is a subclass of Math::BigInt and adds support for named numbers
with their name in German to Math::BigInt::Named.

Usually you do not need to use this directly, but rather go via
L<Math::BigInt::Named>.

=head1 BUGS

None know yet. Please see also L<Math::BigInt::Named>.

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

(C) by Tels in late 2001, early 2002.

=cut
