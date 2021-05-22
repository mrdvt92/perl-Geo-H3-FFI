use strict;
use warnings;

use Test::More tests => 4;
require_ok 'Geo::H3::FFI';

my $string = '8a2a1072b59ffff';
my $index  = '622236750694711295';

my $h3 = Geo::H3::FFI::H3Index->new({ index => Geo::H3::FFI::stringToH3($string, length($string)) });
isa_ok($h3, 'Geo::H3::FFI::H3Index');
is($h3->index, $index);
is(sprintf("%x", $h3->index), $string );
