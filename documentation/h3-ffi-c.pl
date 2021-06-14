#--perl--
use strict;
use warnings;
use FFI::CheckLib qw{find_lib};
use FFI::Platypus 1.00;
use FFI::C;

my $lib = find_lib(lib=>'h3');
my $ffi = FFI::Platypus->new(
  api => 1,
  lib => [$lib],
);

FFI::C->ffi($ffi);
 
package GeoCoord {
 
  FFI::C->struct(GeoCoord => [
    lat    => 'double',
    lon    => 'double',
  ]);

  $ffi->attach( geoToH3 => ['geo_cord_t', 'int'] => 'uint64_t');
}
 
# now we can actually use our My::UnixTime class
my $geo = GeoCoord->new(lat=>38, lon=>-77);

use Data::Dumper qw{Dumper};
print Dumper($geo);
