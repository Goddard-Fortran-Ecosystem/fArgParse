cmake_minimum_required(VERSION 3.12)

project (FARGPARSE

  VERSION 1.4.2
  LANGUAGES Fortran)

# Most users of this software do not (should not?) have permissions to
# install in the cmake default of /usr/local (or equiv on other os's).
# Below, the default is changed to a directory within the build tree
# unless the user explicitly sets CMAKE_INSTALL_PREFIX in the cache.
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set (CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/installed" CACHE PATH "default install path" FORCE )
endif()

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
include(${CMAKE_Fortran_COMPILER_ID} RESULT_VARIABLE found)
if(NOT found)
  message( FATAL_ERROR "Unrecognized Fortran compiler. Please use ifort, gfortran, NAG, PGI, or XL.")
endif()

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

include(build_submodule)
build_submodule(extern/gFTL-shared PROJECT GFTL_SHARED TARGET GFTL_SHARED::gftl-shared-v2)

add_subdirectory (src)

if (examples)
  add_subdirectory(Examples)
endif()

find_package (PFUNIT 4.0.1 QUIET)
if (PFUNIT_FOUND)
  project (FARGPARSE_-TEST
    VERSION ${FARGPARSE_VERSION}
    LANGUAGES Fortran
    )

  set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${GFTL_SOURCE_DIR}/cmake_utils")
  include (${CMAKE_Fortran_COMPILER_ID} RESULT_VARIABLE found)

  enable_testing()
  if (NOT TARGET tests)
    add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND})
  endif ()

  add_subdirectory(tests)
endif ()

# The following is needed for external projects using *nix make when
# parent project builds fArgParse as a subproject.
set (top_dir FARGPARSE-${FARGPARSE_VERSION_MAJOR}.${FARGPARSE_VERSION_MINOR})
set (FARGPARSE_TOP_DIR "${CMAKE_INSTALL_PREFIX}/${top_dir}" CACHE PATH "")

# find_package() support
include(CMakePackageConfigHelpers)
configure_package_config_file(FARGPARSEConfig.cmake.in FARGPARSEConfig.cmake
  INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig.cmake
  )
write_basic_package_version_file(FARGPARSEConfig-version.cmake
  VERSION ${PACKAGE_VERSION}
  COMPATIBILITY SameMajorVersion
  )

install (
  FILES ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig.cmake ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig-version.cmake
  DESTINATION "${top_dir}/cmake")

configure_file (FARGPARSE.mk.in ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE.mk @ONLY)
install (
  FILES ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE.mk ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE.mk
  DESTINATION "${top_dir}/include")

install(EXPORT FARGPARSE
  FILE FARGPARSETargets.cmake
  NAMESPACE FARGPARSE::
  DESTINATION "${top_dir}/cmake"
  )
export(EXPORT FARGPARSE
  FILE "${CMAKE_CURRENT_BINARY_DIR}/FARGPARSETargets.cmake"
  NAMESPACE FARGPARSE::
  )
