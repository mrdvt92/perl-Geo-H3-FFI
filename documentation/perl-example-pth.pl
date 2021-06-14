#!/usr/bin/env perl
use strict;
use warnings;
use FFI::Platypus;
use FFI::C;

my $ffi = FFI::Platypus->new(api=>1, lib=>'libh3.so');
FFI::C->ffi($ffi);

$ffi->attach(degsToRads => ['double'] => 'double');
$ffi->attach(radsToDegs => ['double'] => 'double');

package GeoCoord {
  FFI::C->struct([ lat => 'double', lon => 'double' ])
}

$ffi->attach(geoToH3 => [ 'geo_coord_t', 'int' ] => 'uint64');
$ffi->attach(h3ToGeo => [ 'uint64', 'geo_coord_t' ]);

my ( $lt, $ln ) = ( 40.689167, -74.044444 );
my ( $lat, $lon ) = ( degsToRads($lt),  degsToRads($ln));
my ( $olt, $oln ) = ( radsToDegs($lat), radsToDegs($lon));

print "$lt -> $lat -> (and back) -> $olt \n";
print "$ln -> $lon -> (and back) -> $oln \n";

my $gc = GeoCoord->new({ lat => $lat, lon => $lon });
my $level = 10;
my $index = geoToH3( $gc, $level );

printf "index: %s; index in hex %s\n", $index, sprintf("0x%X", $index);

my $gc2 = GeoCoord->new({});

my ($gc2lat, $gc2lon) = ( $gc2->lat, $gc2->lon );
printf "gc2lat: %s -> degs: %s ; gc2lon: %s -> degs: %s\n", $gc2lat, radsToDegs($gc2lat), $gc2lon, radsToDegs($gc2lon);
