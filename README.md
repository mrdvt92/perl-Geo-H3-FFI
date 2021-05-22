# NAME

Geo::H3::FFI - Perl FFI binding to H3 library functions

# SYNOPSIS

    use Geo::H3::FFI;

# DESCRIPTION

Perl FFI binding to H3 library functions

# HELPERS

# Indexing Functions

These function are used for finding the H3 index containing coordinates, and for finding the center and boundary of H3 indexes.

## geoToH3

    H3Index geoToH3(const GeoCoord *g, int res);

Indexes the location at the specified resolution, returning the index of the cell containing the location.

    my $H3Index = geoToH3($GeoCoord, $resolution);

Returns 0 on error.

## h3ToGeo

    void h3ToGeo(H3Index h3, GeoCoord *g);

Finds the centroid of the index.

    my $Geo = h3ToGeo($H3Index);

## h3ToGeoBoundary

    void h3ToGeoBoundary(H3Index h3, GeoBoundary *gp);

Finds the boundary of the index.

    my $Boundary = h3ToGeoBoundary($H3Index);

# Index Inspection Functions

These functions provide metadata about an H3 index, such as its resolution or base cell, and provide utilities for converting into and out of the 64-bit representation of an H3 index.

## h3GetResolution

Returns the resolution of the index.

## h3GetBaseCell

Returns the base cell number of the index.

## stringToH3

Converts the string representation to H3Index (uint64\_t) representation.

Returns 0 on error.

## h3ToString

Converts the H3Index representation of the index to the string representation. str must be at least of length 17.

## h3IsValid

## h3IsResClassIII

Returns non-zero if this index has a resolution with Class III orientation.

## h3IsPentagon

Returns non-zero if this index represents a pentagonal cell.

## h3GetFaces

Find all icosahedron faces intersected by a given H3 index and places them in the array out. out must be at least of length maxFaceCount(h).

Faces are represented as integers from 0-19, inclusive. The array is sparse, and empty (no intersection) array values are represented by -1.

## maxFaceCount

Returns the maximum number of icosahedron faces the given H3 index may intersect.

# Grid traversal functions

Grid traversal allows finding cells in the vicinity of an origin cell, and determining how to traverse the grid from one cell to another.

## kRing

    void kRing(H3Index origin, int k, H3Index* out);

k-rings produces indices within k distance of the origin index.

k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0 and all neighboring indices, and so on.

Output is placed in the provided array in no particular order. Elements of the output array may be left zero, as can happen when crossing a pentagon.

## maxKringSize

## kRingDistances

## hexRange

## hexRangeDistances

## hexRanges

## hexRing

## h3Line

## h3LineSize

## h3Distance

## experimentalH3ToLocalIj

## experimentalLocalIjToH3

# Hierarchical grid functions

These functions permit moving between resolutions in the H3 grid system. The functions produce parent (coarser) or children (finer) cells.

## polyfill

## h3ToParent

## h3ToChildren

## h3ToCent

## h3SetToMultiPolygon

## degsToRads

## radsToDegs

## pointDist

## hexArea

## cellArea

## edgeLength

## exactEdgeLength

## numHexagons

## getRes0Indexes

## getPentagonIndexes

## compact

## uncompact

## h3IndexesAreNeighbors

## getH3UnidirectionalEdge

## h3UnidirectionalEdgeIsValid

## getOriginH3IndexFromUnidirectionalEdge

## getDestinationH3IndexFromUnidirectionalEdge

## getH3IndexesFromUnidirectionalEdge

## getH3UnidirectionalEdgesFromHexagon

## getH3UnidirectionalEdgeBoundary

# SEE ALSO

# AUTHOR

Michael R. Davis

# COPYRIGHT AND LICENSE

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
