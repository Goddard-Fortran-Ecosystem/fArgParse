cmake_minimum_required(VERSION 3.8)

project (FARGPARSE
  VERSION 0.1
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

# Need pFUnit if want to build tests
set(PFUNIT "" CACHE PATH "(optional) path to installed testing framework")

add_subdirectory(extern)
add_subdirectory (src)

if (PFUNIT)
  if (NOT TARGET tests)
    enable_testing()
    add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND})
  endif ()
  add_subdirectory (tests)
endif ()

if (examples)
  add_subdirectory(Examples)
endif()

# find_package() support
configure_file(FARGPARSE-config-version.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE-config-version.cmake @ONLY)
configure_file(FARGPARSE-config.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE-config.cmake @ONLY)
install (
  FILES ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE-config.cmake ${CMAKE_CURRENT_BINARY_DIR}/FARGPARSE-config-version.cmake
  DESTINATION "share/FARGPARSE-${FARGPARSE_VERSION_MAJOR}.${FARGPARSE_VERSION_MINOR}")
