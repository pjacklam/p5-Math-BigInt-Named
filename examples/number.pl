#!/usr/bin/perl -w

# not ready yet

BEGIN { unshift @INC, '../lib'; }	# uncomment to use old, org version

$| = 1;

use Math::BigInt::Named;

my $x = Math::BigInt::Named->new( shift );

print $x->name(),"\n";

