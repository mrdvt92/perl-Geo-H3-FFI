#!perl
use strict;
use warnings;
use FFI::CheckLib qw{find_lib};
use FFI::Platypus qw{};
use Data::Dumper qw{Dumper};
use Convert::Binary::C qw{};
use FFI::C;

my $libPath = find_lib(lib=>'h3');
my $ffiObj  = FFI::Platypus->new(api=>1);
$ffiObj->lib($libPath);
my $c = Convert::Binary::C->new->parse('
struct GeoCoord {
  double lat;
  double lon;
};
');

$ffiObj->attach('geoToH3',['GeoCoord', 'int'],'uint64');

my $lat     = 39.0;
my $lon     = -77.0;
my $level   = 10;
my $ll      = $c->pack({lat=>$lat, $lon=>$lon});
print Dumper({ll=>$ll});
my $h3      = geoToH3($ll, $level);
print Dumper({h3=>$h3});

