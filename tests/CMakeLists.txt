set(pf_tests
  Test_Cast.pf
  Test_BaseAction.pf
  Test_ArgParser.pf
  )

add_pfunit_ctest (fargparse_tests
  TEST_SOURCES ${pf_tests}
  LINK_LIBRARIES fargparse
  )

add_dependencies (tests fargparse_tests)

include_directories(${PFUNIT_TOP_DIR}/include)
include_directories(${FARGPARSE_BINARY_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})



