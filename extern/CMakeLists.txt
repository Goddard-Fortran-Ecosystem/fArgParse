# We attempt to use find_package() first for each dependency.  But all
# dependencies are also available as submodules.


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
    add_subdirectory(gFTL)
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
    add_subdirectory(gFTL-shared)
  endif ()
endif()
