cmake_minimum_required(VERSION 3.8)

project (fArgParse
  VERSION 0.1
  LANGUAGES Fortran)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")
include(${CMAKE_Fortran_COMPILER_ID} RESULT_VARIABLE found)
if(NOT found)
  message( FATAL_ERROR "Unrecognized Fortran compiler. Please use ifort, gfortran, NAG, PGI, or XL.")
endif()

# Need pFUnit if want to build tests
set(PFUNIT "" CACHE PATH "(optional) path to installed testing framework")

find_package(GFTL QUIET)
if (NOT GFTL_FOUND)
  if (NOT TARGET gftl)
    # from https://cliutils.gitlab.io/modern-cmake/chapters/projects/submodule.html
    find_package(Git QUIET)
    if (GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
      option (GIT_SUBMODULE "Check submodules during build" ON)
      if (GIT_SUBMODULE)
	message (STATUS "Submodule update")
	execute_process (
	  COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
	  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	  RESULT_VARIABLE GIT_SUBMODULE_RESULT
	  )
	if (NOT GIT_SUBMODULE_RESULT EQUAL "0")
	  message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMODULE_RESULT}, please checkout submodules")
	endif ()
      endif ()
    endif ()
    message("add_subdirectory")
    add_subdirectory(extern/gFTL)
  endif ()
endif()

find_package(GFTL_SHARED QUIET)
if (NOT GFTL_SHARED_FOUND)
  if (NOT TARGET gftl-shared)
    # from https://cliutils.gitlab.io/modern-cmake/chapters/projects/submodule.html
    find_package(Git QUIET)
    if (GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
      option (GIT_SUBMODULE "Check submodules during build" ON)
      if (GIT_SUBMODULE)
	message (STATUS "Submodule update")
	execute_process (
	  COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
	  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
	  RESULT_VARIABLE GIT_SUBMODULE_RESULT
	  )
	if (NOT GIT_SUBMODULE_RESULT EQUAL "0")
	  message(FATAL_ERROR "git submodule update --init failed with ${GIT_SUBMODULE_RESULT}, please checkout submodules")
	endif ()
      endif ()
    endif ()
    message("add_subdirectory")
    add_subdirectory(extern/gFTL-shared)
  endif ()
endif()

add_subdirectory (src)
if (PFUNIT)
  enable_testing()
  add_custom_target(tests COMMAND ${CMAKE_CTEST_COMMAND})

  add_subdirectory (tests)
endif ()

if (examples)
  add_subdirectory(Examples)
endif()

