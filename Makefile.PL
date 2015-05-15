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
    CONFIGURE_REQUIRES  => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'       => 0,
    },
    PREREQ_PM => {
        'version'          => 0,
        'Moo'              => 0,
        'namespace::clean' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Text-Graph-*' },
    MIN_PERL_VERSION   => 5.006,
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
