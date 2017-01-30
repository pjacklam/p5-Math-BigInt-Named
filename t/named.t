#!/usr/bin/perl -w

use strict;
use Test;

BEGIN 
  {
  $| = 1;
  chdir 't' if -d 't';
  unshift @INC, '../lib'; # for running manually
  plan tests => 6;
  }

# testing of Math::BigInt::Named::German, primarily for the $x->name() and 
# $x->from_name() functionality, and not for the math functionality

use Math::BigInt::Named;
use Math::BigInt;

my $c = 'Math::BigInt::Named';

###############################################################################
# check delegating

my $x = $c->new(123);

ok ($x->name(), 'onehundredtwentythree');	# default en
ok ($x->name( language => 'german'),
		'einhundertunddreiundzwanzig');	# german
ok ($x->name( language => 'de'),
		'einhundertunddreiundzwanzig');	# german
ok ($x->name( language => 'en'),
		'onehundredtwentythree');	# en again

ok ($x,123);					# value shouldn't change

#$x = $c->new(1);
#ok ($x->name( language => 'ro'),
#		'unum');			# romana again
#ok ($x,1);					# value shouldn't change

ok ($c->new('foobar'),'NaN');

1;
