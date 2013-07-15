use strict;
use warnings FATAL => 'all';
use Test::More;
use NG;
use NG::Log;

my $log = new NG::Log;
isa_ok $log, 'NG::Log';

process_log( 't/log.txt', sub {
        my ( $fields ) = @_;
        isa_ok $fields, 'NG::Array';
        ok $fields->get( 1 );
    });
done_testing;
