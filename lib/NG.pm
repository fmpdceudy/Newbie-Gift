package NG;

use NG::Class;

use base 'Exporter';
our @EXPORT = qw (
    def_class
);

our $VERSION = '0.000_00';
sub def_class   { NG::Class::def( @_ ) }

