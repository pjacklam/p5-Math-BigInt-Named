#!/usr/bin/perl -w

use strict;
use Test;

BEGIN 
  {
  $| = 1;
  chdir 't' if -d 't';
  unshift @INC, '../lib'; # for running manually
  plan tests => 5;
  }

# testing of Math::BigInt::Named, primarily for the $x->name() and 
# $x->from_name() functionality, and not for the math functionality

use Math::BigInt::Named;

my $x = Math::BigInt::Named->new(1234);

ok ($x->name(),'one thousand two hundred thirty four');
$x++;
ok ($x->name(),'one thousand two hundred thirty five');

ok ($x->from_name(),'NaN');

# invalid integer, but valid number
$x = Math::BigInt::Named->new('zwei tausend drei hundert funfundachtzig');
ok ($x,'NaN');
# nothing valid at all
$x = Math::BigInt::Named->new('foo');
ok ($x,'NaN');

# done

1;

