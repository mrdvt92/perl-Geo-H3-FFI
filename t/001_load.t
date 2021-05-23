use strict;
use warnings;

use Test::More tests => 10;
use Test::Number::Delta;

BEGIN { use_ok('Geo::H3::FFI') };

my $geo = Geo::H3::FFI::GeoCoord->new({});
isa_ok($geo, 'Geo::H3::FFI::GeoCoord');

my $pi = '3.14159265358979';

delta_within(Geo::H3::FFI::degsToRads(0),       0, 1e-11);
delta_within(Geo::H3::FFI::degsToRads(90),  $pi/2, 1e-11);
delta_within(Geo::H3::FFI::degsToRads(180),   $pi, 1e-11);
delta_within(Geo::H3::FFI::degsToRads(360), 2*$pi, 1e-11);
delta_within(Geo::H3::FFI::radsToDegs(0),       0, 1e-11);
delta_within(Geo::H3::FFI::radsToDegs($pi/2),  90, 1e-11);
delta_within(Geo::H3::FFI::radsToDegs($pi),   180, 1e-11);
delta_within(Geo::H3::FFI::radsToDegs(2*$pi), 360, 1e-11);
