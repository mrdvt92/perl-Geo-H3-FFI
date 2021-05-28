use strict;
use warnings;
use Data::Dumper qw{Dumper};

use Test::More tests => 24;
require_ok 'Geo::H3::FFI';

my $index      = '622236750694711295';
my $gb         = Geo::H3::FFI::GeoBoundary->new({});
isa_ok($gb, 'Geo::H3::FFI::GeoBoundary');

my $void       = Geo::H3::FFI::h3ToGeoBoundary($index, $gb);
isa_ok($gb, 'Geo::H3::FFI::GeoBoundary');
#diag(Dumper({gb=>$gb}));

can_ok($gb, 'num_verts');
can_ok($gb, 'verts');
is($gb->num_verts, 6, '$gb->num_verts');

#diag(Dumper({verts=>$verts}));

foreach my $count (1 .. $gb->num_verts) {
  my $vert = $gb->verts->[$count - 1]; #$gb->verts sizeof 10
  #diag(Dumper({vert=>$vert}));
  isa_ok($vert, 'Geo::H3::FFI::GeoCoord');
  can_ok($vert, 'lat');
  can_ok($vert, 'lon');
  diag(sprintf("Count: %s, Lat: %s (%s), Lon: %s (%s)", $count, $vert->lat, Geo::H3::FFI::radsToDegs($vert->lat),
                                                                $vert->lon, Geo::H3::FFI::radsToDegs($vert->lon)));
}
