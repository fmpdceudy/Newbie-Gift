use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'NG',
    VERSION_FROM       => 'lib/NG.pm',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
        'Test::Deep' => 0,
    },
    PREREQ_PM => {
        'Spreadsheet::ParseExcel'   => 0,
        'Spreadsheet::WriteExcel'   => 0,
        'Data::Dumper'              => 0,
        'Time::HiRes'               => 0,
        'POSIX'                     => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'NG-*' },
);
