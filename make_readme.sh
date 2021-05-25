echo "Building README.md"
pod2markdown lib/Geo/H3/FFI.pm > README.md &
echo "Building README"
pod2text     lib/Geo/H3/FFI.pm > README &
wait
