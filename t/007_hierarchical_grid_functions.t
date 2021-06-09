use strict;
use warnings;
use Data::Dumper qw{Dumper};
use Test::More tests => 10;
require_ok 'Geo::H3::FFI';

my $obj = Geo::H3::FFI->new;
isa_ok($obj, 'Geo::H3::FFI');

#$ geoToH3 --lat 40.689167 --lon -74.044444 --resolution 10
#8a2a1072b59ffff

my $lat        = 40.689167;
my $lon        = -74.044444;
my $index      = 622236750694711295;   #8a2a1072b59ffff
my $resolution = 10;
my $parent     = '617733151067471871'; #892a1072b5bffff @9
my $child      = '626740350322053119'; #8b2a1072b598fff @11 #this hex is to the north of 40.689167 -74.044444 by one hex
is(sprintf("%x", $index ), '8a2a1072b59ffff', 'index' );
is(sprintf("%x", $parent), '892a1072b5bffff', 'parent');
is(sprintf("%x", $child ), '8b2a1072b598fff', 'child' );

#h3ToParent
my $h3ToParent = $obj->h3ToParent($index, $resolution-1);
is($h3ToParent, $parent, 'h3ToParent');

#h3ToChildren
my $children = $obj->h3ToChildrenWrapper($index, 11);
isa_ok($children, 'ARRAY', 'h3ToChildrenWrapper');
is(scalar(@$children), 7, 'h3ToChildrenWrapper');
diag Dumper $children;

#maxH3ToChildrenSize
is($obj->maxH3ToChildrenSize($index, 11), 7, 'maxH3ToChildrenSize');

#h3ToCenterChild
my $h3ToCenterChild = $obj->h3ToCenterChild($index, $resolution+1);
is($h3ToCenterChild, $child, 'h3ToCenterChild'); #8b2a1072b59bfff

#compact
#uncompact
#maxUncompactSize
