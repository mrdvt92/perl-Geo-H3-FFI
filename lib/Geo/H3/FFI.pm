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

#$ffi->type('char *' => 'char_p');
#$ffi->load_custom_type('::StringPointer' => 'string_p');
package Geo::H3::FFI::H3Index       {FFI::C->struct(h3_index_t        => [index       => 'uint64'                              ])};
package Geo::H3::FFI::ArrayH3Index  {FFI::C->array (array_h3_index_t  => [h3_index_t  => 255                                   ])};

package Geo::H3::FFI::GeoCoord      {FFI::C->struct(geo_coord_t       => [lat         => 'double', lon   => 'double'           ])};
package Geo::H3::FFI::ArrayGeoCoord {FFI::C->array (array_geo_coord_t => [geo_coord_t => 10                                    ])};
package Geo::H3::FFI::GeoBoundary   {FFI::C->struct(geo_boundary_t    => [num_verts   => 'int'   , verts => 'array_geo_coord_t'])};

=head1 NAME

Geo::H3::FFI - Perl FFI binding to H3 library functions

=head1 SYNOPSIS

  use Geo::H3::FFI;

=head1 DESCRIPTION

Perl FFI binding to H3 library functions

=head1 Indexing Functions

These function are used for finding the H3 index containing coordinates, and for finding the center and boundary of H3 indexes.

=head2 geoToH3

  H3Index geoToH3(const GeoCoord *g, int res);

Indexes the location at the specified resolution, returning the index of the cell containing the location.

  my $H3Index = geoToH3($GeoCoord, $resolution);

Returns 0 on error.

=cut

#H3Index geoToH3(const GeoCoord *g, int res);
$ffi->attach(geoToH3 => ['geo_coord_t', 'int'] => 'uint64');

=head2 h3ToGeo

  void h3ToGeo(H3Index h3, GeoCoord *g);

Finds the centroid of the index.

  my $Geo = h3ToGeo($H3Index);

=cut

#void h3ToGeo(H3Index h3, GeoCoord *g);
$ffi->attach(h3ToGeo => ['uint64_t', 'geo_coord_t'] => 'void');

=head2 h3ToGeoBoundary

  void h3ToGeoBoundary(H3Index h3, GeoBoundary *gp);

Finds the boundary of the index.

  my $Boundary = h3ToGeoBoundary($H3Index);

=cut

#void h3ToGeoBoundary(H3Index h3, GeoBoundary *gp);
$ffi->attach(h3ToGeoBoundary => ['h3_index_t', 'geo_boundary_t'] => 'void');

=head1 Index Inspection Functions

These functions provide metadata about an H3 index, such as its resolution or base cell, and provide utilities for converting into and out of the 64-bit representation of an H3 index.

=head2 h3GetResolution

Returns the resolution of the index.

=cut

#int h3GetResolution(H3Index h);
$ffi->attach(h3GetResolution => ['h3_index_t'] => 'int');

=head2 h3GetBaseCell

Returns the base cell number of the index.

=cut

#int h3GetBaseCell(H3Index h);
$ffi->attach(h3GetBaseCell => ['h3_index_t'] => 'int');

=head2 stringToH3

Converts the string representation to H3Index (uint64_t) representation.

Returns 0 on error.

=cut

#H3Index stringToH3(const char *str);
$ffi->attach(stringToH3 => ['string', 'size_t'] => 'uint64_t');

=head2 h3ToString

Converts the H3Index representation of the index to the string representation. str must be at least of length 17.

=cut

#void h3ToString(H3Index h, char *str, size_t sz);
$ffi->attach(h3ToString => ['uint64_t', 'string', 'size_t'] => 'void');

=head2 h3IsValid

Returns non-zero if this is a valid H3 index.

=cut

#int h3IsValid(H3Index h);
$ffi->attach(h3IsValid => ['h3_index_t'] => 'int');

=head2 h3IsResClassIII

Returns non-zero if this index has a resolution with Class III orientation.

=cut

#int h3IsResClassIII(H3Index h);
$ffi->attach(h3IsResClassIII => ['h3_index_t'] => 'int');

=head2 h3IsPentagon

Returns non-zero if this index represents a pentagonal cell.

=cut

#int h3IsPentagon(H3Index h);
$ffi->attach(h3IsPentagon => ['h3_index_t'] => 'int');

=head2 h3GetFaces

Find all icosahedron faces intersected by a given H3 index and places them in the array out. out must be at least of length maxFaceCount(h).

Faces are represented as integers from 0-19, inclusive. The array is sparse, and empty (no intersection) array values are represented by -1.

=cut

#void h3GetFaces(H3Index h, int* out);
$ffi->attach(h3GetFaces => ['h3_index_t', 'int'] => 'void');

=head2 maxFaceCount

Returns the maximum number of icosahedron faces the given H3 index may intersect.

=cut

#int maxFaceCount(H3Index h3);
$ffi->attach(maxFaceCount => ['h3_index_t'] => 'int');

=head1 Grid traversal functions

Grid traversal allows finding cells in the vicinity of an origin cell, and determining how to traverse the grid from one cell to another.

=head2 kRing

  void kRing(H3Index origin, int k, H3Index* out);

k-rings produces indices within k distance of the origin index.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indices, and so on.

Output is placed in the provided array in no particular order. Elements of the output array may be left zero, as can happen when crossing a pentagon.

=cut

#void kRing(H3Index origin, int k, H3Index* out);
$ffi->attach(kRing => ['h3_index_t', 'int', 'array_h3_index_t'] => 'void');

=head2 maxKringSize

Maximum number of indices that result from the kRing algorithm with the given k.

=cut

#int maxKringSize(int k);
$ffi->attach(maxKringSize => ['int'] => 'int');

=head2 kRingDistances

k-rings produces indices within k distance of the origin index.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indices, and so on.

Output is placed in the provided array in no particular order. Elements of the output array may be left zero, as can happen when crossing a pentagon.

=cut

#void kRingDistances(H3Index origin, int k, H3Index* out, int* distances);
$ffi->attach(kRingDistances => ['h3_index_t', 'int', 'array_h3_index_t', 'int *'] => 'void');

=head2 hexRange

hexRange produces indexes within k distance of the origin index. Output behavior is undefined when one of the indexes returned by this function is a pentagon or is in the pentagon distortion area.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indexes, and so on.

Output is placed in the provided array in order of increasing distance from the origin.

Returns 0 if no pentagonal distortion is encountered.

=cut

#int hexRange(H3Index origin, int k, H3Index* out);
$ffi->attach(hexRange => ['h3_index_t', 'int', 'array_h3_index_t'] => 'int');

=head2 hexRangeDistances

hexRange produces indexes within k distance of the origin index. Output behavior is undefined when one of the indexes returned by this function is a pentagon or is in the pentagon distortion area.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indexes, and so on.

Output is placed in the provided array in order of increasing distance from the origin. The distances in hexagons is placed in the distances array at the same offset.

Returns 0 if no pentagonal distortion is encountered.

=cut

#int hexRangeDistances(H3Index origin, int k, H3Index* out, int* distances);
$ffi->attach(hexRangeDistances => ['h3_index_t', 'int', 'array_h3_index_t', 'int*'] => 'int');

=head2 hexRanges

hexRanges takes an array of input hex IDs and a max k-ring and returns an array of hexagon IDs sorted first by the original hex IDs and then by the k-ring (0 to max), with no guaranteed sorting within each k-ring group.

Returns 0 if no pentagonal distortion was encountered. Otherwise, output is undefined

=cut

#int hexRanges(H3Index* h3Set, int length, int k, H3Index* out);

=head2 hexRing

Produces the hollow hexagonal ring centered at origin with sides of length k.

Returns 0 if no pentagonal distortion was encountered.

=cut

#int hexRing(H3Index origin, int k, H3Index* out);

=head2 h3Line

Given two H3 indexes, return the line of indexes between them (inclusive).

This function may fail to find the line between two indexes, for example if they are very far apart. It may also fail when finding distances for indexes on opposite sides of a pentagon.

Notes:

 - The specific output of this function should not be considered stable across library versions. The only guarantees the library provides are that the line length will be h3Distance(start, end) + 1 and that every index in the line will be a neighbor of the preceding index.

 - Lines are drawn in grid space, and may not correspond exactly to either Cartesian lines or great arcs.

=cut

#int h3Line(H3Index start, H3Index end, H3Index* out);

=head2 h3LineSize

Number of indexes in a line from the start index to the end index, to be used for allocating memory. Returns a negative number if the line cannot be computed.

=cut

#int h3LineSize(H3Index start, H3Index end);

=head2 h3Distance

Returns the distance in grid cells between the two indexes.

Returns a negative number if finding the distance failed. Finding the distance can fail because the two indexes are not comparable (different resolutions), too far apart, or are separated by pentagonal distortion. This is the same set of limitations as the local IJ coordinate space functions.

=cut

#int h3Distance(H3Index origin, H3Index h3);

=head2 experimentalH3ToLocalIj

Produces local IJ coordinates for an H3 index anchored by an origin.

This function is experimental, and its output is not guaranteed to be compatible across different versions of H3.

=cut

#int experimentalH3ToLocalIj(H3Index origin, H3Index h3, CoordIJ *out);


=head2 experimentalLocalIjToH3

Produces an H3 index from local IJ coordinates anchored by an origin.

This function is experimental, and its output is not guaranteed to be compatible across different versions of H3.

=cut

#int experimentalLocalIjToH3(H3Index origin, const CoordIJ *ij, H3Index *out);

=head1 Hierarchical grid functions

These functions permit moving between resolutions in the H3 grid system. The functions produce parent (coarser) or children (finer) cells.

=head2 h3ToParent

Returns the parent (coarser) index containing h.

=cut

#H3Index h3ToParent(H3Index h, int parentRes);

=head2 h3ToChildren

Populates children with the indexes contained by h at resolution childRes. children must be an array of at least size maxH3ToChildrenSize(h, childRes).

=cut

#void h3ToChildren(H3Index h, int childRes, H3Index *children);

=head2 maxH3ToChildrenSize

=cut

#int maxH3ToChildrenSize(H3Index h, int childRes);

=head2 h3ToCenterChild

Returns the center child (finer) index contained by h at resolution childRes.

=cut

#H3Index h3ToCenterChild(H3Index h, int childRes);

=head2 compact

Compacts the set h3Set of indexes as best as possible, into the array compactedSet. compactedSet must be at least the size of h3Set in case the set cannot be compacted.

Returns 0 on success.

=cut

#int compact(const H3Index *h3Set, H3Index *compactedSet, const int numHexes);

=head2 uncompact

Uncompacts the set compactedSet of indexes to the resolution res. h3Set must be at least of size maxUncompactSize(compactedSet, numHexes, res).

Returns 0 on success.

=cut

#int uncompact(const H3Index *compactedSet, const int numHexes, H3Index *h3Set, const int maxHexes, const int res);

=head2 maxUncompactSize

Returns the size of the array needed by uncompact.

=cut

#int maxUncompactSize(const H3Index *compactedSet, const int numHexes, const int res)

=head1 Region functions

These functions convert H3 indexes to and from polygonal areas.

=head2 polyfill

polyfill takes a given GeoJSON-like data structure and preallocated, zeroed memory, and fills it with the hexagons that are contained by the GeoJSON-like data structure.

Containment is determined by the cells' centroids. A partioning using the GeoJSON-like data structure, where polygons cover an area without overlap, will result in a partitioning in the H3 grid, where cells cover the same area without overlap.

=cut

#void polyfill(const GeoPolygon* geoPolygon, int res, H3Index* out);

=head2 maxPolyfillSize

maxPolyfillSize returns the number of hexagons to allocate space for when performing a polyfill on the given GeoJSON-like data structure.

=cut

#int maxPolyfillSize(const GeoPolygon* geoPolygon, int res);

=head2 h3SetToLinkedGeo

Create a LinkedGeoPolygon describing the outline(s) of a set of hexagons. Polygon outlines will follow GeoJSON MultiPolygon order: Each polygon will have one outer loop, which is first in the list, followed by any holes.

It is the responsibility of the caller to call destroyLinkedPolygon on the populated linked geo structure, or the memory for that structure will not be freed.

It is expected that all hexagons in the set have the same resolution and that the set contains no duplicates. Behavior is undefined if duplicates or multiple resolutions are present, and the algorithm may produce unexpected or invalid output.

=cut

#void h3SetToLinkedGeo(const H3Index* h3Set, const int numHexes, LinkedGeoPolygon* out);

=head2 h3SetToMultiPolygon

=cut

#void h3SetToMultiPolygon(const H3Index* h3Set, const int numHexes, MultiPolygon* out);

=head2 destroyLinkedPolygon

Free all allocated memory for a linked geo structure. The caller is responsible for freeing memory allocated to the input polygon struct.

=cut

=head1 Unidirectional edge functions

Unidirectional edges allow encoding the directed edge from one cell to a neighboring cell.

=head2 h3IndexesAreNeighbors

Returns whether or not the provided H3Indexes are neighbors.

Returns 1 if the indexes are neighbors, 0 otherwise.

=cut

#int h3IndexesAreNeighbors(H3Index origin, H3Index destination);

=head2 getH3UnidirectionalEdge

Returns a unidirectional edge H3 index based on the provided origin and destination.

Returns 0 on error.

=cut

#H3Index getH3UnidirectionalEdge(H3Index origin, H3Index destination);

=head2 h3UnidirectionalEdgeIsValid

Determines if the provided H3Index is a valid unidirectional edge index.

Returns 1 if it is a unidirectional edge H3Index, otherwise 0.

=cut

#int h3UnidirectionalEdgeIsValid(H3Index edge);

=head2 getOriginH3IndexFromUnidirectionalEdge

Returns the origin hexagon from the unidirectional edge H3Index.

=cut

#H3Index getOriginH3IndexFromUnidirectionalEdge(H3Index edge);

=head2 getDestinationH3IndexFromUnidirectionalEdge

Returns the destination hexagon from the unidirectional edge H3Index.

=cut

#H3Index getDestinationH3IndexFromUnidirectionalEdge(H3Index edge);

=head2 getH3IndexesFromUnidirectionalEdge

Returns the origin, destination pair of hexagon IDs for the given edge ID, which are placed at originDestination[0] and originDestination[1] respectively.

=cut

#void getH3IndexesFromUnidirectionalEdge(H3Index edge, H3Index* originDestination);

=head2 getH3UnidirectionalEdgesFromHexagon

Provides all of the unidirectional edges from the current H3Index. edges must be of length 6, and the number of undirectional edges placed in the array may be less than 6.

=cut

#void getH3UnidirectionalEdgesFromHexagon(H3Index origin, H3Index* edges);

=head2 getH3UnidirectionalEdgeBoundary

Provides the coordinates defining the unidirectional edge.

=cut

#void getH3UnidirectionalEdgeBoundary(H3Index edge, GeoBoundary* gb);

=head1 Miscellaneous H3 functions

These functions include descriptions of the H3 grid system.

=head2 degsToRads

Converts degrees to radians.

=cut

#double degsToRads(double degrees);
$ffi->attach(degsToRads => ['double'] => 'double');

=head2 radsToDegs

Converts radians to degrees.

=cut

#double radsToDegs(double radians);
$ffi->attach(radsToDegs => ['double'] => 'double');

=head2 hexAreaKm2

Average hexagon area in square kilometers at the given resolution.

=cut

#double hexAreaKm2(int res);

=head2 hexAreaM2

Average hexagon area in square meters at the given resolution.

=cut

#double hexAreaM2(int res);

=head2 cellAreaM2

Exact area of specific cell in square meters.

=cut

#double cellAreaM2(H3Index h);

=head2 cellAreaRads2

Exact area of specific cell in square radians.

=cut

#double cellAreaRads2(H3Index h);

=head2 edgeLengthKm

Average hexagon edge length in kilometers at the given resolution.

=cut

#double edgeLengthKm(int res);

=head2 edgeLengthM

Average hexagon edge length in meters at the given resolution.

=cut

#double edgeLengthM(int res);

=head2 exactEdgeLengthKm

Exact edge length of specific unidirectional edge in kilometers.

=cut

#double exactEdgeLengthKm(H3Index edge);

=head2 exactEdgeLengthM

Exact edge length of specific unidirectional edge in meters.

=cut

#double exactEdgeLengthM(H3Index edge);

=head2 exactEdgeLengthRads

Exact edge length of specific unidirectional edge in radians.

=cut

#double exactEdgeLengthRads(H3Index edge);

=head2 numHexagons

Number of unique H3 indexes at the given resolution.

=cut

#int64_t numHexagons(int res);

=head2 getRes0Indexes

All the resolution 0 H3 indexes. out must be an array of at least size res0IndexCount().

=cut

#void getRes0Indexes(H3Index *out);

=head2 res0IndexCount

Number of resolution 0 H3 indexes.

=cut

#int res0IndexCount();

=head2 getPentagonIndexes

All the pentagon H3 indexes at the specified resolution. out must be an array of at least size pentagonIndexCount().

=cut

#void getPentagonIndexes(int res, H3Index *out);

=head2 pentagonIndexCount

Number of pentagon H3 indexes per resolution. This is always 12, but provided as a convenience.

=cut

#int pentagonIndexCount();

=head2 pointDistKm

Gives the "great circle" or "haversine" distance between pairs of GeoCoord points (lat/lng pairs) in kilometers.

=cut

#double pointDistKm(const GeoCoord *a, const GeoCoord *b);

=head2 pointDistM

Gives the "great circle" or "haversine" distance between pairs of GeoCoord points (lat/lng pairs) in meters.

=cut

#double pointDistM(const GeoCoord *a, const GeoCoord *b);

=head2 pointDistRads

Gives the "great circle" or "haversine" distance between pairs of GeoCoord points (lat/lng pairs) in radians.

=cut

#double pointDistRads(const GeoCoord *a, const GeoCoord *b);

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
