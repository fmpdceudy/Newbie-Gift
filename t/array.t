use strict;
use warnings FATAL => 'all';
use base qw(Test::Class);
use Test::More;
use NG::Array;

my $ar;
my @check;

sub setup:Test(setup => 1) {
    $ar = NG::Array->new(10, 3, 9, 7);
    @check = ( 10, 3, 9, 7 );
    isa_ok $ar, 'NG::Array';
}

sub check {
    my( $name ) = @_;
    ok( $ar->size == scalar(@check ), $name."size" );
    for my $i (0 ... scalar(@check)-1){
        ok( $ar->get( $i ) eq $check[$i], $name."-".$i );
    }
}

sub get:Tests {
    check( "get" );
}

sub set:Tests {
    $ar->set(3, 11 );
    $check[3] = 11;
    check( "set" );
}

sub sort:Tests {
    $ar->sort(sub {
            my ($a, $b) = @_;
            return $a <=> $b;
        });

    @check = sort { $a <=> $b } @check;

    check( "sort new sub" );

    $ar->sort;
    @check = sort @check;

    check( "sort default" );
}

sub each:Tests {
    my $sum = 0;
    my $sumi = 0;

    $ar->each(sub {
            my ($item, $i) = @_;
            $sum += $item;
            $sumi += $i;
        });

    ok($sum == 29, "each");
    ok($sumi == 6, "each index");
}

sub push:Tests {
    $ar->push(5);
    push @check,5;
    check( "push" );
}

sub pop:Tests {
    my $v = $ar->pop;
    my $c = pop @check;
    ok($v == $c, "pop");
    check( "pop" );
}

sub unshift:Tests {
    $ar->unshift(27);
    unshift @check,27;
    check( "unshift" );

}

sub shift:Tests {
    my $v = $ar->shift;
    my $c = shift @check;
    ok($v == $c, "shift");
    check( "shift" );

}

sub size:Test {
    ok( $ar->size() == scalar( @check ), "size" );
}

sub newtest:Tests {
    $ar=NG::Array->new($ar)->get(0);
    check( "init with NG::Array" );
    $ar=NG::Array->new(3);
    @check=(3);
    check( "init with one value" );
    $ar=NG::Array->new(3,"dd");
    @check=(3,"dd");
    check( "init with multi value" );
}

sub arraychange:Tests {
    my @array = ( 3, 5, 7 );
    $ar = NG::Array->new( @array );
    @check = ( 3, 5, 7 );
    check( "init with ARRAY" );
    $array[2] = 5;
    check( "ARRAY change outside" );
}

sub read:Tests {
    $ar=$ar->read("./t/test");
    @check=(0,1,2,3,4,5,6);
    check("read by obj");
    $ar=NG::Array->read("./t/test");
    @check=(0,1,2,3,4,5,6);
    check("read by class");
    $ar=$ar->read("./t/fail");
    @check=();
    check("read fail");
}
Test::Class->runtests();
