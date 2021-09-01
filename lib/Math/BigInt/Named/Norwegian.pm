#!perl

package Math::BigInt::Named::Norwegian;

use strict;
use warnings;

use Math::BigInt::Named;
our @ISA = qw< Math::BigInt::Named >;

our $VERSION = '0.08';

my $SMALL = [ qw/
  null
  en
  to
  tre
  fire
  fem
  seks
  syv
  åtte
  ni
  ti
  elleve
  tolv
  tretten
  fjorten
  femten
  seksten
  sytten
  atten
  nitten
  / ];

my $TENS = [ qw /
  ti
  tjue
  tretti
  førti
  femti
  seksti
  sytti
  åtti
  nitti
  / ];

my $HUNDREDS = [ qw /
  en
  to
  tre
  fire
  fem
  seks
  sju
  åtte
  ni
  / ];

my $TRIPLE = [ qw /
  mi
  bi
  tri
  kvadri
  kvinti
  seksti
  septi
  okti
  noni
  desi
  undesi
  duodesi
  tredesi
  kvattordesi
  kvindesi
  seksdesi
  septendesi
  oktodesi
  novemdesi
  viginti
  / ];

sub name {
    my $x = shift;
    $x = Math::BigInt -> new($x) unless ref($x);

    my $class = ref($x);

    return '' if $x -> is_nan();

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

    # Split the number into numerical triplets.

    my @num = ();
    while (!$y -> is_zero()) {
        ($y, $rem) = $y -> bdiv(1000);
        unshift @num, $rem;
    }

    # Convert each numerical triplet into a string.

    my @str = ();
    for my $i (0 .. $#num) {
        my $num = $num[$i];
        my $str;
        my $index = $#num - $i;

        my $count;
        if ($num == 1 && $index == 1) {
            $count = "ett";     # "ett tusen", not "en tusen"
        } else {
            $count = $class -> _triple($num, 0, $i);
        }
        $str .= $count;

        # "tusen", "million"/"millioner", "milliard/milliarder", ...

        if ($index > 0) {
            my $triple_name = $class -> _triple_name($#num - $i, $num);
            $str .= ' ' . $triple_name;
        }

        $str[$i] = $str;
    }

    # 1100 -> "ett tusen ett hundre"    (not "ett tusen og ett hundre")
    # 1099 -> "ett tusen og nittini"    (not "ett tusen nittini")
    # 1098 -> "ett tusen og nittiåtte"  (not "ett tusen nittiåtte")
    # ...
    # 1001 -> "ett tusen og en"         (not "ett tusen en")
    # 1000 -> "ett tusen"               (not "ett tusen og null"

    if (@num > 1 && 0 < $num[-1] && $num[-1] < 100) {
        splice @str, -1, 0, "og";
    }

    $ret . join(" ", grep /\S/, @str);
}

sub _triple_name {
    my ($self, $index, $number) = @_;
    # index => 0 hundreds, tens and ones
    # index => 1 thousands
    # index => 2 millions

    return '' if $index == 0 || $number -> is_zero();
    return 'tusen' if $index == 1;

    my $postfix = 'llion';
    my $plural = 'er';
    if (($index & 1) == 1) {
        $postfix = 'lliard';
    }
    $postfix .= $plural unless $number -> is_one();
    $index -= 2;
    $TRIPLE -> [$index >> 1] . $postfix;
}

sub _triple {
    # return name of a triple
    # input: number     >= 0, < 1000
    #        only       true if triple is the only triple
    my ($self, $number, $only) = @_;

    # 0 => null, but only if there is just one triple
    return '' if $number -> is_zero() && !$only;

    # we have the full name for these
    return $SMALL -> [$number] if $number <= $#$SMALL;

    # New code:

    my @num = ();
    $num[1] = $number % 100;                # tens and ones
    $num[0] = ($number - $num[1]) / 100;    # hundreds

    my @str = ();

    # Do the hundreds, if any.

    if ($num[0]) {
        my $str;
        $str = $num[0] == 1 ? "ett"     # "ett hundre", not "en hundre"
                            : $HUNDREDS -> [$num[0] - 1];
        $str .= " hundre";
        push @str, $str;
    }

    # Do the tens and ones, if any.

    if ($num[1]) {
        my $str;
        my $ones = $num[1] % 10;
        my $tens = ($num[1] - $ones) / 10;
        if ($num[1] <= $#$SMALL) {
            $str = $SMALL -> [ $num[1] ];
        } else {
            $str = $TENS -> [ $tens - 1];
            if ($ones > 0) {
                $str .= "";
                $str .= $SMALL -> [ $ones ];
            }
        }
        push @str, $str;
    }

    return join " og ", @str;
}

1;

__END__

=pod

=head1 NAME

Math::BigInt::Named::Norwegian - Math::BigInts that know their name in Norwegian

=head1 SYNOPSIS

    use Math::BigInt::Named::Norwegian;

    $x = Math::BigInt::Named::Norwegian -> new("123");
    $str = $x -> name();

    $str = "ett hundre og to";
    $x = Math::BigInt::Named::Norwegian -> from_name($str);

=head1 DESCRIPTION

This is a subclass of Math::BigInt and adds support for named numbers
with their name in Norwegian to Math::BigInt::Named.

Usually you do not need to use this directly, but rather go via
L<Math::BigInt::Named>.

=head1 METHODS

=head2 name()

    print Math::BigInt::Name -> name( 123 );

Convert a BigInt to a name.

=head2 from_name()

    my $bigint = Math::BigInt::Name -> from_name('ett hundre og to');

Create a Math::BigInt::Name from a name string. B<Not yet implemented!>

=head1 BUGS

For information about bugs and how to report them, see the BUGS section in the
documentation available with the perldoc command.

    perldoc Math::BigInt::Named

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::BigInt::Named::Norwegian

For more information, see the SUPPORT section in the documentation available
with the perldoc command.

    perldoc Math::BigInt::Named

=head1 LICENSE

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<Math::BigInt::Named> and L<Math::BigInt>.

=head1 AUTHORS

=over 4

=item *

Peter John Acklam E<lt>pjacklam@gmail.comE<gt>, 2021.

=back

=cut
