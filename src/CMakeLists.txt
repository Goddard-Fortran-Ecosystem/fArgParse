
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
  StringUnlimitedMap.F90
  StringVector.F90
  IntegerVector.F90
  RealVector.F90

  fParse.F90
  )

set(CMAKE_Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
include_directories(${CMAKE_Fortran_MODULE_DIRECTORY})
include_directories(${fParse_SOURCE_DIR}/include)
include_directories(${gftl_install_dir}/include)


add_library(fparse STATIC ${srcs})
if (NOT GFTL)
  add_dependencies(fparse gFTL)
endif()


install (TARGETS fparse DESTINATION lib)
install (DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY}/ DESTINATION include)
