include_directories(${CMAKE_BINARY_DIR}/src/mod)

add_executable(simple.x driver.F90)
target_link_libraries(simple.x fparse)
