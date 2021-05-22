use strict;
use warnings;

use Test::More tests => 5;
require_ok 'Geo::H3::FFI';

my $string = "8a2a1072b59ffff\0";
my $index  = '622236750694711295';

my $h3     = Geo::H3::FFI::H3Index->new({index=>$index});
isa_ok($h3, 'Geo::H3::FFI::H3Index');
is($h3->index, $index);

my $size = length($string);
my $out = " " x $size;

my $void1  = Geo::H3::FFI::h3ToString($h3->index, $out, $size +1);

is($out, $string);
is($size, length($string));
