use strict;
use warnings FATAL => 'all';
use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';

use NG::Hashtable;
my $hash = new NG::Hashtable;

isa_ok $hash, 'NG::Hashtable';

$hash->put( 'key1', 1 );
$hash->put( 'key2', 2 );
$hash->put( 'key3', 3 );

is $hash->get('key1'), 1;

cmp_deeply $hash->keys,   NG::Array->new( 'key1', 'key2', 'key3' );
cmp_deeply $hash->values, NG::Array->new( 1,      2,      3 );

$hash->remove('key1');

cmp_deeply $hash->keys,   NG::Array->new( 'key2', 'key3' );
cmp_deeply $hash->values, NG::Array->new( 2,      3 );

$hash->each(
    sub {
        my ( $key, $val ) = @_;
        $hash->put( $key, $val + 1 );
    }
);

cmp_deeply $hash->values, NG::Array->new( 3, 4 );

my $inithash = new NG::Hashtable( $hash );
cmp_deeply $inithash->values, NG::Array->new( 3, 4 );

$inithash = new NG::Hashtable( { 'key2', 3, 'key3', 4 } );
cmp_deeply $inithash->values, NG::Array->new( 3, 4 );

$inithash = new NG::Hashtable( new NG::Array( 'key2', 3, 'key3', 4 ) );
cmp_deeply $inithash->values, NG::Array->new( 3, 4 );
