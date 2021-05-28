use strict;
use warnings;
use Test::Number::Delta;
use Test::More tests => 17;
require_ok 'Geo::H3::FFI';

#$ geoToH3 --lat 40.689167 --lon -74.044444 --resolution 10
#8a2a1072b59ffff

my $index      = 622236750694711295;   #8a2a1072b59ffff
my $resolution = 10;
is(sprintf("%x", $index ), '8a2a1072b59ffff', 'index' );

#$ffi->attach(hexAreaKm2 => ['int'] => 'double');
my $hexAreaKm2 = Geo::H3::FFI::hexAreaKm2($resolution);
is($hexAreaKm2, 0.0150475, 'hexAreaKm2');

#$ffi->attach(hexAreaM2 => ['int'] => 'double');
my $hexAreaM2 = Geo::H3::FFI::hexAreaM2($resolution);
is($hexAreaM2, 15047.5, 'hexAreaM2');

#$ffi->attach(cellAreaM2 => ['uint64_t'] => 'double');
my $cellAreaM2 = Geo::H3::FFI::cellAreaM2($index);
is($cellAreaM2, 15111.0082455306, 'cellAreaM2'); #how to verify

#$ffi->attach(cellAreaRads2 => ['uint64_t'] => 'double');
my $cellAreaRads2 = Geo::H3::FFI::cellAreaRads2($index);
is($cellAreaRads2, 3.72286470372421e-10, 'cellAreaRads2');

#$ffi->attach(edgeLengthKm=> ['int'] => 'double');
my $edgeLengthKm = Geo::H3::FFI::edgeLengthKm($resolution);
is($edgeLengthKm, 0.065907807, 'edgeLengthKm');

#$ffi->attach(edgeLengthM=> ['int'] => 'double');
my $edgeLengthM = Geo::H3::FFI::edgeLengthM($resolution);
delta_within($edgeLengthM, 65.907807, 1e-6, 'edgeLengthM');

{
local $TODO = 'exactEdgeLengthXXX not working as expected...';

#$ffi->attach(exactEdgeLengthKm=> ['uint64_t'] => 'double');
my $exactEdgeLengthKm = Geo::H3::FFI::exactEdgeLengthKm($index);
is($exactEdgeLengthKm, 0.065907807, 'exactEdgeLengthKm');

#$ffi->attach(exactEdgeLengthM => ['uint64_t'] => 'double');
my $exactEdgeLengthM = Geo::H3::FFI::exactEdgeLengthM($index);
is($exactEdgeLengthM, 65.907807, 'exactEdgeLengthM');

#$ffi->attach(exactEdgeLengthRads => ['uint64_t'] => 'double');
my $exactEdgeLengthRads = Geo::H3::FFI::exactEdgeLengthRads($index);
is($exactEdgeLengthRads, 1.0344958831218645479632869891048e-5, 'exactEdgeLengthRads');
}

#$ffi->attach(numHexagons => ['int'] => 'int64_t');
my $numHexagons = Geo::H3::FFI::numHexagons($resolution);
is($numHexagons, 33897029882, 'numHexagons');

#$ffi->attach(res0IndexCount => [] => 'int');
my $res0IndexCount = Geo::H3::FFI::res0IndexCount();
is($res0IndexCount, 122, 'res0IndexCount');

#$ffi->attach(pentagonIndexCount => [] => 'int');
my $pentagonIndexCount = Geo::H3::FFI::pentagonIndexCount();
is($pentagonIndexCount, 12, 'pentagonIndexCount');

my $distanceM = 2819.91206504797; #mean Earth radius Rho = 6371.0071809184764922128882879993
my $lat1      = 40.689167;
my $lon1      = -74.044444;
my $lat1_rad  = Geo::H3::FFI::degsToRads($lat1);
my $lon1_rad  = Geo::H3::FFI::degsToRads($lon1);
my $geo1      = Geo::H3::FFI::GeoCoord->new({lat => $lat1_rad, lon => $lon1_rad});
my $lat2      = 40.703468;
my $lon2      = -74.016821;
my $lat2_rad  = Geo::H3::FFI::degsToRads($lat2);
my $lon2_rad  = Geo::H3::FFI::degsToRads($lon2);
my $geo2      = Geo::H3::FFI::GeoCoord->new({lat => $lat2_rad, lon => $lon2_rad});

#$ffi->attach(pointDistKm => ['geo_coord_t', 'geo_coord_t'] => 'double');
my $pointDistKm = Geo::H3::FFI::pointDistKm($geo1, $geo2);
is($pointDistKm, $distanceM/1_000, 'pointDistKm');

#$ffi->attach(pointDistM => ['geo_coord_t', 'geo_coord_t'] => 'double');
my $pointDistM = Geo::H3::FFI::pointDistM($geo1, $geo2);
is($pointDistM, $distanceM, 'pointDistM');

#$ffi->attach(pointDistRads => ['geo_coord_t', 'geo_coord_t'] => 'double');
my $pointDistRads = Geo::H3::FFI::pointDistRads($geo1, $geo2);
is($pointDistRads, 0.000442616368961844, 'pointDistRads');
