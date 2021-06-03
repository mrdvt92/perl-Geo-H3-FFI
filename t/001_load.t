use strict;
use warnings;

use Test::More tests => 11;
use Test::Number::Delta;

require_ok 'Geo::H3::FFI';

my $obj = Geo::H3::FFI->new;
isa_ok($obj, 'Geo::H3::FFI');

my $geo = Geo::H3::FFI::GeoCoord->new({});
isa_ok($geo, 'Geo::H3::FFI::GeoCoord');

my $pi  = '3.14159265358979';

delta_within($obj->degsToRads(0),       0, 1e-11);
delta_within($obj->degsToRads(90),  $pi/2, 1e-11);
delta_within($obj->degsToRads(180),   $pi, 1e-11);
delta_within($obj->degsToRads(360), 2*$pi, 1e-11);
delta_within($obj->radsToDegs(0),       0, 1e-11);
delta_within($obj->radsToDegs($pi/2),  90, 1e-11);
delta_within($obj->radsToDegs($pi),   180, 1e-11);
delta_within($obj->radsToDegs(2*$pi), 360, 1e-11);
