package Geo::H3::FFI;
use strict;
use warnings;
use base qw{Package::New};
use FFI::CheckLib qw{};
use FFI::Platypus qw{};
use FFI::C qw{};

our $VERSION = '0.01';

my $lib = FFI::CheckLib::find_lib_or_die(lib => 'h3');
my $ffi = FFI::Platypus->new(api => 1, lib => $lib);
FFI::C->ffi($ffi); #Beware: Class setting

package Geo::H3::FFI::H3Index       {FFI::C->struct(h3_index_t        => [index       => 'uint64'                              ])};
package Geo::H3::FFI::GeoCoord      {FFI::C->struct(geo_coord_t       => [lat         => 'double', lon   => 'double'           ])};
package Geo::H3::FFI::ArrayGeoCoord {FFI::C->array (array_geo_coord_t => [geo_coord_t => 10                                    ])};
package Geo::H3::FFI::GeoBoundary   {FFI::C->struct(geo_boundary_t    => [num_verts   => 'int'   , verts => 'array_geo_coord_t'])};

=head1 NAME

Geo::H3::FFI - Perl FFI binding to H3 library functions

=head1 SYNOPSIS

  use Geo::H3::FFI;

=head1 DESCRIPTION

Perl FFI binding to H3 library functions

=head1 HELPERS

=head1 Indexing Functions

These function are used for finding the H3 index containing coordinates, and for finding the center and boundary of H3 indexes.

=head2 geoToH3

  H3Index geoToH3(const GeoCoord *g, int res);

Indexes the location at the specified resolution, returning the index of the cell containing the location.

  my $H3Index = geoToH3($GeoCoord, $resolution);

Returns 0 on error.

=cut

$ffi->attach(geoToH3 => ['geo_coord_t', 'int'] => 'uint64');

=head2 h3ToGeo

  void h3ToGeo(H3Index h3, GeoCoord *g);

Finds the centroid of the index.

  my $Geo = h3ToGeo($H3Index);

=cut

$ffi->attach(h3ToGeo => ['h3_index_t', 'geo_coord_t'] => 'void');

=head2 h3ToGeoBoundary

  void h3ToGeoBoundary(H3Index h3, GeoBoundary *gp);

Finds the boundary of the index.

  my $Boundary = h3ToGeoBoundary($H3Index);

=cut

$ffi->attach(h3ToGeoBoundary => ['h3_index_t', 'geo_boundary_t'] => 'void');

=head1 Index Inspection Functions

These functions provide metadata about an H3 index, such as its resolution or base cell, and provide utilities for converting into and out of the 64-bit representation of an H3 index.

=head2 h3GetResolution

Returns the resolution of the index.

=cut

$ffi->attach(h3GetResolution => ['h3_index_t'] => 'int');

=head2 h3GetBaseCell

Returns the base cell number of the index.

=cut

$ffi->attach(h3GetBaseCell => ['h3_index_t'] => 'int');

=head2 stringToH3

Converts the string representation to H3Index (uint64_t) representation.

Returns 0 on error.

=cut

$ffi->attach(stringToH3 => ['opaque', 'size_t'] => 'h3_index_t');

=head2 h3ToString

Converts the H3Index representation of the index to the string representation. str must be at least of length 17.

=cut

$ffi->attach(h3ToString => ['h3_index_t', 'string', 'size_t'] => 'void');

=head2 h3IsValid

=cut

$ffi->attach(h3IsValid => ['h3_index_t'] => 'int');

=head2 h3IsResClassIII

Returns non-zero if this index has a resolution with Class III orientation.

=cut

$ffi->attach(h3IsResClassIII => ['h3_index_t'] => 'int');

=head2 h3IsPentagon

Returns non-zero if this index represents a pentagonal cell.

=cut

$ffi->attach(h3IsPentagon => ['h3_index_t'] => 'int');

=head2 h3GetFaces

Find all icosahedron faces intersected by a given H3 index and places them in the array out. out must be at least of length maxFaceCount(h).

Faces are represented as integers from 0-19, inclusive. The array is sparse, and empty (no intersection) array values are represented by -1.

=cut

$ffi->attach(h3GetFaces => ['h3_index_t', 'int'] => 'void');

=head2 maxFaceCount

Returns the maximum number of icosahedron faces the given H3 index may intersect.

=cut

$ffi->attach(maxFaceCount => ['h3_index_t'] => 'int');

=head1 Grid traversal functions

Grid traversal allows finding cells in the vicinity of an origin cell, and determining how to traverse the grid from one cell to another.

=head2 kRing

  void kRing(H3Index origin, int k, H3Index* out);

k-rings produces indices within k distance of the origin index.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indices, and so on.

Output is placed in the provided array in no particular order. Elements of the output array may be left zero, as can happen when crossing a pentagon.

=cut

$ffi->attach(kRing => ['h3_index_t', 'geo_boundary_t'] => 'void');

=head2 maxKringSize

=cut


=head2 kRingDistances


=cut

=head2 hexRange

=cut

=head2 hexRangeDistances

=cut


=head2 hexRanges

=cut


=head2 hexRing


=cut

=head2 h3Line


=cut

=head2 h3LineSize


=cut

=head2 h3Distance


=cut

=head2 experimentalH3ToLocalIj


=cut

=head2 experimentalLocalIjToH3


=cut

=head1 Hierarchical grid functions

These functions permit moving between resolutions in the H3 grid system. The functions produce parent (coarser) or children (finer) cells.

=head2 polyfill


=cut

=head2 h3ToParent


=cut

=head2 h3ToChildren


=cut

=head2 h3ToCent
=cut


=head2 h3SetToMultiPolygon


=cut

=head2 degsToRads


=cut

$ffi->attach(degsToRads => ['double'] => 'double');


=head2 radsToDegs


=cut

$ffi->attach(radsToDegs => ['double'] => 'double');


=head2 pointDist


=cut

=head2 hexArea


=cut

=head2 cellArea


=cut

=head2 edgeLength


=cut

=head2 exactEdgeLength


=cut

=head2 numHexagons


=cut

=head2 getRes0Indexes


=cut

=head2 getPentagonIndexes


=cut

=head2 compact


=cut

=head2 uncompact


=cut

=head2 h3IndexesAreNeighbors


=cut

=head2 getH3UnidirectionalEdge


=cut

=head2 h3UnidirectionalEdgeIsValid


=cut

=head2 getOriginH3IndexFromUnidirectionalEdge


=cut

=head2 getDestinationH3IndexFromUnidirectionalEdge


=cut

=head2 getH3IndexesFromUnidirectionalEdge


=cut

=head2 getH3UnidirectionalEdgesFromHexagon


=cut

=head2 getH3UnidirectionalEdgeBoundary


=cut

=head1 SEE ALSO

=head1 AUTHOR

Michael R. Davis

=head1 COPYRIGHT AND LICENSE

MIT License

Copyright (c) 2020 Michael R. Davis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut

1;
