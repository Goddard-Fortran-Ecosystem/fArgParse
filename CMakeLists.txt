cmake_minimum_required(VERSION 3.8)

project (fParse
  VERSION 0.1
  LANGUAGES Fortran)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")
include(${CMAKE_Fortran_COMPILER_ID} RESULT_VARIABLE found)
if(NOT found)
  message( FATAL_ERROR "Unrecognized Fortran compiler. Please use ifort, gfortran, NAG, PGI, or XL.")
endif()

# Need pFUnit if want to build tests
set(PFUNIT "" CACHE PATH "(optional) path to installed testing framework")

# By default pFUnit uses FTL as a git submodule.   But this can be overridden with:
set(FTL "" CACHE PATH "Optional path to externally installed FTL package.")
include(FindFTL)




add_subdirectory (src)
if (PFUNIT)
  enable_testing()
  add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND})

  add_subdirectory (tests)
endif ()

if (examples)
  add_subdirectory(Examples)
endif()
