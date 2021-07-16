#!perl

use strict;
use warnings;

use Test::More;

plan tests => 83;

# testing of Math::BigInt::Named::English, primarily for the $x->name() and
# $x->from_name() functionality, and not for the math functionality

use Math::BigInt::Named::English;
use Math::BigInt;

my $c = 'Math::BigInt::Named::English';

###############################################################################
# triple names
my $x = Math::BigInt -> bzero();
my $y = Math::BigInt -> new(2);

is($c -> _triple_name(0, $x), '');              # null
is($c -> _triple_name(2, $x), '');              # null millionen
$x++;
is($c -> _triple_name(1, $x), 'thousand');
my $i = 2;
for (qw/ m b tr quadr pent hex sept oct / ) {
    is($c -> _triple_name($i,   $x), $_ . 'i' . 'llion');
    is($c -> _triple_name($i+1, $x), $_ . 'i' . 'lliard');
    is($c -> _triple_name($i,   $y), $_ . 'i' . 'llions');
    is($c -> _triple_name($i+1, $y), $_ . 'i' . 'lliards');
    $i += 2;
}

###############################################################################
# assorted names

while (<DATA>) {
    chomp;
    next if !/\S/;              # empty lines
    next if /^#/;               # comments
    my @args = split /:/;

    my $got      = $c -> new($args[0]) -> name();
    my $expected = $args[1];
    my $test     = $args[0] . " -> " . $args[1];
    is($got, $expected, $test);
    # is($c -> from_name($args[1]), $args[0]);
}


###############################################################################

# nothing valid at all
$x = $c -> new('foo');
is($x, 'NaN', "foo -> NaN");

# done

1;

__END__
0:zero
1:one
-1:minus one
2:two
3:three
4:four
5:five
6:six
7:seven
8:eight
9:nine
10:ten
11:eleven
12:twelve
13:thirteen
14:fourteen
15:fifteen
16:sixteen
17:seventeen
18:eighteen
19:nineteen
20:twenty
21:twentyone
22:twentytwo
33:thirtythree
44:fourtyfour
55:fiftyfive
66:sixtysix
77:seventyseven
88:eightyeight
99:ninetynine
100:onehundred
200:twohundred
300:threehundred
400:fourhundred
500:fivehundred
600:sixhundred
700:sevenhundred
800:eighthundred
900:ninehundred
1000:one thousand
101:onehundredandone
202:twohundredandtwo
1001:one thousand one
1002:one thousand two
1102:one thousand onehundredandtwo
1122:one thousand onehundredtwentytwo
