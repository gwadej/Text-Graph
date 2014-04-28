use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Text::Graph',
    AUTHOR              => 'G. Wade Johnson <gwadej@cpan.org>',
    VERSION_FROM        => 'lib/Text/Graph.pm',
    ABSTRACT_FROM       => 'lib/Text/Graph.pm',
    LICENSE             => 'perl',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-Graph-*' },
    META_MERGE          => {
        'meta-spec' => { version => 2 },
        resources => {
            repository => {
                type => 'git',
                url  => 'https://github.com/gwadej/Text-Graph.git',
                web  => 'https://github.com/gwadej/Text-Graph',
            },
        },
    },
    test               => {
        TESTS => 't/*.t xt/*.t',
    },
);
