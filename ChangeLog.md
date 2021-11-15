# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
     
