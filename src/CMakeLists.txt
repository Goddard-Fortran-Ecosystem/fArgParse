
set(srcs
  AbstractArgParser.F90
  BaseAction.F90
  HelpAction.F90
  StoreAction.F90
  StoreConstAction.F90
  StoreTrueAction.F90
  StoreFalseAction.F90
  ActionVector.F90
  StringActionMap.F90

  ArgParser.F90
  Cast.F90
  CommandLineArguments.F90
  ErrorCodes.F90
  KeywordEnforcer.F90
  None.F90

  fParse.F90
  )

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
include_directories(${CMAKE_Fortran_MODULE_DIRECTORY})
include_directories(${fArgParse_SOURCE_DIR}/include)
include_directories(${gFTL_install_dir}/include)
include_directories(${gFTL-shared_install_dir}/mod)

message("one ${gFTL_install_dir}/include")
message("two ${gFTL-shared_install_dir}/include")


add_library(fargparse STATIC ${srcs})
target_link_libraries(fargparse ${gFTL-shared_install_dir}/lib/libgFTL-shared.a)

if (NOT GFTL)
  add_dependencies(fargparse gFTL)
endif()

if (NOT GFTL-SHARED)
  add_dependencies(fargparse gFTL-shared)
endif()


install (TARGETS fargparse DESTINATION lib)
install (DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY}/ DESTINATION include)
