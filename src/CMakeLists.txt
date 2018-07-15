
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

  Arg.F90
  ArgParser.F90
  ArgVector.F90
  Cast.F90
  CommandLineArguments.F90
  ErrorCodes.F90
  KeywordEnforcer.F90
  None.F90
  StringUnlimitedMap.F90
  StringVector.F90

  fParse.F90
  )

include_directories(${fParse_SOURCE_DIR}/include)
include_directories(${ftl_install_dir}/include)

add_library(fparse STATIC ${srcs})
if (NOT FTL)
  add_dependencies(fparse gFTL)
endif()


