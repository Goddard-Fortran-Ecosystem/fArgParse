# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## Unreleased

### Changed

- Added `-quiet` flag for NAG Fortran
- Updated submodule for gFTL-shared (cbb09f4)

## [1.7.0] - 2024-03-04

### Added

- Add Apache 2.0 license (huzzah!)
- Fujitsu compiler support

### Changed

- Updated CI
  - Fix NVIDIA CI
  - Add Intel
  - Remove gcc 9 from macos

## [1.6.0] - 2023-11-29

### Fixed

- Add `-check nouninit` for Intel LLVM to work around [`ifx` bug](https://github.com/HPC-Bugs/reproducers/tree/main/compiler/Fortran/ifx/allocatable).

#### Changed

- Updated submodule for gFTL-shared (v1.7.0)

## [1.5.0] - 2023-04-13

### Added

- Added `IntelLLVM.cmake` file as a copy of `Intel.cmake` to support the LLVM Intel compiler frontends

### Changed

- Updated submodule for gFTL-shared (v1.6.0)

### Fixed

- implemented workaround for GFortran which was not correctly handling
  deferred-length allocatable string arrays.  Used StringVector instead.

## [1.4.2] - 2023-01-23

### Fixed

- Fixes for GNU Make builds
- Update gFTL-shared submodule to v1.5.1


## [1.4.1] 2022-11-07

### Fixed

- Botched a merge in a rush to get previous release out.

## [1.4.0] 2022-11-07

### Added

- "choices" option for parser.  This allows user to select allowed
  strings that actual options must match.  Note that this is slightly
  different than Python ArgParse in that comparison is done on the
  text of the arguments not after conversion.

### Changed

- Switched to use gFTL v2 and gFTL-shared v2 interfaces This
  potentially introduces a subtle backward incompatibility as the
  parse results are technically of a different gFTL map.  Some
  interfaces of those objects have changed.  If anyone needs a patch,
  I'll maintain for a short period.

- Updated GitHub Actions
  - OSs
    - Remove macos-10.15
    - Add ubuntu-22.04 and macos-12
  - Compilers
   - Removed gfortran-8
   - Added gfortran-11
   - Added gfortran-12 (for ubuntu-22.04)
   - Added Intel test (on ubuntu-20.04)

## [1.3.1] 2022-09-15

### Fixed

- Fixed problem where `narguments='+'` was too greedy and absorbed all remaining arguments.  (Issue #105) Reproducing unit test added.

## [1.3.0] 2022-06-02

### Changed

- Updated gFTL-shared submodule version

## [1.2.0] 2022-03-15

### Added

- Added `NVHPC.cmake` file for NVHPC support

### Changed

- Updated git submodules

## [1.1.2] 2021-11-16

### Fixed

 - minor fix in gFTL submodule that eliminates annoying compiler warnings.

## [1.1.1] 2021-11-15

### Fixed

- Allow GFortran to use longer lines.  (Impacts some upstream use cases.)
- Updated external modules that contain bugfixes.

## [1.1.0] 2021-02-06

### Added

- Improved ability to embed within other projects.

### Changed

- Now uses CMake namespaces.   Upstream projects should now link against
  `FARGPARSE::fargparse` insead of just `fargparse'.   Technically this is a 
  not backward compatible, but arguably is just fixing in an incorrect use of 
  CMake.
  

## [1.0.3] 2021-01-31

### Fixed

Updated submodules and made cmake consistent.

## [1.0.2] 2020-02-10

### Changed
- Added flag for position independent code

## [1.0.1] 2020-08-24
- Previous commit missed important compiler workaround
  (masked by subtle compiler issue in gFTL)

## [1.0.0] 2020-08-24

Tempting fate by calling this the 1.0 release.

### Fixed
- Reintroduced some workarounds for older gfortran and intel
  compilers.  
	
## [0.9.5] 2020-05-12
### Changed
- Update submodules (correctly this time)


## [0.9.4] 2020-05-05
### Changed
- Modified defalut name for Pair in Map container
  (Workaround for XLF bug.)
- Updated gFTL/gFTL-shared  

## [0.9.3] - 2020-04-06

### Changed
- Updated gFTL to latest
	
## [0.9.2] - 2019-12-19

### Changed
- Updated gFTL to latest

### Fixed
- Bug fix for extra arguments.

## [0.9.1] - 2019-11-08

### Fixed
- Workaround for compiler hang in ifort 19.0.3
- Updated gFTL for memory leak workaround in ifort 18

## [0.9.0] 2019-09-04
- Updated to use pFUnit 4.0
     
