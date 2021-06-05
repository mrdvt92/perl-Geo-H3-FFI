use strict;
use warnings;
use Data::Dumper qw{Dumper};
use Test::Number::Delta;
use Test::More tests => 18;
require_ok 'Geo::H3::FFI';

my $obj = Geo::H3::FFI->new;
isa_ok($obj, 'Geo::H3::FFI');

#$ geoToH3 --lat 40.689167 --lon -74.044444 --resolution 10
#8a2a1072b59ffff

my $index      = 622236750694711295;   #8a2a1072b59ffff
my $resolution = 10;
is(sprintf("%x", $index ), '8a2a1072b59ffff', 'index' );
#kRing
{
  my $k    = 0;
  my $size = 1;
  my $aref = $obj->kRingWrapper($index, $k);
  isa_ok($aref, 'ARRAY');
  is(scalar(@$aref), $size, 'size');
  is($obj->maxKringSize($k), $size, 'maxKringSize');
  is($aref->[0], $index, 'index in kRing'); #by defintion K=0 is the index itself
}

{
  my $k    = 1;
  my $size = 7;
  my $aref = $obj->kRingWrapper($index, $k);
  isa_ok($aref, 'ARRAY');
  is(scalar(@$aref), $size, 'size');
  is($obj->maxKringSize($k), $size, 'maxKringSize');
  is((grep {$_ ==  $index} @$aref)[0], $index, 'index in kRing');
}

{
  my $k    = 2;
  my $size = 19;
  my $aref = $obj->kRingWrapper($index, $k);
  isa_ok($aref, 'ARRAY');
  is(scalar(@$aref), $size, 'size');
  is($obj->maxKringSize($k), $size, 'maxKringSize');
  is((grep {$_ ==  $index} @$aref)[0], $index, 'index in kRing');
}
#maxKringSize
#max supported K-ring distance limited to 17
is($obj->maxKringSize(17), 919, 'maxKringSize');

#kRingDistances
#$ffi->attach(kRingDistances => ['uint64_t', 'int', 'uint64_aref_919', 'int_aref_919'] => 'void' => \&_oowrapper);

{
  my $k    = 2;
  my $size = 19;
  my $href = $obj->kRingDistancesWrapper($index, $k);
  isa_ok($href, 'HASH');
  is(scalar(keys %$href), 19, 'size');
  #diag Dumper $href;
}

#hexRange
#hexRangeDistances
#hexRanges
#hexRing
#h3Line
#h3LineSize
#h3Distance
#experimentalH3ToLocalIj
#experimentalLocalIjToH3