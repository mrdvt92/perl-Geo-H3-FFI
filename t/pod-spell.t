use Test::More;
eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling" if $@;
add_stopwords(<DATA>);
all_pod_files_spelling_ok();

__DATA__
MERCHANTABILITY
NONINFRINGEMENT
sublicense
Geospatial
H3
H3Index
cellArea
degsToRads
edgeLength
exactEdgeLength
experimentalH3ToLocalIj
experimentalLocalIjToH3
geoToH3
getDestinationH3IndexFromUnidirectionalEdge
getH3IndexesFromUnidirectionalEdge
getH3UnidirectionalEdge
getH3UnidirectionalEdgeBoundary
getH3UnidirectionalEdgesFromHexagon
getOriginH3IndexFromUnidirectionalEdge
getPentagonIndexes
getRes0Indexes
h3Distance
h3GetBaseCell
h3GetFaces
h3GetResolution
h3IndexesAreNeighbors
h3IsPentagon
h3IsResClassIII
h3IsValid
h3Line
h3SetToMultiPolygon
h3ToCenterChild
h3ToChildren
h3ToGeo
h3ToGeoBoundary
h3ToParent
h3ToString
h3UnidirectionalEdgeIsValid
hexArea
hexRing
icosahedron
kRing
kRingDistances
maxFaceCount
numHexagons
pointDist
polyfill
radsToDegs
str
stringToH3
centroid
uncompact
FFI
h3LineSize
h3ToCent
hexRange
hexRangeDistances
hexRanges
maxKringSize
metadata
GeoCoord
GeoJSON
H3Indexes
IJ
LinkedGeoPolygon
MultiPolygon
Uncompacts
cellAreaM2
cellAreaRads2
cells'
centroids
childRes
compactedSet
destroyLinkedPolygon
edgeLengthKm
edgeLengthM
exactEdgeLengthKm
exactEdgeLengthM
exactEdgeLengthRads
geo
h3Set
h3SetToLinkedGeo
haversine
hexAreaKm2
hexAreaM2
maxH3ToChildrenSize
maxPolyfillSize
maxUncompactSize
numHexes
partioning
pentagonIndexCount
pointDistKm
pointDistM
pointDistRads
radians
res0IndexCount
undirectional
h3ToGeoBoundaryWrapper
h3ToGeoWrapper
h3ToStringWrapper
geoToH3Wrapper
stringToH3Wrapper
gb
GeoBoundary
h3GetFacesWrapper
kRingWrapper
kRingDistancesWrapper
h3LineWrapper
