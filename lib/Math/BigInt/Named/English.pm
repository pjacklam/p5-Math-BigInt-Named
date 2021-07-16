#!perl

package Math::BigInt::Named::English;

use 5.006001;
use strict;
use warnings;

use Math::BigInt::Named;
our @ISA = qw< Math::BigInt::Named >;

our $VERSION = '0.05';

sub name {
    my $x = shift;
    $x = Math::BigInt -> new($x) unless ref($x);

    my $class = ref($x);

    return '' if $x -> is_nan();

    my $index = 0;

    my $ret = '';
    my $y = $x -> copy();
    my $rem;

    if ($y -> sign() eq '-') {
        $ret = 'minus ';
        $y -> babs();
    }

    if ($y < 1000) {
        return $ret . $class -> _triple($y, 1, 0);
    }

    while (!$y -> is_zero()) {
        ($y, $rem) = $y -> bdiv(1000);
        $ret = $class -> _triple($rem, 0, $index)
          . ' ' . $class -> _triple_name($index, $rem) . ' ' . $ret;
        $index++;
    }
    $ret =~ s/\s+$//;           # trailing spaces
    $ret;
}

my $SMALL = [ qw/
  zero
  one
  two
  three
  four
  five
  six
  seven
  eight
  nine
  ten
  eleven
  twelve
  thirteen
  fourteen
  fifteen
  sixteen
  seventeen
  eighteen
  nineteen
  / ];

my $ZEHN = [ qw /
  ten
  twenty
  thirty
  fourty
  fifty
  sixty
  seventy
  eighty
  ninety
  / ];

my $HUNDERT = [ qw /
  one
  two
  three
  four
  five
  six
  seven
  eight
  nine
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

sub _triple_name {
    my ($self, $index, $number) = @_;

    return '' if $index == 0 || $number -> is_zero();
    return 'thousand' if $index == 1;

    my $postfix = 'llion';
    my $plural = 's';
    if (($index & 1) == 1) {
        $postfix = 'lliard';
    }
    $postfix .= $plural unless $number -> is_one();
    $index -= 2;
    $TRIPLE -> [$index >> 1] . $postfix;
}

sub _triple {
    # return name of a triple (aka >= 0, and <= 1000)
    # input: number     >= 0, < 1000
    #        only       true if triple is the only triple ever ($nr < 1000)
    #       index       0 for last triple, 1 for thousand, 2 for million etc
    my ($self, $number, $only) = @_;

    return '' if $number -> is_zero() && !$only; # 0 => null, but only for one
    return $SMALL -> [$number] if $number < scalar @$SMALL; # known name

    my $hundert = $number / 100;
    my $rem = $number % 100;
    my $rc = '';
    $rc = $HUNDERT -> [$hundert-1] . "hundred" if !$hundert -> is_zero();

    my $concat = '';
    $concat = 'and' if $rc ne '';
    return $rc if $rem -> is_zero();
    return $rc . $concat . $SMALL -> [$rem] if $rem < scalar @$SMALL;

    my $zehn;
    ($zehn, $rem) = $rem -> bdiv(10);

    my $last = '';
    $last = $HUNDERT -> [$rem-1] if !$rem -> is_zero();    # 31, 32..
    $last = $ZEHN -> [$zehn-1] . $last if !$zehn -> is_zero(); # 1, 2, 3..

    $rc . $last;
}

1;

__END__

=pod

=head1 NAME

Math::BigInt::Named::English - Math::BigInts that know their name in English

=head1 SYNOPSIS

    use Math::BigInt::Named::English;

    $x = Math::BigInt::Named::English->new($str);

    print $x->name(),"\n";

    print Math::BigInt::Named::English->from_name('one hundredandfive),"\n";

=head1 DESCRIPTION

This is a subclass of Math::BigInt and adds support for named numbers
with their name in English to Math::BigInt::Named.

Usually you do not need to use this directly, but rather go via
L<Math::BigInt::Named>.

=head1 METHODS

=head2 name()

    print Math::BigInt::Name->name( 123 );

Convert a BigInt to a name.

=head2 from_name()

    my $bigint = Math::BigInt::Name->from_name('hundertzwanzig');

Create a Math::BigInt::Name from a name string. B<Not yet implemented!>

=head1 BUGS

For information about bugs and how to report them, see the BUGS section in the
documentation available with the perldoc command.

    perldoc Math::BigInt::Named

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::BigInt::Named::English

For more information, see the SUPPORT section in the documentation available
with the perldoc command.

    perldoc Math::BigInt::Named

=head1 LICENSE

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<Math::BigInt::Named>, L<Math::BigInt> and L<Math::BigFloat>.

=head1 AUTHORS

=over 4

=item *

(C) by Tels http://bloodgate.com in late 2001, early 2002, 2007.

=item *

Maintained by Peter John Acklam E<lt>pjacklam@gmail.comE<gt>, 2016-.

=back

=cut
