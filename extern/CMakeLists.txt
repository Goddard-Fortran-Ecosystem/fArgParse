# We attempt to use find_package() first for each dependency.  But all
# dependencies are also available as submodules.

include(build_submodule)
build_submodule(gFTL PROJECT GFTL TARGET gftl)
build_submodule(gFTL-shared PROJECT GFTL_SHARED TARGET gftl-shared)
