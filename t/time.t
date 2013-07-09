use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';
use Test::Deep;
use NG::Time;
my $t = new NG::Time;

isa_ok $t, 'NG::Time';

is $t->tostr("%Y", $t->now), $t->new->year;
