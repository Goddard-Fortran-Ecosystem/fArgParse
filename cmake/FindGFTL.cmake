if (GFTL) # use default
  set(gFTL_install_dir ${GFTL})
else()
  set(gFTL_source_dir ${CMAKE_CURRENT_SOURCE_DIR}/gFTL)
  set(gFTL_install_dir ${CMAKE_CURRENT_BINARY_DIR}/gFTL/install)

  include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
  file(GLOB all_files ${gFTL_source_dir}/*)
  list(LENGTH all_files n_files)

  if(n_files LESS_EQUAL 3)
    # git clone command did not use --recurse-submodules
    set(repository https://github.com/Goddard-Fortran-Ecosystem/gFTL.git)
    set(download_command git submodule init)
    set(update_command git submodule update)
  else()
    set(repository "")
    set(download_command "")
    set(update_command "")
  endif()

  ExternalProject_Add(gFTL
    GIT_REPOSITORY ${repository}
    DOWNLOAD_COMMAND ${download_command}
    UPDATE_COMMAND ${update_command}
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gFTL
    SOURCE_DIR ${gFTL_source_dir}
    INSTALL_DIR ${gFTL_install_dir}
    BUILD_COMMAND make
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${gFTL_install_dir}  -DCMAKE_INSTALL_MESSAGE=LAZY
    INSTALL_COMMAND make install)

endif()
