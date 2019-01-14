if (GFTL_SHARED) # use default
  set(gftl_shared_install_dir ${GFTL_SHARED})
else()
  set(gftl_shared_source_dir ${CMAKE_CURRENT_SOURCE_DIR}/gFTL-shared)
  set(gftl_shared_install_dir ${CMAKE_CURRENT_BINARY_DIR}/gFTL-shared/install)

  include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
  file(GLOB all_files ${gftl_shared_source_dir}/*)
  list(LENGTH all_files n_files)

  if(n_files LESS_EQUAL 3)
    # git clone command did not use --recurse-submodules
    set(repository https://github.com/Goddard-Fortran-Ecosystem/gFTL-shared.git)
    set(download_command git submodule init)
    set(update_command git submodule update)
  else()
    set(repository "")
    set(download_command "")
    set(update_command "")
  endif()

  ExternalProject_Add(gFTL-shared
    GIT_REPOSITORY ${repository}
    DOWNLOAD_COMMAND ${download_command}
    UPDATE_COMMAND ${update_command}
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gFTL-shared
    SOURCE_DIR ${gftl_shared_source_dir}
    INSTALL_DIR ${gftl_shared_install_dir}
    BUILD_COMMAND make
    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${gftl_shared_install_dir}  -DCMAKE_INSTALL_MESSAGE=LAZY -DGFTL=${gftl_install_dir}
    INSTALL_COMMAND make install)

  ExternalProject_Add_StepDependencies(gFTL-shared configure gFTL)


endif()
