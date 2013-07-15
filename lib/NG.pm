package NG;

use NG::Class;

use base 'Exporter';
our @EXPORT = qw (
    def_class

    process_log
);

our $VERSION = '0.000_00';
sub def_class   { NG::Class::def( @_ ) }

sub process_log { NG::Log::process_log( @_ ) }
