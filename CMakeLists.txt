cmake_minimum_required(VERSION 3.8)

project (FARGPARSE
  VERSION 0.9.0
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

add_subdirectory(extern)
add_subdirectory (src)

if (examples)
  add_subdirectory(Examples)
endif()

find_package (PFUNIT 4.0.1 QUIET)
if (PFUNIT_FOUND)
  project (GFTL-TEST
    VERSION ${GFTL_VERSION}
    LANGUAGES Fortran
    )

  set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${GFTL_SOURCE_DIR}/cmake_utils")
  include (${CMAKE_Fortran_COMPILER_ID} RESULT_VARIABLE found)

  enable_testing()
  if (NOT TARGET (tests))
    add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND})
  endif ()
  
  add_subdirectory(tests)
endif ()

# find_package() support
configure_file (FARGPARSEConfig-version.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig-version.cmake @ONLY)
configure_file (FARGPARSEConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig.cmake @ONLY)

set (top_dir FARGPARSE-${FARGPARSE_VERSION_MAJOR}.${FARGPARSE_VERSION_MINOR})
install (
  FILES ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig.cmake ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSEConfig-version.cmake
  DESTINATION "${top_dir}/cmake")

# The following is needed for external projects using *nix make when
# parent project builds fArgParse as a subproject.
set (FARGPARSE_TOP_DIR "${CMAKE_INSTALL_PREFIX}/${top_dir}" CACHE PATH "")
configure_file (FARGPARSE.mk.in ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE.mk @ONLY)
install (
  FILES ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE.mk ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE.mk
  DESTINATION "${top_dir}/include")

