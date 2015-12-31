use strict;
use warnings FATAL => 'all';
use base qw(Test::Class);
use Test::More;
use NG::Hashtable;
use NG::Time;

my $hash;
my %check;

sub setup:Test(setup => no_plan ) {
    $hash = new NG::Hashtable();
    %check = ();
    isa_ok $hash, 'NG::Hashtable';
}

sub check {
    my ( $name ) = @_;

    my @temp = sort keys %check;

    ok( scalar( @temp ) == $hash->keys->size, $name."-size" );
    if( scalar( @temp ) == 0 ) {
        ok( $hash->values->size == 0, $name."-size-0");
        return;
    }

    for my $i (0 ... scalar(@temp)-1){
        ok( $hash->keys->get($i) eq $temp[$i], $name."-keys-".$i );
    }

    @temp = sort values %check;
    for my $i (0 ... scalar(@temp)-1){
        ok( $hash->values->get($i) eq $temp[$i], $name."-values-".$i );
    }

    for my $key ( keys %check ){
        ok( $check{$key} eq $hash->get( $key ), $name.$key );
    }
}

sub manyinone:Tests {
    check( "beforeput" );
    $hash->put( 'key1', 1 );
    $hash->put( 'key2', 2 );
    $hash->put( 'key3', 3 );
    $check{key1} = 1;
    $check{key2} = 2;
    $check{key3} = 3;
    check( "put" );
    delete $check{key2};
    $hash->remove( "key2" );
    check( "remove" );
    $hash->each( sub {
            my( $key, $value ) = @_;
            ok( $value eq $check{$key}, "each" );
        } );
}

sub newtest:Tests {
    $hash = new NG::Hashtable( { 'key2', 3, 'key3', 4 } );
    %check=('key2', 3, 'key3', 4 );
    check( "init with hash" );
    $hash = new NG::Hashtable( new NG::Array( 'key2', 3, 'key3', 4 ) );
    check( "init with Array" );
    $hash = new NG::Hashtable( $hash );
    check( "init with Hashtable" );
    $hash = new NG::Hashtable( new NG::Time );
    %check = ();
    check( "init with other class" );
}
Test::Class->runtests();
