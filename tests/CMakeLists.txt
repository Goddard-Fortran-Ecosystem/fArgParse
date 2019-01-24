set(pf_tests
  Test_Cast.pf
  Test_BaseAction.pf
  Test_ArgParser.pf
  )

set(test_srcs)
foreach (file ${pf_tests})
  get_filename_component(basename ${file} NAME_WE)
  set(f90_src ${basename}.F90)
  add_custom_command (
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${f90_src}
    COMMAND python
    ARGS ${PFUNIT}/bin/pFUnitParser.py ${CMAKE_CURRENT_SOURCE_DIR}/${file} ${f90_src}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${file}
    )
  list(APPEND test_srcs ${f90_src})
endforeach()


include_directories(${CMAKE_BINARY_DIR}/src/mod)
include_directories(${PFUNIT}/mod)
include_directories(${fArgParse_BINARY_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${gFTL-shared_install_dir}/mod)

add_library(fargparse_tests EXCLUDE_FROM_ALL ${test_srcs})
target_link_libraries(fargparse_tests fargparse ${PFUNIT}/lib/libpfunit.a)
add_executable (test_fargparse.x EXCLUDE_FROM_ALL ${PFUNIT}/include/driver.F90)
set_source_files_properties(${CMAKE_SOURCE_DIR}/include/driver.F90 PROPERTIES COMPILE_DEFINITIONS _TEST_SUITES="testSuites.inc")
target_link_libraries(test_fargparse.x fargparse_tests)

add_dependencies(tests test_fargparse.x)
add_test(NAME fargparse_tests
  COMMAND test_fargparse.x
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )


