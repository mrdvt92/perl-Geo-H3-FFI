use strict;
use warnings;
use Test::More tests => 27;
require_ok 'Geo::H3::FFI';

my $index  = '622236750694711295';
my $geo    = Geo::H3::FFI::h3ToGeoWrapper($index);
isa_ok($geo, 'Geo::H3::FFI::GeoCoord');
is($geo->lat, '0.710164381905454', '$geo->lat');
is($geo->lon, '-1.29231912069548', '$geo->lon');

my $string = Geo::H3::FFI::h3ToStringWrapper($index);
is($string, sprintf("%x", $index), 'h3ToStringWrapper');

my $gb      = Geo::H3::FFI::h3ToGeoBoundaryWrapper($index);
isa_ok($gb, 'Geo::H3::FFI::GeoBoundary');

can_ok($gb, 'num_verts');
can_ok($gb, 'verts');
is($gb->num_verts, 6, '$gb->num_verts');

foreach my $count (1 .. $gb->num_verts) {
  my $vert = $gb->verts->[$count - 1]; #$gb->verts sizeof 10
  isa_ok($vert, 'Geo::H3::FFI::GeoCoord');
  can_ok($vert, 'lat');
  can_ok($vert, 'lon');
  diag(sprintf("Count: %s, Lat: %s (%s), Lon: %s (%s)", $count, $vert->lat, Geo::H3::FFI::radsToDegs($vert->lat),
                                                                $vert->lon, Geo::H3::FFI::radsToDegs($vert->lon)));
}
