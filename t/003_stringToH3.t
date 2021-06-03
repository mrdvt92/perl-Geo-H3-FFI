use strict;
use warnings;

use Test::More tests => 6;
require_ok 'Geo::H3::FFI';

my $obj = Geo::H3::FFI->new;
isa_ok($obj, 'Geo::H3::FFI');

my $string = '8a2a1072b59ffff';
my $index  = '622236750694711295';
{
  my $out    = $obj->stringToH3($string, length($string));
  is($out, $index, 'stringToH3');
  is(sprintf("%x", $out), $string, 'stringToH3');
}
{
  my $out    = $obj->stringToH3Wrapper($string);
  is($out, $index, 'stringToH3Wrapper');
  is(sprintf("%x", $out), $string, 'stringToH3Wrapper');
}
