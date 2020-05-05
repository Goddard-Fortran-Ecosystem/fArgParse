# Compiler specific flags for PGI Fortran compiler

set(CMAKE_Fortran_FLAGS_DEBUG  "-g -O0")
set(CMAKE_Fortran_FLAGS_RELEASE "-O3")
set(CMAKE_Fortran_FLAGS "-g -O0")

#add_definitions(-D_INTEL)
#add_definitions(-D__ifort_18)
