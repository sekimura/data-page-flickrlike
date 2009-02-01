use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Data::Page::FlickrLike',
    AUTHOR              => 'Masayoshi Sekimura <sekimura@gmail.com>',
    VERSION_FROM        => 'lib/Data/Page/FlickrLike.pm',
    ABSTRACT_FROM       => 'lib/Data/Page/FlickrLike.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Data-Page-FlickrLike-*' },
);
