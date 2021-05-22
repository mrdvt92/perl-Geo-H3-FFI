use strict;
use warnings;

use Test::More tests => 10;
BEGIN { use_ok('Geo::H3::FFI') };

my $lat        = 40.689167;
my $lon        = -74.044444;
my $lat_rad    = Geo::H3::FFI::degsToRads($lat);
my $lon_rad    = Geo::H3::FFI::degsToRads($lon);

is($lat, Geo::H3::FFI::radsToDegs($lat_rad), 'lat round trip');
is($lon, Geo::H3::FFI::radsToDegs($lon_rad), 'lon round trip');

my $geo        = Geo::H3::FFI::GeoCoord->new({lat => $lat_rad, lon => $lon_rad});
isa_ok($geo, 'Geo::H3::FFI::GeoCoord');
can_ok($geo, 'lat');
can_ok($geo, 'lon');
is($geo->lat, $lat_rad, 'lat');
is($geo->lon, $lon_rad, 'lon');

my $resolution = 10;
my $index      = Geo::H3::FFI::geoToH3($geo, $resolution);

#$ geoToH3 --lat 40.689167 --lon -74.044444 --resolution 10
#8a2a1072b59ffff
my $h3String   = '8a2a1072b59ffff';
is($index, '622236750694711295', 'geoToH3');
is(sprintf("%x", $index), $h3String);
