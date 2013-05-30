use Test::More;
use lib '../lib';
use Array;

my $ar = Array->new(10, 3, 9, 7);


ok($ar->get(0) == 10, "get");

$ar->sort(sub {
        my ($a, $b) = @_;
        return $a <=> $b;
    });

ok($ar->get(0) == 3, "sort");

my $sum = 0;
my $sumi = 0;

$ar->each(sub {
              my ($item, $i) = @_;
              $sum += $item;
              $sumi += $i;
          });

ok($sum == 29, "each");
ok($sumi == 6, "each index");

$ar->push(5);

ok($ar->get(4) == 5, "push");

$ar->unshift(27);

ok($ar->get(0) == 27, "unshift");

my $v = $ar->pop();

ok($v == 5, "pop 1");
ok($ar->get(4) == 10, "pop 2");

ok($ar->size() == 5, "size");

$v = $ar->shift();
ok($v == 27, "shift 1");
ok($ar->get(0) == 3, "shift 2");

$ar=Array->new($ar);
ok($ar->get(0)->get(0) == 3, "init with Array");
$ar=Array->new(3);
ok($ar->get(0) == 3,"int with one value");

done_testing;
