use strict;
use warnings;

use Test::More tests => 7;
BEGIN { use_ok('Geo::H3::FFI') };

#$ h3ToGeo -i 8a2a1072b59ffff
#40.6894218437 -74.0444313999

my $str       = '8a2a1072b59ffff';
my $index     = '622236750694711295';
my $lat       = 40.6894218437;
my $lon       = -74.0444313999;
my $lat_rad   = Geo::H3::FFI::degsToRads($lat);
my $lon_rad   = Geo::H3::FFI::degsToRads($lon);

my $h3        = Geo::H3::FFI::H3Index->new({index=>$index});
isa_ok($h3, 'Geo::H3::FFI::H3Index');
is($h3->index, $index);

my $size      = 17;
my $string    = ' ' x $size;
my $void1     = Geo::H3::FFI::h3ToString($h3, \$string, $size);
is($string, $str);
is($size, length($str));

my $geo       = Geo::H3::FFI::GeoCoord->new({});        #empty structure
isa_ok($geo, 'Geo::H3::FFI::GeoCoord');

my $void2     = Geo::H3::FFI::h3ToGeo($h3, $geo); #assigns into structure
isa_ok($geo, 'Geo::H3::FFI::GeoCoord');
is($geo->lat, $lat_rad, '$geo->lat');
is($geo->lon, $lon_rad, '$geo->lon');
