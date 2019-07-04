#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'YCSB' ) || print "Bail out!\n";
}

diag( "Testing YCSB $YCSB::VERSION, Perl $], $^X" );
