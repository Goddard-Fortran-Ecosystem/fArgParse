# We attempt to use find_package() first for each dependency.  But all
# dependencies are also available as submodules.

include(build_submodule)
build_submodule(gFTL PROJECT GFTL TARGET gftl)
build_submodule(gFTL-shared PROJECT GFTL_SHARED TARGET gftl-shared)

add_library (ext INTERFACE)
target_link_libraries (ext INTERFACE gftl gftl-shared)

set (library_dest "lib/FARGPARSE-${FARGPARSE_VERSION_MAJOR}.${FARGPARSE_VERSION_MINOR}")
install (TARGETS ext EXPORT FARGPARSE DESTINATION "${library_dest}")
